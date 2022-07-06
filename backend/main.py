import base64
from fastapi import FastAPI, File
from segmentation import get_yolov5, get_image_from_bytes
from starlette.responses import Response
import io
from PIL import Image
import json
from fastapi.middleware.cors import CORSMiddleware
import torch



model = get_yolov5()

app = FastAPI(
    title= "YoloV5 Toothbrush detector API",
    description=""" Endpoints designed to obtain object the value out of images
                    and return image and/or a json result with the detected objects. The original 
                    code was modified by Lucas Argento to work with Flutter Frontend for the ToothBro Project. 
                    Product Design - University of Buenos Aires, Faculty of Engineering 2022.""",
    version="0.0.1",
)

origins = [
    "http://localhost",
    "http://localhost:8000",
    "http://localhost:58359",
    "https://dpcepillo.web.app/",
    "*"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get('/notify/v1/health')
def get_health():
    """
    Usage on K8S
    readinessProbe:
        httpGet:
            path: /notify/v1/health
            port: 80
    livenessProbe:
        httpGet:
            path: /notify/v1/health
            port: 80
    :return:
        dict(msg='OK')
    """
    return dict(msg='OK')

@app.post("/object-to-json")
async def detect_return_json_result(file: bytes = File(...)):
    '''
    This is the endpoint used by the flutter frontend. An image file must be passed to the function and it will return a json
    response with the detected objetcs.
    '''
    input_image = get_image_from_bytes(file)
    results = model(input_image)
    detect_res = results.pandas().xyxy[0].to_json(orient="records")  # JSON img1 predictions
    detect_res = json.loads(detect_res)
    return {"result": detect_res}


@app.post("/object-to-img")
async def detect_return_base64_img(file: bytes = File(...)):
    input_image = get_image_from_bytes(file)
    results = model(input_image)
    results.render()  # updates results.imgs with boxes and labels
    for img in results.imgs:
        bytes_io = io.BytesIO()
        img_base64 = Image.fromarray(img)
        img_base64.save(bytes_io, format="jpeg")
    return Response(content=bytes_io.getvalue(), media_type="image/jpeg")
