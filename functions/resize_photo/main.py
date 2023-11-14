from google.cloud import storage
from PIL import Image
import io

storage_client = storage.Client()


def resize_image(image_content):
    with Image.open(io.BytesIO(image_content)) as img:
        width, height = img.size
        img = img.resize((int(width * 0.25), int(height * 0.25)))
        buffer = io.BytesIO()
        img.save(buffer, 'JPEG')
        return buffer.getvalue()


def Handler(data, context):
    source_bucket_name = 'nationle-og'
    dest_bucket_name = 'nationle-resized'

    file_name = data['name']

    source_bucket = storage_client.bucket(source_bucket_name)
    dest_bucket = storage_client.bucket(dest_bucket_name)

    blob = source_bucket.blob(file_name)
    image_content = blob.download_as_bytes()

    resized_image_content = resize_image(image_content)

    dest_blob = dest_bucket.blob(file_name)
    dest_blob.upload_from_string(resized_image_content, content_type='image/jpeg')

    print(f"Image {file_name} resized and stored in the destination bucket.")
