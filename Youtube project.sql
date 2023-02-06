-- Youtube Channel Data Exploration

SELECT *
FROM [dbo].[topSubscribed$]

-- Top 10 Most Subscribed Youtube Channel

SELECT Top 10 Rank, [Youtube Channel], Subscribers
FROM [dbo].[topSubscribed$]
Order By 1

-- Top 10 Youtube Category

SELECT Top 10 Category, COUNT(category) Channel_count
FROM [dbo].[topSubscribed$]
Group By Category
Order By 2 DESC

-- Most Succesful Youtube Channel in Recent Years

SELECT [Youtube Channel], Subscribers, max(Started) started
FROM [dbo].[topSubscribed$]
group by [Youtube Channel], Subscribers
Order By 2,3 DESC