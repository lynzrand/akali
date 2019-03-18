#! /bin/bash

clear

echo "Akali Showcase v0.0.2"
echo "Make sure Akali is running in the local computer\n, and listening on localhost:8086."
read -rsn1

echo
echo "---------------------------"
echo "Showcase 1: pinging the server"
echo "API: /ping"
(set -x
curl "http://localhost:8086/api/v1/ping" | head -n50
)
echo
echo
echo
read -rsn1

echo "---------------------------"
echo "Showcase 2: Requesting image list"
echo "The following API retrieves the whole image list from the newest ones, with a default limit of 20 images."
echo "API: /img"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img?pretty=true" | head -n27
)
echo
echo
read -rsn1

echo "Then we can add some criteria, like limitting the tags"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img?tags=test_tag_3&pretty=true" | head -n27
)
echo
echo
read -rsn1

echo "Or limitting the size"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img?minWidth=1000&pretty=true" | head -n27
)
echo
echo
echo
read -rsn1


echo "---------------------------"
echo "Showcase 3: Query single images"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img/5c25cec2fd72af4c5c02b538" | head -n27
)
echo
echo
echo
read -rsn1


echo "---------------------------"
echo "Showcase 4: Putting images"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img/5c8867c3e25fcaf8e694fe40"
read -rsn1
curl "http://localhost:8086/api/v1/img/5c8867c3e25fcaf8e694fe40" -X PUT -d '{"_id":"5c8867c3e25fcaf8e694fe40","title":"New Title","desc":"This is a test","author":"Btapple Lun","uploaderId":"2345678910abcdef","link":"https://upload.wikimedia.org/wikipedia/commons/8/8d/Shadowsocks_logo.png","fileSize":120000,"width":1500,"height":500,"previewLink":"https://upload.wikimedia.org/wikipedia/commons/8/8d/Shadowsocks_logo.png","previewWidth":200,"previewHeight":200,"tags":["test_tag_0","test_tag_1","test_tag_2"]}' -H "Content-Type: application/json"
echo
curl "http://localhost:8086/api/v1/img/5c8867c3e25fcaf8e694fe40"
)
echo
echo
echo
read -rsn1

echo "---------------------------"
echo "Showcase 5: Uploading images and retrieving"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img/" -X POST -T @post_showcase.png -H "Content-Type: image/png"
echo
read -rsn1
curl "http://localhost:8086/api/v1/file/img/5c25cec2fd72af4c5c02b538.png"
)
echo
echo
echo
read -rsn1

echo "---------------------------"
echo "Showcase 6: Deleting"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img/5c25cec2fd72af4c5c02b538" -X DELETE
)
echo
echo
echo
read -rsn1

