

These are the steps i would take using bash commands to edit the running EC2 web server.

First thing to note is that within the script for the web server, is the path and file name that the web server html code will be housed in on the EC2 instance, i.e. the **'/var/www/html/index.html'**.

![](attachment/b22c3db2b9d80ccdab141c45d907e88d.png)


-----


These are the steps for using a bash command-line shell to edit the running EC2 web server's `index.html` file; with the target file located at `/var/www/html/index.html`.

1.  **Connect to the Instance via SSH** ➡️

      * Connect to the EC2 instance using a service like AWS EC2 Instance Connect or a standard SSH client. Ensure the associated security group has an inbound rule allowing traffic on port 22.

2.  **Navigate to the Web Root Directory** 📂

      * Once connected to the instance, change to the directory containing the `index.html` file.
        ```bash
        cd /var/www/html/
        ```

3.  **Verify Location and File Presence** ✅

      * Confirm you are in the correct directory using the `pwd` (print working directory) command.
      * Confirm the `index.html` file is present using the `ls` (list) command.

4.  **Open the File for Editing** ✍️

      * Run the command `sudo vim index.html` to open the file with the necessary elevated permissions.
          * **`sudo`**: This elevates your permissions to allow editing of a system file owned by the root user.
          * **`vim`**: A powerful, standard command-line text editor.

5.  **Edit the File in Vim**

      * Press the `i` key to enter **INSERT** mode. You will see `-- INSERT --` at the bottom of the screen. You can now type and make your edits.
      * E.g. Here you can make your desired edits, such as adding the text: *"I found my wife on a party yacht in Thailand\! Her name is Yuki (Japanese-Brazilian)"*
      * Or inserting an image.
      * Once you are finished editing, press the `Esc` key to exit INSERT mode and return to command mode.

6.  **Save and Exit Vim**

      * With the cursor at the bottom of the screen, type the following command and press **Enter**:
        ```bash
        :wq
        ```
          * **`:`** enters the command-line mode in Vim.
          * **`w`** stands for **write** (save the file).
          * **`q`** stands for **quit** (exit Vim).

7.  **Verify Your Changes**

      * Refresh the webpage in your browser using the instance's public IP or DNS name. Your changes should now be live.

Below are images show casing the initial webpage, the bash steps to edit the running web server, followed by the results of the changes on the running web server.

- Successfully running web server:
![](attachment/8bb6ec693cdd75aa12c7dc9cd26e0d26.png)

- Accessing AWS Instance Connect to connect to the instance via SSH:
![](attachment/31b99aeb9f73fd503b5b406e907c5055.png)

- Successful connection to the running instance
![](attachment/b0e1a9dac8c38e9abcbffd3a7127d6f4.png)

- Navigating to the necessary file location (directory):
![](attachment/e3d8d96b28c516c851497e6219549d96.png)

- Using VIM to access and edit the file with root permissions:
![](attachment/6d38c4522ec865ae75682e7ea424b372.png)

- Editing the .html file on the running instance:
![](attachment/e6c977179776fa67fbba9447bf169249.png)

- Saving and exiting the .html file
![](attachment/615bf6e0931a0c3e625ba8748f9d3739.png)

- Successfully edited, running, web server instance
![](attachment/58dcd182448b27b16d14ebeaa4a4346e.png)