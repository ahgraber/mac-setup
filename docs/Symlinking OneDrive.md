# Linking Documents to OneDrive

1. Rename Documents folder: `sudo mv Documents Documents.old`
2. Set up symbolic link:
   - `sudo ln -Ffs /Users/<USERNAME>/OneDrive/Documents`
   - `sudo ln -Ffs /Users/<USERNAME>/OneDrive\ -\ <COMPANYNAME>/Documents`
3. Check your work: `ls -al` - you should see `Documents -> /Users/<USERNAME>/OneDrive/Documents` listed
