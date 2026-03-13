BUILD="./bin"
BIN="FlappyBird"

rm -rf $BUILD
mkdir $BUILD

odin build ./src -out:"$BUILD/$BIN"
