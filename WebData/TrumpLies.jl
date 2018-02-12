using Cascadia
using Gumbo
using Requests
using DataFrames

r = get("https://www.nytimes.com/interactive/2017/06/23/opinion/trumps-lies.html")
webpage = parsehtml(convert(String, r.data))

allrecords = matchall(Selector(".short-desc"),webpage.root)

df = DataFrame(date=DateTime[], lie=String[], explanation=String[], url=String[])

test = ""
for q = 1:size(allrecords,1)
    # Step 1: extract date and convert to DateTime format
    date = nodeText(allrecords[q][1])[1:end-1]*", 2017"
    date = replace(date, "Sept.", "Sep.")
    date = try Date(date, "u. d, y") catch Date(date, "U d, y") end

    # Step 2: extract lie
    lie = nodeText(allrecords[q][2])[1:end-1]
    x = lie[1]
    y = lie[end]
    lie = replace(lie,x,"")
    lie = replace(lie,y,"")

    # Step 3: extract the explanation
    explanation = nodeText(allrecords[q][3])
    explanation = replace(explanation,"(","")
    explanation = replace(explanation,")","")

    # Step 4: extract the URL
    url = allrecords[q][3][1].attributes["href"]

    # Step 5: put all together in a dataframe
    temp = DataFrame(date=date, lie=lie, explanation=explanation, url=url)
    df = [df; temp]
end

# Export the dataframe to a CSV
writetable("trumpLies.csv", df)
