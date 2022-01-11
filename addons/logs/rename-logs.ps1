$Search ='^(?<Name>.+)_(?<Month>\d\d).(?<Day>\d\d).(?<Year>\d\d\d\d).(?<Ext>.*)$'
$Replace ='${Name}_${Year}.${Month}.${Day}.${Ext}'

 Get-ChildItem | where {$_.name -match $Search} | Rename-Item -NewName {$_.name -replace $Search,$Replace}