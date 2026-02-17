from PIL import Image, ImageDraw, ImageFont
import os

def create_icon(size, filename):
    img = Image.new('RGB', (size, size), color = '#0047AB') # Cobalt Blue
    d = ImageDraw.Draw(img)
    
    # Draw simple shield-like shape
    margin = size // 5
    coords = [
        (margin, margin),
        (size - margin, margin),
        (size - margin, size - margin * 1.5),
        (size // 2, size - margin),
        (margin, size - margin * 1.5)
    ]
    d.polygon(coords, fill='#FFFFFF')
    
    # Draw text
    # Since we might not have a font, we'll just stick to the shape or basic load_default
    
    img.save(filename)

sizes = [
    (20, "20x20"), (29, "29x29"), (40, "40x40"), (60, "60x60"), (76, "76x76"), (83, "83.5x83.5"), (1024, "1024x1024")
]

base_path = "ios/App/Assets.xcassets/AppIcon.appiconset"
os.makedirs(base_path, exist_ok=True)

for s, name in sizes:
    for scale in [1, 2, 3]:
        pixel_size = int(s * scale)
        if name == "1024x1024" and scale > 1: continue
        
        file_name = f"{base_path}/Icon-{name}@{scale}x.png"
        if scale == 1:
            file_name = f"{base_path}/Icon-{name}.png"
            
        create_icon(pixel_size, file_name)
