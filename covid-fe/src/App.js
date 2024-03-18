// Reactのインポート
import React from 'react';
// deck.glを利用
import DeckGL from '@deck.gl/react';
// geojsonを使うのでGeoJsonLayerを利用
import { GeoJsonLayer } from '@deck.gl/layers';
// 背景地図の表示にMapbox GL JSのラッパーを利用
import { Map, Popup } from 'react-map-gl/maplibre';
// import type {MapRef} from 'react-map-gl/maplibre';
import maplibregl from 'maplibre-gl';

// 初期表示位置などを指定
const initialViewState = {
  longitude: 139.7212733,
  latitude: 35.6606213,
  zoom: 5,
  // pitch: 45,
  // bearing: 0,
  interactive: false
};

// 最近は関数ベースのコンポーネントが主流だが、サンプルに合わせてクラスベース
class App extends React.Component {
  // コンストラクターでデータを格納するstateを定義
  constructor(props) {
    super(props);
    this.state = {
      geojsonPoint: null,
    };
  }

  // コンポーネントがマウントされてから動作するメソッド
  // APIにアクセスしてデータを取得しておく
  componentDidMount() {
    fetch("http://0.0.0.0:8000/api/admin/covid/geojson?limit=10000&offset=0")
      .then(res => res.json())
      .then(
        (result) => {
          this.setState({
            geojsonPoint: result
          });
          console.log("result", result);
        },
        (error) => {
          console.log(error)
        }
      )
  }

  // ポップアップを表示させるためのメソッド
  _renderTooltip() {
    // hoveredObjectはホバーしている地物の情報
    const { hoveredObject } = this.state || {};
    console.log("hoveredObject", hoveredObject);
    if (hoveredObject !== undefined) {
      return (
        <Popup
          longitude={hoveredObject.properties.lon}
          latitude={hoveredObject.properties.lat}
        // closeOnClick={true}
        >
          <div>
            <p>id:{hoveredObject.properties.id}</p>
            <p>年齢:{hoveredObject.properties.age}</p>
            <p>確定日:{hoveredObject.properties.fixed_data}</p>
          </div>
        </Popup>
      )
    }
  }
  // renderPopup() {
  //   const { hoveredObject, hoveredCoords } = this.state;
  //   console.log("hoveredObject", hoveredObject);
  //   console.log("hoveredCoords", hoveredCoords);
  //   if (hoveredObject !== null)
  //     return (
  //       hoveredObject && (
  //         <Popup
  //           longitude={hoveredObject.properties.lon}
  //           latitude={hoveredObject.propertiess.lat}
  //           closeButton={true}
  //           closeOnClick={true}
  //           offsetTop={-30}
  //         >
  //           <div>You hovered over this point!</div>
  //         </Popup>
  //       )
  //     );
  // }

  // レンダリング用のメソッド
  render() {
    const { geojsonPoint } = this.state;

    const layers = [
      new GeoJsonLayer({
        id: 'point_layer',
        data: geojsonPoint,
        getPointRadius: d => 2000,
        getFillColor: d => [245, 36, 36, 150],
        pickable: true,
        // onHover: info => this.setState({ hoveredObject: info.object }),
        onclick: info => this.setState({ hoveredObject: info.object }),
      }),
    ];

    return (
      <DeckGL initialViewState={initialViewState} controller={true} layers={layers}>
        <Map
          mapLib={maplibregl}
          mapStyle="https://4p7a4g7v0f.execute-api.ap-northeast-1.amazonaws.com/prod/geo/style/light.json?key=k05XEXPMlTHxuoPSgMn2jIhfat3EyqAqZfoeZyKfWijM1ujhdvI7dw==">
          {/* {this._renderTooltip()} */}
          {this._renderTooltip()}
        </Map>
      </DeckGL>
    );
  }

}

export default App;
