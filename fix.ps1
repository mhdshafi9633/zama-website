$file = "index.html"
$text = [System.IO.File]::ReadAllText($file)
$text = $text.Replace("`r`n", "`n")

# Replace PRESETS array with the 7 Vector Gradient Presets
$startStr = "const PRESETS = ["
$endStr = "];"

$startPos = $text.IndexOf($startStr)
$endPos = $text.IndexOf($endStr, $startPos) + $endStr.Length

$newPresets = @"
const PRESETS = [
            // ==========================================
            // 🌈 VECTOR GRADIENT PRESET COLLECTION (7 PALETTES)
            // ==========================================
            {
                name: '1. Golden Sunset',
                gradStart: '#FFB300', gradEnd: '#E65100',
                primary: '#FFFFFF', icon: '#FFFFFF',
                'th-fill': 'rgba(0,0,0,0.35)', 'th-text': '#FFFFFF',
                border: 'rgba(255,255,255,0.7)', 'body-text': '#FFFFFF',
                contact: '#FFFFFF', btn: '#E65100', accent: '#FFD54F',
                logo: 'white', instaColor: '#FFFFFF',
                dots: ['#FFB300', '#F57C00', '#E65100']
            },
            {
                name: '2. Vivid Magenta Purple',
                gradStart: '#E91E63', gradEnd: '#311B92',
                primary: '#FFFFFF', icon: '#FFFFFF',
                'th-fill': 'rgba(0,0,0,0.35)', 'th-text': '#FFFFFF',
                border: 'rgba(255,255,255,0.7)', 'body-text': '#FFFFFF',
                contact: '#FFFFFF', btn: '#8E24AA', accent: '#F48FB1',
                logo: 'white', instaColor: '#FFFFFF',
                dots: ['#E91E63', '#7B1FA2', '#311B92']
            },
            {
                name: '3. Coral Crimson Purple',
                gradStart: '#FF3D00', gradEnd: '#4A148C',
                primary: '#FFFFFF', icon: '#FFFFFF',
                'th-fill': 'rgba(0,0,0,0.35)', 'th-text': '#FFFFFF',
                border: 'rgba(255,255,255,0.7)', 'body-text': '#FFFFFF',
                contact: '#FFFFFF', btn: '#D50000', accent: '#FF8A80',
                logo: 'white', instaColor: '#FFFFFF',
                dots: ['#FF3D00', '#8E24AA', '#4A148C']
            },
            {
                name: '4. Cyber Cyan Ocean',
                gradStart: '#00B0FF', gradEnd: '#0D47A1',
                primary: '#FFFFFF', icon: '#FFFFFF',
                'th-fill': 'rgba(0,0,0,0.35)', 'th-text': '#FFFFFF',
                border: 'rgba(255,255,255,0.7)', 'body-text': '#FFFFFF',
                contact: '#FFFFFF', btn: '#0091EA', accent: '#80D8FF',
                logo: 'white', instaColor: '#FFFFFF',
                dots: ['#00B0FF', '#0288D1', '#0D47A1']
            },
            {
                name: '5. Royal Indigo Violet',
                gradStart: '#3D5AFE', gradEnd: '#1A237E',
                primary: '#FFFFFF', icon: '#FFFFFF',
                'th-fill': 'rgba(0,0,0,0.35)', 'th-text': '#FFFFFF',
                border: 'rgba(255,255,255,0.7)', 'body-text': '#FFFFFF',
                contact: '#FFFFFF', btn: '#304FFE', accent: '#8C9EFF',
                logo: 'white', instaColor: '#FFFFFF',
                dots: ['#3D5AFE', '#283593', '#1A237E']
            },
            {
                name: '6. Electric Azure Sky',
                gradStart: '#00B0FF', gradEnd: '#01579B',
                primary: '#FFFFFF', icon: '#FFFFFF',
                'th-fill': 'rgba(0,0,0,0.35)', 'th-text': '#FFFFFF',
                border: 'rgba(255,255,255,0.7)', 'body-text': '#FFFFFF',
                contact: '#FFFFFF', btn: '#0091EA', accent: '#80D8FF',
                logo: 'white', instaColor: '#FFFFFF',
                dots: ['#00B0FF', '#0288D1', '#01579B']
            },
            {
                name: '7. Fiery Crimson Maroon',
                gradStart: '#FF1744', gradEnd: '#4A0007',
                primary: '#FFFFFF', icon: '#FFFFFF',
                'th-fill': 'rgba(0,0,0,0.35)', 'th-text': '#FFFFFF',
                border: 'rgba(255,255,255,0.7)', 'body-text': '#FFFFFF',
                contact: '#FFFFFF', btn: '#D50000', accent: '#FF8A80',
                logo: 'white', instaColor: '#FFFFFF',
                dots: ['#FF1744', '#880E4F', '#4A0007']
            }
        ];
