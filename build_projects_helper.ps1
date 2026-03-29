# This script helps creating project files for benchmark.  The argument is the path of benchmark/.
# It produces two pairs of *.vcxproj, *.vcxproj.filters files: one for the project itself, one for its tests.

$dir = resolve-path $args[0]

$filtersheaders = "  <ItemGroup>`r`n"
$vcxprojheaders = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\include\*" -Recurse -Include *.h | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*include\\", "..\include\"
  $filtersheaders +=
      "    <ClInclude Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Header Files</Filter>`r`n" +
      "    </ClInclude>`r`n"
  $vcxprojheaders +=
      "    <ClInclude Include=`"$msvcrelativepath`" />`r`n"
}
$filtersheaders += "  </ItemGroup>`r`n"
$vcxprojheaders += "  </ItemGroup>`r`n"

$filterssources = "  <ItemGroup>`r`n"
$vcxprojsources = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\src\*" -Include *.h | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*src\\", "..\src\"
  $filterssources +=
      "    <ClInclude Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Source Files</Filter>`r`n" +
      "    </ClInclude>`r`n"
  $vcxprojsources +=
      "    <ClInclude Include=`"$msvcrelativepath`" />`r`n"
}
Get-ChildItem "$dir\src\*" -Include *.cc | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*src\\", "..\src\"
  $filterssources +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Source Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojsources +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
$filterssources += "  </ItemGroup>`r`n"
$vcxprojsources += "  </ItemGroup>`r`n"

$filtersgtests = "  <ItemGroup>`r`n"
$vcxprojgtests = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\test\*" -Include *_gtest.cc | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*test\\", "..\test\"
  $filtersgtests +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Source Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojgtests +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
$filtersgtests += "  </ItemGroup>`r`n"
$vcxprojgtests += "  </ItemGroup>`r`n"

$filtersbtests = "  <ItemGroup>`r`n"
$vcxprojbtests = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\test\*" -Include *_test.cc | `
Select-String -Pattern "BENCHMARK_MAIN" | `
Foreach-Object {
  $msvcrelativepath = $_.Path -replace ".*test\\", "..\test\"
  $filtersbtests +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Source Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojbtests +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
$filtersbtests += "  </ItemGroup>`r`n"
$vcxprojbtests += "  </ItemGroup>`r`n"

$filtersotests = "  <ItemGroup>`r`n"
$vcxprojotests = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\test\*" -Include *_test.cc,*output_test_helper.cc -Exclude *cxx11_test.cc | `
Where-Object { !( $_ | Select-String -Pattern "BENCHMARK_MAIN" -Quiet) } | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*test\\", "..\test\"
  $filtersotests +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Source Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojotests +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
$filtersotests += "  </ItemGroup>`r`n"
$vcxprojotests += "  </ItemGroup>`r`n"

$dirfilterspath = [string]::format("{0}\benchmark_vcxproj_filters.txt", $dir)
[system.io.file]::writealltext(
    $dirfilterspath,
    $filtersheaders + $filterssources,
    [system.text.encoding]::utf8)

$gtestsfilterspath = [string]::format("{0}\benchmark_gtest_vcxproj_filters.txt", $dir)
[system.io.file]::writealltext(
    $gtestsfilterspath,
    $filtersgtests,
    [system.text.encoding]::utf8)

$btestsfilterspath = [string]::format("{0}\benchmark_benchmark_test_vcxproj_filters.txt", $dir)
[system.io.file]::writealltext(
    $btestsfilterspath,
    $filtersbtests,
    [system.text.encoding]::utf8)

$otestsfilterspath = [string]::format("{0}\benchmark_other_test_vcxproj_filters.txt", $dir)
[system.io.file]::writealltext(
    $otestsfilterspath,
    $filtersotests,
    [system.text.encoding]::utf8)

$dirvcxprojpath = [string]::format("{0}\benchmark_vcxproj.txt", $dir)
[system.io.file]::writealltext(
    $dirvcxprojpath,
    $vcxprojheaders + $vcxprojsources,
    [system.text.encoding]::utf8)

$gtestsvcxprojpath = [string]::format("{0}\benchmark_gtest_vcxproj.txt", $dir)
[system.io.file]::writealltext(
    $gtestsvcxprojpath,
    $vcxprojgtests,
    [system.text.encoding]::utf8)

$btestsvcxprojpath = [string]::format("{0}\benchmark_benchmark_test_vcxproj.txt", $dir)
[system.io.file]::writealltext(
    $btestsvcxprojpath,
    $vcxprojbtests,
    [system.text.encoding]::utf8)

$otestsvcxprojpath = [string]::format("{0}\benchmark_other_test_vcxproj.txt", $dir)
[system.io.file]::writealltext(
    $otestsvcxprojpath,
    $vcxprojotests,
    [system.text.encoding]::utf8)
