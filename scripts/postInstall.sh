cp -R ./data-src/.cache/ ./data/;
cp -R ./data-src/.config/ ./data/;
cp -R ./data-src/Desktop/ ./data/;
chown -R 1000:1000 ./data;

mv ./scripts/knime.desktop ./data/Desktop