"@

if ($startPos -ge 0 -and $endPos -gt $startPos) {
    $text = $text.Substring(0, $startPos) + $newPresets + $text.Substring($endPos)
}

# Update buildPresets to show linear-gradient background on card
$oldBuildPresets = @"
        function buildPresets() {
            const grid = document.getElementById('presets-grid');
            if (!grid) return;
            grid.innerHTML = '';
            PRESETS.forEach((p, i) => {
                const card = document.createElement('div');
                card.className = 'preset-card' + (i === 0 ? ' active' : '');
                const isDark = isColorDark(p.bg);
                card.style.background = isDark ? p.bg : '#1e293b';
                const nameColor = isDark ? p['body-text'] : '#e2e8f0';
                card.innerHTML = ``<div class="preset-name" style="color:`${nameColor}">${p.name}</div><div class="preset-dots">${p.dots.map(d => `<div class="preset-dot" style="background:${d};border:1px solid #ffffff44"></div>`).join('')}</div>``;
                card.onclick = () => applyPreset(i);
                grid.appendChild(card);
            });
        }
"@

$newBuildPresets = @"
        function buildPresets() {
            const grid = document.getElementById('presets-grid');
            if (!grid) return;
            grid.innerHTML = '';
            PRESETS.forEach((p, i) => {
                const card = document.createElement('div');
                card.className = 'preset-card' + (i === 0 ? ' active' : '');
                card.style.background = ``linear-gradient(135deg, `${p.gradStart}, `${p.gradEnd})`;
                card.innerHTML = ``<div class="preset-name" style="color:#ffffff;text-shadow:0 1px 3px rgba(0,0,0,0.5)">`${p.name}</div><div class="preset-dots">`${p.dots.map(d => `<div class="preset-dot" style="background:`${d};border:1px solid #ffffffaa"></div>`).join('')}</div>``;
                card.onclick = () => applyPreset(i);
                grid.appendChild(card);
            });
        }
"@

$text = $text.Replace($oldBuildPresets, $newBuildPresets)

# Update applyPreset call to applyCanvasBackground
$oldApplyCall = "applyCanvasBackground(p.bg, p.bgOpacity);"
$newApplyCall = "applyCanvasBackground(p);"
$text = $text.Replace($oldApplyCall, $newApplyCall)

# Update renderFullBackground & applyCanvasBackground
$oldRenderFullBg = @"
        function adjustColorBrightness(hex, percent) {
            let num = parseInt((hex || '#ffffff').replace('#', ''), 16);
            if (isNaN(num)) return hex;
            let r = (num >> 16) + Math.round(255 * (percent / 100));
            let g = ((num >> 8) & 0x00FF) + Math.round(255 * (percent / 100));
            let b = (num & 0x0000FF) + Math.round(255 * (percent / 100));
            r = Math.min(255, Math.max(0, r));
            g = Math.min(255, Math.max(0, g));
            b = Math.min(255, Math.max(0, b));
            return '#' + (g | (b << 8) | (r << 16)).toString(16).padStart(6, '0');
        }

        async function renderFullBackground(targetCtx, bgColor, opacity) {
            const baseGrad = targetCtx.createLinearGradient(0, 0, 0, 1350);
            baseGrad.addColorStop(0, '#ffffff');
            baseGrad.addColorStop(1, '#f8fafc');
            targetCtx.fillStyle = baseGrad;
            targetCtx.fillRect(0, 0, 1080, 1350);

            // Load frame 3.jpg if available
            await new Promise(resolve => {
                const img1 = new Image();
                img1.onload = () => {
                    targetCtx.drawImage(img1, 0, 0, 1080, 1350);
                    resolve();
                };
                img1.onerror = () => resolve();
                img1.src = 'frame 3.jpg';
            });

            // Blend GF.png on top with 15% opacity
            await new Promise(resolve => {
                const gfImg = new Image();
                gfImg.onload = () => {
                    targetCtx.save();
                    targetCtx.globalAlpha = 0.15;
                    targetCtx.drawImage(gfImg, 0, 0, 1080, 1350);
                    targetCtx.restore();
                    resolve();
                };
                gfImg.onerror = () => resolve();
                gfImg.src = 'GF.png';
            });

            // Apply smooth theme tint color gradient overlay if opacity > 0
            if (opacity > 0) {
                targetCtx.save();
                targetCtx.globalAlpha = opacity;
                const overlayGrad = targetCtx.createLinearGradient(0, 0, 1080, 1350);
                overlayGrad.addColorStop(0, bgColor);
                overlayGrad.addColorStop(1, adjustColorBrightness(bgColor, -8));
                targetCtx.fillStyle = overlayGrad;
                targetCtx.fillRect(0, 0, 1080, 1350);
                targetCtx.restore();
            }
        }

        function applyCanvasBackground(bgColor, opacity) {
            renderFullBackground(ctx, bgColor, opacity);
        }
"@

$newRenderFullBg = @"
        async function renderFullBackground(targetCtx, preset) {
            const p = preset || PRESETS[0];
            const bgGrad = targetCtx.createLinearGradient(0, 0, 0, 1350);
            bgGrad.addColorStop(0, p.gradStart);
            bgGrad.addColorStop(1, p.gradEnd);
            targetCtx.fillStyle = bgGrad;
            targetCtx.fillRect(0, 0, 1080, 1350);

            // Load frame 3.jpg if available
            await new Promise(resolve => {
                const img1 = new Image();
                img1.onload = () => {
                    targetCtx.drawImage(img1, 0, 0, 1080, 1350);
                    resolve();
                };
                img1.onerror = () => resolve();
                img1.src = 'frame 3.jpg';
            });

            // Blend GF.png on top with 15% opacity
            await new Promise(resolve => {
                const gfImg = new Image();
                gfImg.onload = () => {
                    targetCtx.save();
                    targetCtx.globalAlpha = 0.15;
                    targetCtx.drawImage(gfImg, 0, 0, 1080, 1350);
                    targetCtx.restore();
                    resolve();
                };
                gfImg.onerror = () => resolve();
                gfImg.src = 'GF.png';
            });
        }

        function applyCanvasBackground(preset) {
            renderFullBackground(ctx, preset);
        }
"@

$text = $text.Replace($oldRenderFullBg, $newRenderFullBg)

# Update saveAsJPG call to renderFullBackground
$oldSaveJpgBg = "await renderFullBackground(tempCtx, currentPreset.bg, currentPreset.bgOpacity);"
$newSaveJpgBg = "await renderFullBackground(tempCtx, currentPreset);"
$text = $text.Replace($oldSaveJpgBg, $newSaveJpgBg)

[System.IO.File]::WriteAllText($file, $text)
Write-Host "Updated with 7 Vector Gradient Presets!"
