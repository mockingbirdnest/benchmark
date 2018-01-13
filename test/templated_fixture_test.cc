
#include "benchmark/benchmark.h"

#include <cassert>
#include <memory>

template<typename T>
class MyTemplatedFixture : public ::benchmark::Fixture {
public:
  MyTemplatedFixture() : data(0) {}

  T data;
};

BENCHMARK_TEMPLATE_F(MyTemplatedFixture, Foo, int)(benchmark::State &st) {
  for (auto _ : st) {
    data += 1;
  }
}

BENCHMARK_TEMPLATE_DEFINE_F(MyTemplatedFixture, Bar, double)(benchmark::State& st) {
  for (auto _ : st) {
    data += 1.0;
  }
}
BENCHMARK_REGISTER_F(MyTemplatedFixture, Bar);

#if !defined(_MSC_VER)
BENCHMARK_MAIN()
#endif
