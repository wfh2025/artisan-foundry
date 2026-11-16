# change into the python directory
cd python_bindings

# build the extension
python3 setup.py build_ext --inplace

# run unittest
python3 -m unittest -v 