set -ex



rm ../COD4/main_shared -r

cp -r server.cfg maps.cfg main_shared/ ../COD4/

b3_run --config /home/vijayant_saini123/cod4/cod4x-server-B3-configs/b3.xml -r
