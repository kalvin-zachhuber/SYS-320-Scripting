. "$PSScriptRoot\scrape.ps1" 


$FullTable = daysTranslator (gatherClasses)

#$FullTable | where { ($_.Location -ilike "*JOYC 310*") -and ($_.Days -contains "Monday") } | `
  	     #Sort-Object "Time Start" | `
  	     #Select-Object "Time Start", "Time End", "Class Code"

#$FullTable |
  #where { $_.'Instructor' -ilike 'Furkan Paligu' } |
  #select 'Class Code', Instructor, Location, Days, 'Time Start','Time End'


$ITSInstructors = $FullTable | where { ($_."Class Code" -ilike "SYS*") -or `
					      ($_."Class Code" -ilike "SYS*") -or `
					      ($_."Class Code" -ilike "NET*") -or `								
             				      ($_."Class Code" -ilike "SEC*") -or `
                			      ($_."Class Code" -ilike "FOR*") -or `
                 			      ($_."Class Code" -ilike "CSI*") -or `
                			      ($_."Class Code" -ilike "DAT*") } `
 			     | Select-Object "Instructor" `
 			     | Sort-Object  "Instructor" -Unique

#$ITSInstructors

$FullTable |
  Where-Object { $_.Instructor -in $ITSInstructors.Instructor } |
  Group-Object "Instructor" |
  Select-Object Count,Name |
  Sort-Object Count -Descending

