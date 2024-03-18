const map = new maplibregl.Map({
    container: 'map',
    // style: 'https://tiles.basemaps.cartocdn.com/gl/positron-gl-style/style.json',
    style: 'https://4p7a4g7v0f.execute-api.ap-northeast-1.amazonaws.com/prod/geo/style/light.json?key=k05XEXPMlTHxuoPSgMn2jIhfat3EyqAqZfoeZyKfWijM1ujhdvI7dw==',
    center: [139.7212733, 35.6606213],
    zoom: 5,
    pitch: 45,
    bearing: 0
});
let geojsonPoint = {}
fetch("http://0.0.0.0:8000/api/admin/covid/geojson?limit=1000&offset=0")
    .then(res => res.json())
    .then(
        (result) => {
            geojsonPoint = result
            console.log("result", result);
        },
        (error) => {
            console.log("error", error)
        }
    )

map.on('load', async () => {
    const image = await map.loadImage('https://maplibre.org/maplibre-gl-js/docs/assets/custom_marker.png');
    // Add an image to use as a custom marker
    map.addImage('custom-marker', image.data);

    map.addSource('places', {
        'type': 'geojson',
        'data': geojsonPoint
    });

    // Add a layer showing the places.
    map.addLayer({
        'id': 'places',
        'type': 'symbol',
        'source': 'places',
        'layout': {
            'icon-image': 'custom-marker',
            'icon-overlap': 'always'
        }
    });

    // Create a popup, but don't add it to the map yet.
    const popup = new maplibregl.Popup({
        closeButton: false,
        closeOnClick: false
    });

    map.on('mouseenter', 'places', (e) => {
        // Change the cursor style as a UI indicator.
        map.getCanvas().style.cursor = 'pointer';
        hoveredObject = e.features[0]

        const coordinates = hoveredObject.geometry.coordinates.slice();
        // const description = e.features[0].properties;
        const description = `<div>
            <p>lat:${hoveredObject.properties.lat}</p>
            <p>lon:${hoveredObject.properties.lon}</p>
            <p>id:${hoveredObject.properties.id}</p>
            <p>年齢:${hoveredObject.properties.age}</p>
            <p>確定日:${hoveredObject.properties.fixed_data}</p>
        </div>`

        // Ensure that if the map is zoomed out such that multiple
        // copies of the feature are visible, the popup appears
        // over the copy being pointed to.
        while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
            coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
        }

        // Populate the popup and set its coordinates
        // based on the feature found.
        popup.setLngLat(coordinates).setHTML(description).addTo(map);
    });

    map.on('mouseleave', 'places', () => {
        map.getCanvas().style.cursor = '';
        popup.remove();
    });
});