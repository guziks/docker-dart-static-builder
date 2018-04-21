FROM google/dart:1
ONBUILD WORKDIR /app
ONBUILD COPY pubspec.* ./
ONBUILD RUN pub get
ONBUILD COPY bin/ bin/
ONBUILD COPY lib/ lib/
ONBUILD RUN dart \
    --snapshot=bin/main.snap \
    bin/main.dart
