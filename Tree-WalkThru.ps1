
 param(
        [Parameter(Position=0)]
        [string]$path=$env:temp,
        [Parameter(Position=1)]
        [switch]$pipeline
        )

#Tree.ps1
Trap {"Error !"; $_.exception;  $error; 
        Write-Warning "Pause ..........."
 }
clear All
$error.Clear()
 

Class QFile_SYSTEM
{
    [HASHTABLE]$search_resultH = @{}
    [array]$search_result =@()
    [string]$search_string = $null
    
    QFile_SYSTEM() { $count+= 1 }

    [string]Search_file([string]$FileName, [String]$FromPath)
    {
     $this.search_resultH = @{}

     $this.search_result = @()
     $this.search_string = $FileName
     $this.Get_SubFolder($FromPath, 0 )
     $this.search_result

     return $this.search_result.Count
    } 


    [string]Get_SubFolder ([string]$path, [int]$TabLevel) 
    {

        $TabLevel+=1
        $subdirs = dir $path | where {$_.GetType() -match "DirectoryInfo"}
        if ($subdirs) {
            foreach ($subdir in $subdirs) {

                $subfiles=dir $subdir.fullname | where {$_.GetType() -match "FileInfo"}
                [int]$subcount=$subfiles.count
                Write-Host  "DIRECTORY[$TabLevel]-$($subdir.fullname)" -foregroundcolor red

                if ($this.search_string){
                    if ($subdir.Name.Indexof($this.search_string) -ge 0){
                     $this.search_result +=  $($subdir.Name)
                     $this.search_resultH += @{ $($subdir.Name) = "Directory"   }
 
                    }
                }


            }
        }


        $this.Get_FolderFiles($path, $TabLevel)

        if ($subdirs){
            foreach ($subdir in $subdirs) {
                $subfiles=dir $subdir.fullname | where {$_.GetType() -match "FileInfo"}
                [int]$subcount=$subfiles.count
                Write-Host  "DIRECTORY[$TabLevel]-$($subdir.fullname)" -foregroundcolor Yellow

                if ($subdir.fullname.Indexof($this.search_string) -ge 0){
                    $this.search_result +=  $($path)
                    $this.search_resultH.add( $($path) ,  "DIRECTORY" )
                }
  
                #Recursive Search
               $this.Get_SubFolder($subdir.fullname,$TabLevel)
               
          }
        }
    
     return 1
    }


    [string]Get_FolderFiles ([string]$path,[int]$Level)
    { 
        [int] $count = 0
        [string]$space = "-"*$Level 

        if (-not ((Get-Item $path).exists)) {
            Write-Warning "Failed to find $path"
            return 1
        }

        $data=dir $path
        $files=$data | where {$_.GetType() -match "FileInfo"}
        #enumerate child folders
       
        [System.IO.FileInfo]$f = $null

        foreach ($f in $files) {
            $count+=1
            Write-Host  "$space[$count] Filename: $($f.Name) " -foregroundcolor green  
 
            if ($this.search_string){
                if ($f.Name.Indexof($this.search_string) -ge 0){
                    $this.search_result +=  $($path + "\"+ $f.Name)
                    $this.search_resultH.add( $($path + "\"+ $f.Name) ,  "File" )
                }
            }

       }
        return 1    
     }

}


[string]$path = 'D:\Powershell_Project\TREE_WALK\'

#[string]$path = 'S:\'


[QFile_SYSTEM]$fs = [QFile_SYSTEM]::new()

#$fs.Get_SubFolder($path, 0 )

$fs.Search_file("math.txt", $path)

Write-warning "1 - ******************"
foreach ($element in $fs.search_result) {
    $i++

    "($i) - $element"
}


Write-warning "2 - ******************"

function List_hashtable([HASHTABLE]$HTable){
    Write-Warning "Hashtable:count = $($HTable.count)"

    Foreach($Entry in $HTable.GetEnumerator())
    {
      Write-Output "$($Entry.Key) ------ $($Entry.Value)"
    }

    break

     for ($i=0; $i -le ($fs.search_resultH.count – 1); $i++)  {
        $Key =  $fs.search_resultH.Keys[$i]
        $Value = $fs.search_resultH.Item[$Key]
           "$key - $Value"
    }
}

List_hashtable $fs.search_resultH
