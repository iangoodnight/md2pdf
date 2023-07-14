FROM ruby:3.0.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    --fix-missing \
    build-essential \
    libpq-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    wget \
    xvfb \
    libfontconfig1 \
    libjpeg-dev \
    libpng-dev \
    libgif-dev \
    fontconfig \
    libffi-dev \
    ruby-dev \
    gcc \
    make

# Install wkhtmltopdf
RUN wget -q -O wkhtmltox.deb "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb" \
    && apt-get -y install xfonts-75dpi \
    && dpkg -i wkhtmltox.deb \
    && apt-get -f install -y \
    && rm wkhtmltox.deb

# Set up the application directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN gem install bundler -v '2.4.10'
RUN bundle install

# Copy the application files
COPY . .

# Expose the port
EXPOSE 8008

# Set the web server to Puma
ENV WEB_SERVER puma

# Set env
ENV RACK_ENV production

# Run the Ruby server
CMD ["bundle", "exec", "ruby", "app.rb", "-s", "$WEB_SERVER"]

