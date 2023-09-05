cp -R ./data-src/.cache/ ./data/;
cp -R ./data-src/.config/ ./data/;
cp -R ./data-src/Desktop/ ./data/;
chown -R 1000:1000 ./data;

chmod +x ./scripts/vnc_startup.sh
chmod +x ./data/Desktop/knime.desktop