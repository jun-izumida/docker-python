FROM python:3.8-slim-buster

ENV PYTHONDONTWRITEBYTECODE=1 \
	PYTHONUNBUFFERED=1 \
	ACCEPT_EULA=Y
ENV PATH="${PATH}:/opt/mssql-tools/bin"

RUN apt -y update
RUN apt -y install curl wget sqlite3 gnupg gnupg1 gnupg2 g++
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt -y update \
	&& apt -y install msodbcsql17 mssql-tools
RUN apt clean \
	&& rm -rf /var/lib/apt/lists/*
RUN apt -y update
RUN apt install -y unixodbc-dev libpq-dev

WORKDIR /opt/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app
