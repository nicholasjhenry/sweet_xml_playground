defmodule SweetXmlPlaygroundTest do
  use ExUnit.Case

  import SweetXml

  test "parses document" do
    document = """
    <searchresults>
      <vs c="2" tc="500">
        <v w="10">
          <f n="VIN" v="1FAHP3F22CL447298" />
          <f n="DLRModelYear" v="2012" />
          <f n="DLRMake" v="Ford" />
          <f n="DLRModel" v="Focus" />
          <f n="DLRModelPkg" v="Focus SE Sedan"/>
        </v>
        <v w="10">
          <f n="VIN" v="1FMCU0E75CKC53620" />
          <f n="DLRModelYear" v="2012" />
          <f n="DLRMake" v="Ford" />
          <f n="DLRModel" v="Escape" />
          <f n="DLRModelPkg" v="Escape Limited 4x2" />
        </v>
      </vs>
    </searchresults>
    """

    path = [
      searchresults: [
        ~x"//searchresults",
        vs: [~x"./vs",
          c: ~x"@c"i,
          tc: ~x"@tc"i,
          v: [
            ~x"./v"l,
            w: ~x"@w"i,
            f: [~x"./f"l, n: ~x"./@n"s, v: ~x"./@v"s]
          ]
        ]
      ]
    ]

    actual = xmap(document, path)

    expected = %{
        searchresults: %{
          vs: %{
            c: 2,
            tc: 500,
            v: [
              %{
                f: [
                  %{n: "VIN", v: "1FAHP3F22CL447298"},
                  %{n: "DLRModelYear", v: "2012"},
                  %{n: "DLRMake", v: "Ford"},
                  %{n: "DLRModel", v: "Focus"},
                  %{n: "DLRModelPkg", v: "Focus SE Sedan"}
                ],
                w: 10
              },
              %{
                f: [
                  %{n: "VIN", v: "1FMCU0E75CKC53620"},
                  %{n: "DLRModelYear", v: "2012"},
                  %{n: "DLRMake", v: "Ford"},
                  %{n: "DLRModel", v: "Escape"},
                  %{n: "DLRModelPkg", v: "Escape Limited 4x2"}
                ],
                w: 10
              }
            ]
          }
        }
      }

    assert expected == actual
  end
end
