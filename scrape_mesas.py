# -*- coding: utf-8 -*-#
from requests import get
from lxml.html import fromstring, tostring
from pandas import read_html, melt, concat

all_sites = fromstring(get("http://www.resultados.gob.ar/99/resu/content/telegramas/IMUN02.htm").text)

all_section_links = all_sites.cssselect("a")

all_section_links = all_section_links[0:6]

all_school_tables = []

all_table_results = []
for i in all_section_links:
    try:
        section_html = fromstring(get("http://www.resultados.gob.ar/99/resu/content/telegramas/" + i.get("href")).text)
        section_name = i.text_content().strip()
        print section_name
        all_circuit_links = section_html.cssselect("a")
    except:
        continue

    for j in all_circuit_links:
        try:
            circuit_html = fromstring(get("http://www.resultados.gob.ar/99/resu/content/telegramas/" + j.get("href")).text)
            circuit_code = j.text_content()
            print "\t" + circuit_code
            all_table_links = circuit_html.cssselect("a")
        except:
            continue

        for k in all_table_links:
            try:
                table_html = fromstring(get("http://www.resultados.gob.ar/99/resu/content/telegramas/" + k.get("href")).text)
                table_code = k.text_content()
                print "\t\t" + table_code

                table_table = table_html.cssselect("#TVOTOS")[0]
                results_df = read_html(tostring(table_table))[0]
                results_df.rename(columns={results_df.columns[0]: "partido"}, inplace = True)
                results_melted = melt(results_df, id_vars="partido")

                results_melted.insert(0,"section",section_name)
                results_melted.insert(1, "circuit", circuit_code)
                results_melted.insert(2, "table", table_code)
                all_table_results.append(results_melted)
            except:
                continue


final_df = concat(all_table_results, ignore_index= True)
final_df.to_csv("all_tables_first_part.csv",encoding = "utf-8", index = False)