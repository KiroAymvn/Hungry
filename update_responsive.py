#!/usr/bin/env python3
"""
Update Flutter files with responsive sizing
"""
import os
import re

# Define all files to update
FILES = {
    r'd:\Flutter\hungry\lib\features\auth\screens\login_screen.dart': 'login',
    r'd:\Flutter\hungry\lib\features\auth\screens\signup_screen.dart': 'signup',
    r'd:\Flutter\hungry\lib\features\auth\screens\profile_screen.dart': 'profile',
    r'd:\Flutter\hungry\lib\features\cart\screens\cart_screen.dart': 'cart',
    r'd:\Flutter\hungry\lib\features\checkout\screens\checkout_screen.dart': 'checkout',
    r'd:\Flutter\hungry\lib\features\productDetails\screens\product_details_screen.dart': 'product_details',
    r'd:\Flutter\hungry\lib\features\favorite\screen\favorite_screen.dart': 'favorite',
    r'd:\Flutter\hungry\lib\features\orderHistory\screens\order_history_screen.dart': 'order_history',
    r'd:\Flutter\hungry\lib\features\home\widgets\custom_search_field.dart': 'search_field',
    r'd:\Flutter\hungry\lib\features\home\widgets\custom_user_header.dart': 'user_header',
    r'd:\Flutter\hungry\lib\features\home\widgets\custom_food_categories.dart': 'food_categories'
}

def ensure_imports(content):
    """Ensure responsive imports are present"""
    if 'import \'package:responsive_sizer/responsive_sizer.dart\'' not in content:
        # Find last import
        lines = content.split('\n')
        last_import_idx = 0
        for i, line in enumerate(lines):
            if line.startswith('import '):
                last_import_idx = i
        lines.insert(last_import_idx + 1, 'import \'package:responsive_sizer/responsive_sizer.dart\';')
        content = '\n'.join(lines)
    
    if 'import \'package:hungry/core/utils/responsive.dart\'' not in content:
        lines = content.split('\n')
        last_import_idx = 0
        for i, line in enumerate(lines):
            if line.startswith('import '):
                last_import_idx = i
        lines.insert(last_import_idx + 1, 'import \'package:hungry/core/utils/responsive.dart\';')
        content = '\n'.join(lines)
    
    return content

def apply_replacements(content):
    """Apply all responsive sizing replacements"""
    
    # Gap replacements - order matters (larger values first to avoid partial matches)
    replacements = [
        (r'const Gap\(100\)', 'Gap(100.h)'),
        (r'const Gap\(50\)', 'Gap(50.h)'),
        (r'const Gap\(40\)', 'Gap(AppResponsive.gapLarge())'),
        (r'const Gap\(25\)', 'Gap(AppResponsive.gapRegular())'),
        (r'const Gap\(20\)', 'Gap(AppResponsive.gapRegular())'),
        (r'const Gap\(10\)', 'Gap(AppResponsive.gapSmall())'),
        (r'Gap\(100\)', 'Gap(100.h)'),
        (r'Gap\(50\)', 'Gap(50.h)'),
        (r'Gap\(40\)', 'Gap(AppResponsive.gapLarge())'),
        (r'Gap\(25\)', 'Gap(AppResponsive.gapRegular())'),
        (r'Gap\(20\)', 'Gap(AppResponsive.gapRegular())'),
        (r'Gap\(10\)', 'Gap(AppResponsive.gapSmall())'),
        
        # Padding replacements
        (r'const EdgeInsets\.all\(8\.0\)', 'EdgeInsets.all(AppResponsive.paddingSmall())'),
        (r'const EdgeInsets\.all\(8\)', 'EdgeInsets.all(AppResponsive.paddingSmall())'),
        (r'const EdgeInsets\.all\(20\.0\)', 'EdgeInsets.all(AppResponsive.paddingMedium())'),
        (r'const EdgeInsets\.all\(20\)', 'EdgeInsets.all(AppResponsive.paddingMedium())'),
        
        # BorderRadius replacements
        (r'BorderRadius\.circular\(12\)', 'BorderRadius.circular(AppResponsive.radiusMedium())'),
        (r'BorderRadius\.circular\(20\)', 'BorderRadius.circular(AppResponsive.radiusLarge())'),
        (r'BorderRadius\.circular\(25\)', 'BorderRadius.circular(AppResponsive.radiusLarge())'),
        
        # FontSize replacements (with negative lookahead to avoid partial matches)
        (r'fontSize:\s*25(?![0-9])', 'fontSize: AppResponsive.fontSizeHuge()'),
        (r'fontSize:\s*22(?![0-9])', 'fontSize: AppResponsive.fontSizeLarge()'),
        (r'fontSize:\s*20(?![0-9])', 'fontSize: AppResponsive.fontSizeXLarge()'),
        (r'fontSize:\s*16(?![0-9])', 'fontSize: AppResponsive.fontSizeMedium()'),
        (r'fontSize:\s*15(?![0-9])', 'fontSize: AppResponsive.fontSizeRegular()'),
        (r'fontSize:\s*13(?![0-9])', 'fontSize: AppResponsive.fontSizeSmall()'),
        (r'fontSize:\s*30(?![0-9])', 'fontSize: AppResponsive.fontSizeXHuge()'),
        
        # Size replacements (height/width)
        (r'height:\s*110(?![0-9])', 'height: 110.h'),
        (r'height:\s*90(?![0-9])', 'height: 90.h'),
        (r'height:\s*80(?![0-9])', 'height: 80.h'),
        (r'height:\s*60(?![0-9])', 'height: 60.h'),
        (r'height:\s*50(?![0-9])', 'height: 50.h'),
        (r'height:\s*45(?![0-9])', 'height: 45.h'),
        (r'height:\s*40(?![0-9])', 'height: 40.h'),
        
        (r'width:\s*300(?![0-9])', 'width: 300.w'),
        (r'width:\s*200(?![0-9])', 'width: 200.w'),
        (r'width:\s*150(?![0-9])', 'width: 150.w'),
        (r'width:\s*120(?![0-9])', 'width: 120.w'),
        (r'width:\s*110(?![0-9])', 'width: 110.w'),
        (r'width:\s*75(?![0-9])', 'width: 75.w'),
        (r'width:\s*60(?![0-9])', 'width: 60.w'),
    ]
    
    for pattern, replacement in replacements:
        content = re.sub(pattern, replacement, content)
    
    return content

def process_file(filepath):
    """Process a single file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original = content
        
        # Apply transformations
        content = ensure_imports(content)
        content = apply_replacements(content)
        
        # Write back if changed
        if content != original:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return 'UPDATED'
        return 'OK'
    except Exception as e:
        return f'ERROR: {str(e)}'

# Main execution
if __name__ == '__main__':
    print("Flutter Responsive Sizing Update")
    print("=" * 50)
    
    for filepath, name in FILES.items():
        if os.path.exists(filepath):
            result = process_file(filepath)
            print(f"[{result:8}] {name}")
        else:
            print(f"[NOT FOUND] {name}")
    
    print("=" * 50)
    print("Update complete!")
