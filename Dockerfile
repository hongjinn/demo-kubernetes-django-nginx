FROM python:3.8.5

RUN pip install --upgrade pip

WORKDIR /myproject

COPY ./requirements.txt .

RUN pip install -r requirements.txt

COPY . .

ENTRYPOINT ["sh", "entrypoint.sh"]
