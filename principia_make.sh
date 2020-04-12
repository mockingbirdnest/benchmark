cmake \
    -DCMAKE_C_COMPILER:FILEPATH=`which clang` \
    -DCMAKE_CXX_COMPILER:FILEPATH=`which clang++` \
    -DCMAKE_C_FLAGS="${C_FLAGS?}" \
    -DCMAKE_CXX_FLAGS="${CXX_FLAGS?}" \
    -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
    .
make -j8
