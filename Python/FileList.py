# Write a custom function file_list(directory_path), which returns a list of names of text files


from typing import List
import os


def file_list(directory_path: str) -> List[str]:
    """
   This function should take in directory_path and go recursively through the directory_path
   and return a list of all text files (extension .txt).

   If txt files is not present in directory, it should return empty list ([]).

   Parameters
   ----------
   directory_path : str
       Directory path to search for text files in.
   Returns
   -------
   file_names : List[str]
       List of all text files in the directory.
   """
    file_names = []
    for file in os.listdir(directory_path):
        # print("{:20}{}".format(file, "Directory" if os.path.isdir(os.path.join(directory_path, file)) else "File"))
        if os.path.isdir(os.path.join(directory_path, file)):
            file_names += file_list(os.path.join(directory_path, file))
        elif file.endswith(".txt"):
            file_names.append(file)
    return file_names
