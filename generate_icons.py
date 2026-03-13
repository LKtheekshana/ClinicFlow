#!/usr/bin/env python3

from PIL import Image, ImageDraw
import os

# Create a base icon (1024x1024) with the design
def create_icon(size):
    # Create image with gradient background
    img = Image.new('RGB', (size, size), color=(22, 38, 112))  # Deep blue
    pixels = img.load()
    
    # Create a gradient effect
    for y in range(size):
        for x in range(size):
            # Linear gradient from deep blue to light blue
            r = int(22 + (56 - 22) * (x + y) / (size * 2))
            g = int(38 + (112 - 38) * (x + y) / (size * 2))
            b = int(112 + (225 - 112) * (x + y) / (size * 2))
            pixels[x, y] = (r, g, b)
    
    draw = ImageDraw.Draw(img)
    center = size // 2
    
    # Draw the circular gradient background for the icon
    circle_size = int(size * 0.65)
    
    # Create a new image for the circle with transparent background
    circle_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    circle_draw = ImageDraw.Draw(circle_img)
    
    # Draw the circular gradient (teal to deep blue)
    # We'll approximate this by drawing the circle with colors
    # and then apply a gradient effect
    circle_draw.ellipse(
        [center - circle_size, center - circle_size,
         center + circle_size, center + circle_size],
        fill=(89, 204, 193)  # Teal color
    )
    
    # Now we need to apply gradient to the circle - let's redraw with gradient simulation
    circle_pixels = circle_img.load()
    for y in range(size):
        for x in range(size):
            dx = x - center
            dy = y - center
            distance = (dx*dx + dy*dy) ** 0.5
            
            if distance <= circle_size:
                # Gradient from teal (89, 204, 193) to dark blue (22, 80, 160)
                ratio = distance / circle_size
                r = int(89 * (1 - ratio) + 22 * ratio)
                g = int(204 * (1 - ratio) + 80 * ratio)
                b = int(193 * (1 - ratio) + 160 * ratio)
                circle_pixels[x, y] = (r, g, b, 255)
    
    # Paste the circle onto the main image
    img.paste(circle_img, (0, 0), circle_img)
    
    draw = ImageDraw.Draw(img)
    
    # Draw the white plus/cross shape
    plus_size = int(size * 0.25)
    plus_thickness = int(size * 0.08)
    
    plus_x1 = center - plus_size
    plus_x2 = center + plus_size
    plus_y1 = center - plus_size
    plus_y2 = center + plus_size
    
    # Vertical bar of plus
    draw.rectangle(
        [center - plus_thickness // 2, plus_y1,
         center + plus_thickness // 2, plus_y2],
        fill=(255, 255, 255)
    )
    
    # Horizontal bar of plus
    draw.rectangle(
        [plus_x1, center - plus_thickness // 2,
         plus_x2, center + plus_thickness // 2],
        fill=(255, 255, 255)
    )
    
    # Draw the ECG/heartbeat line through the middle
    line_y = center
    line_thickness = int(size * 0.012)
    
    # Create the heartbeat pattern (simple zigzag)
    ecg_width = int(size * 0.35)
    ecg_start_x = center - ecg_width
    ecg_end_x = center + ecg_width
    
    # Points for heartbeat line
    ecg_points = []
    segment_width = ecg_width // 12
    
    # Create heartbeat pattern
    y_offset = int(size * 0.04)
    for i in range(13):
        x = ecg_start_x + i * segment_width
        
        if i < 2:
            y = line_y  # flat start
        elif i == 2:
            y = line_y - y_offset  # go up
        elif i == 3:
            y = line_y + y_offset  # go down
        elif i == 4:
            y = line_y - y_offset * 1.5  # go up more
        elif i == 5:
            y = line_y + y_offset * 1.5  # go down more
        elif i == 6:
            y = line_y  # back to center
        elif i < 10:
            y = line_y  # flat middle
        elif i == 10:
            y = line_y - y_offset * 0.5  # small bump
        elif i == 11:
            y = line_y + y_offset * 0.5  # small dip
        else:
            y = line_y  # flat end
        
        ecg_points.append((x, int(y)))
    
    # Draw the heartbeat line
    for i in range(len(ecg_points) - 1):
        x1, y1 = ecg_points[i]
        x2, y2 = ecg_points[i + 1]
        draw.line([(x1, y1), (x2, y2)], fill=(89, 204, 193), width=line_thickness)
    
    return img

# Generate all required sizes
sizes = {
    'app-icon-20@2x.png': 40,
    'app-icon-20@3x.png': 60,
    'app-icon-29@2x.png': 58,
    'app-icon-29@3x.png': 87,
    'app-icon-40@2x.png': 80,
    'app-icon-40@3x.png': 120,
    'app-icon-60@2x.png': 120,
    'app-icon-60@3x.png': 180,
    'app-icon-76.png': 76,
    'app-icon-76@2x.png': 152,
    'app-icon-83.5@2x.png': 167,
    'app-icon-1024.png': 1024,
}

output_path = '/Users/cobsccomp242p-031/Theekshana/ClinicFlow/IOS-Clinic-App/ClinicApp/Resources/Assets.xcassets/AppIcon.appiconset/'

# Create base 1024 icon
base_icon = create_icon(1024)

for filename, size in sizes.items():
    if filename == 'app-icon-1024.png':
        icon = base_icon
    else:
        # Resize from base icon
        icon = base_icon.resize((size, size), Image.Resampling.LANCZOS)
    
    # Save the icon
    output_file = output_path + filename
    icon.save(output_file, 'PNG')
    print(f"✓ Generated {filename}")

print("\n✓ All app icons generated successfully!")
print(f"Icons saved to: {output_path}")
