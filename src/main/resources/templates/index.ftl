<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>와이페이 맵</title>
        <style>
            #mapwrap{position:relative;overflow:hidden;}
            .category, .category *{margin:0;padding:0;color:#000;}
            .logo {position:absolute;overflow:hidden;top:10px;left:7px;z-index:10;border:1px solid black;font-family:'Malgun Gothic','맑은 고딕',sans-serif;font-size:12px;text-align:center;background-color:#fff;}
            .bottom {position:absolute;overflow:hidden;right:10px;bottom:20px;z-index:10;border:1px solid black;font-family:'Malgun Gothic','맑은 고딕',sans-serif;font-size:12px;text-align:center;background-color:#fff;}
            .category {position:absolute;overflow:hidden;top:10px;left:60px;width:250px;height:50px;z-index:10;border:1px solid black;font-family:'Malgun Gothic','맑은 고딕',sans-serif;font-size:12px;text-align:center;background-color:#fff;}
            .category .menu_selected {background:#FF5F4A;color:#fff;border-left:1px solid #915B2F;border-right:1px solid #915B2F;margin:0 -1px;}
            .category li{list-style:none;float:left;width:50px;height:45px;padding-top:5px;cursor:pointer;}
            .category .ico_comm {display:block;margin:0 auto 2px;width:22px;height:26px;background:url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/category.png') no-repeat;}
            .category .ico_coffee {background-position:-10px 0;}
            .category .ico_store {background-position:-10px -36px;}
            .category .ico_carpark {background-position:-10px -72px;}
            .category .ico_store2 {margin:0;background:url('/static/img/basket.png') no-repeat;}
        </style>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="author" content="고재성" />
        <meta name="description" content="Y페이-맵 : 용인 지역화폐 사용처를 카테고리 별로 알려주는 서비스입니다." />
        <meta name="keywords" content="경기화폐, 와이페이, 용인" />
        <meta property="og:title" content="Y페이-맵" />
        <meta property="og:description" content="Y페이-맵 : 용인 지역화폐 사용처를 카테고리 별로 알려주는 서비스입니다." />
        <meta property="og:image" content="./img/ypay_logo.png" />
        <meta property="og:url" content="https://ypay.map/" />
        <meta name="viewport"
              content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    </head>
<body>
<div id="mapwrap">
    <!-- 지도가 표시될 div -->
    <div id="map" style="width:100%;height:100vh;"></div>
    <!-- 지도 위에 표시될 마커 카테고리 -->
    <div class="logo">
        <img src="./img/ypay_logo.png" style="display:block;margin:0 auto 2px;width:45px;height:60px;">
    </div>
    <div class="bottom">
        <a href="#" onclick="getCurrentLocation()">
            <img src="./img/location.png" style="display:block;margin:0 auto 2px;width:27px;height:27px;">
        </a>
    </div>

    <div class="category">
        <ul>
            <li onclick="getData('basket')">
                <img src="./img/basket.png" style="display:block;margin:0 auto 2px;width:22px;height:26px;">
                식품
            </li>
            <li onclick="getData('note')">
                <img src="./img/note.png" style="display:block;margin:0 auto 2px;width:22px;height:26px;">
                학원
            </li>
            <li onclick="getData('hospital')">
                <img src="./img/hospital.png" style="display:block;margin:0 auto 2px;width:22px;height:26px;">
                의료
            </li>
            <li onclick="getData('hair')">
                <img src="./img/hair.png" style="display:block;margin:0 auto 2px;width:22px;height:26px;">
                미용원
            </li>
            <li onclick="getData('restaurant')">
                <img src="./img/restaurant.png" style="display:block;margin:0 auto 2px;width:22px;height:26px;">
                식당
            </li>
        </ul>
    </div>
</div>
<!-- services와 clusterer, drawing 라이브러리 불러오기 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cd7842b1f0e77ad39555e1b61bf917bf&libraries=services,clusterer,drawing"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="  crossorigin="anonymous"></script>
<script>


    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(37.240768592, 127.17746482), // 지도의 중심좌표, 용인시청
            level: 3 // 지도의 확대 레벨
        };

    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
    var infowindow = new kakao.maps.InfoWindow({zIndex:1 , removable : true});

    var markers = []; // 마커를 담을 배열입니다
    var ypay_places = [];

    getCurrentLocation();


    function getCurrentLocation(){
        // HTML5의 geolocation으로 사용할 수 있는지 확인합니다
        if (navigator.geolocation) {
            // GeoLocation을 이용해서 접속 위치를 얻어옵니다
            navigator.geolocation.getCurrentPosition(function(position) {
                var lat = position.coords.latitude, // 위도
                    lon = position.coords.longitude; // 경도
                var locPosition = new kakao.maps.LatLng(lat, lon); // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
                // 지도 중심좌표를 접속위치로 변경합니다
                map.setCenter(locPosition);
            });

        }
    }

    function removeMarker() {
        for ( var i = 0; i < markers.length; i++ ) {
            markers[i].setMap(null);
        }
        markers = [];
        ypay_places = [];
        infowindow.close();
    }



    function getData(category) {
        // 지도에 표시되고 있는 마커를 제거합니다
        removeMarker();

        var jsonLocation = './json/basket.json';

        if( category != '') {
            jsonLocation = './json/' + category + '.json';
        }

        $.getJSON(jsonLocation, function (data) {
            $.each(data, function (i, item) {
                if (item.REFINE_WGS84_LAT != '' && item.REFINE_WGS84_LOGT != ''){
                    savePlaces(item);
                }
            });
            console.log("finish load data!");

            $.each(ypay_places, function (i, ypay_place) {
                displayPlaces(ypay_place);
            });
        });

    }

    function savePlaces(item) {
        // console.log("====== savePlaces : " +item.REFINE_WGS84_LAT  + ", " + item.REFINE_WGS84_LOGT + ", " + item.CMPNM_NM);
        ypay_places.push({
            position : new kakao.maps.LatLng(item.REFINE_WGS84_LAT, item.REFINE_WGS84_LOGT),
            CMPNM_NM : item.CMPNM_NM,
            TELNO : item.TELNO,
            REFINE_LOTNO_ADDR : item.REFINE_LOTNO_ADDR,
            INDUTYPE_NM : item.INDUTYPE_NM
        });

    }

    function displayPlaces(ypay_place) {

            // 마커를 생성하고 지도에 표시합니다
            var marker = new kakao.maps.Marker({
                            position: ypay_place.position
                        });
            marker.setMap(map);
            markers.push(marker);

            // 마커에 클릭이벤트를 등록합니다
            kakao.maps.event.addListener(marker, 'click', function() {
                // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
                infowindow.setContent('<div style="padding:5px;font-size:12px;">' + ypay_place.CMPNM_NM
                                            + '<br>' + '<a href=tel:"'+ ypay_place.TELNO + '">' + ypay_place.TELNO </a>
                                            + '<br>' + ypay_place.REFINE_LOTNO_ADDR
                                            + '<br>' + ypay_place.INDUTYPE_NM
                                      + '</div>');
                infowindow.open(map, marker);
            });

    }

    function getFileData(category) {
        basket_file = [];
        note_file = [];
        hospital_file = [];
        hair_file = [];
        restaurant_file = [];

        var jsonLocation = './json/yongin.json';

        $.getJSON(jsonLocation, function (data) {
            $.each(data, function (i, item) {
                if (item.REFINE_WGS84_LAT != '' && item.REFINE_WGS84_LOGT != '') {
                    if (category == 'basket') {
                        if (item.INDUTYPE_NM.indexOf('유통업영') > -1 || item.INDUTYPE_NM.indexOf('음료식품') > -1) {
                            basket_file.push({
                                REFINE_WGS84_LAT : item.REFINE_WGS84_LAT,
                                REFINE_WGS84_LOGT : item.REFINE_WGS84_LOGT,
                                CMPNM_NM : item.CMPNM_NM,
                                TELNO : item.TELNO,
                                REFINE_LOTNO_ADDR : item.REFINE_LOTNO_ADDR,
                                INDUTYPE_NM : item.INDUTYPE_NM
                            });
                        }
                    } else if (category == 'note') {
                        if (item.INDUTYPE_NM.indexOf('학원') > -1) {
                            note_file.push({
                                REFINE_WGS84_LAT : item.REFINE_WGS84_LAT,
                                REFINE_WGS84_LOGT : item.REFINE_WGS84_LOGT,
                                CMPNM_NM : item.CMPNM_NM,
                                TELNO : item.TELNO,
                                REFINE_LOTNO_ADDR : item.REFINE_LOTNO_ADDR,
                                INDUTYPE_NM : item.INDUTYPE_NM
                            });
                        }
                    } else if (category == 'hospital') {
                        if (item.INDUTYPE_NM.indexOf('의원') > -1 || item.INDUTYPE_NM.indexOf('병원') > -1 || item.INDUTYPE_NM.indexOf('약국') > -1) {
                            hospital_file.push({
                                REFINE_WGS84_LAT : item.REFINE_WGS84_LAT,
                                REFINE_WGS84_LOGT : item.REFINE_WGS84_LOGT,
                                CMPNM_NM : item.CMPNM_NM,
                                TELNO : item.TELNO,
                                REFINE_LOTNO_ADDR : item.REFINE_LOTNO_ADDR,
                                INDUTYPE_NM : item.INDUTYPE_NM
                            });
                        }
                    } else if (category == 'hair') {
                        if (item.INDUTYPE_NM.indexOf('미용원') > -1) {
                            hair_file.push({
                                REFINE_WGS84_LAT : item.REFINE_WGS84_LAT,
                                REFINE_WGS84_LOGT : item.REFINE_WGS84_LOGT,
                                CMPNM_NM : item.CMPNM_NM,
                                TELNO : item.TELNO,
                                REFINE_LOTNO_ADDR : item.REFINE_LOTNO_ADDR,
                                INDUTYPE_NM : item.INDUTYPE_NM
                            });
                        }
                    } else if (category == 'restaurant') {
                        if (item.INDUTYPE_NM.indexOf('일반휴게음식') > -1) {
                            restaurant_file.push({
                                REFINE_WGS84_LAT : item.REFINE_WGS84_LAT,
                                REFINE_WGS84_LOGT : item.REFINE_WGS84_LOGT,
                                CMPNM_NM : item.CMPNM_NM,
                                TELNO : item.TELNO,
                                REFINE_LOTNO_ADDR : item.REFINE_LOTNO_ADDR,
                                INDUTYPE_NM : item.INDUTYPE_NM
                            });
                        }
                    }
                }
            });
        });
    }


</script>
</body>
</html>