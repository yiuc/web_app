FROM python:3.7-alpine 
ADD ./docker /code/
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "app.py"]