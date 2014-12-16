rm -rf resigned
mkdir resigned

WORKSPACE=${PWD}

for filename in *.ipa; do
    echo $filename
    
    unzip $filename

    cd payload
    AppName="$(ls -1)"
    cd ..

    rm -r "Payload/$AppName/_CodeSignature" "Payload/$AppName/CodeResources" 2> /dev/null | true
    cp "dist.mobileprovision" "Payload/$AppName/embedded.mobileprovision"
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $WORKSPACE/entitlements
    /usr/bin/codesign -d --entitlements - Payload/$AppName | sed -E -e '1d' >> $WORKSPACE/entitlements
    /usr/bin/codesign -f -s "iPhone Distribution: Red Ant Mobile Ltd." "Payload/$AppName" --entitlements $WORKSPACE/entitlements
    zip -qr "resigned/$filename" Payload
    rm -rf Payload
    rm -r $WORKSPACE/entitlements
    
done