# make build.sh runnable
chmod +x build.sh 

# run build 
echo "BUILDING SOURCE\n==============="
./build.sh

# move into tests, make 
echo "\n\nBUILDING TESTS\n==============="
cd tests
make clean 
make

# run tests
echo "\n\nRUNNING TESTS\n==============="
./testmain