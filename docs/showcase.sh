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
curl "http://localhost:8086/api/v1/ping" | head -n80
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
curl "http://localhost:8086/api/v1/img?pretty=true" | head -n80
)
echo
echo
read -rsn1

echo "Then we can add some criteria, like limitting the tags"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img?tags=test_tag_3&pretty=true" | head -n80
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
curl "http://localhost:8086/api/v1/img/5c977111be938ff537e16576" | head -n80
)
echo
echo
echo
read -rsn1


echo "---------------------------"
echo "Showcase 4: Putting images"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img/5c977111be938ff537e16576"
read -rsn1
curl "http://localhost:8086/api/v1/img/5c977111be938ff537e16576" -X PUT -d '{"_id":"5c977111be938ff537e16576","title":"new","desc":"Lorem Ipsum dos sit amet","author":"Btapple Lun","uploaderId":"5c9770b9ee78d475e5cae71a","original":{"width":4096,"height":2160,"fileSize":1000000,"link":"5c977111be938ff537e16576","fileId":null,"ext":null},"preview":{"width":409,"height":216,"fileSize":null,"link":"5c977111be938ff537e16576","fileId":null,"ext":null},"tags":[{"name":"test_1","type":"author","desc":null}]}' -H "Content-Type: application/json"
echo
curl "http://localhost:8086/api/v1/img/5c977111be938ff537e16576"
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
curl "http://localhost:8086/api/v1/file/img/5c977111be938ff537e16576.png"
)
echo
echo
echo
read -rsn1

echo "---------------------------"
echo "Showcase 6: Deleting"
read -rsn1
(set -x
curl "http://localhost:8086/api/v1/img/5c977111be938ff537e16576" -X DELETE
)
echo
echo
echo
read -rsn1

