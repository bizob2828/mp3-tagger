#Converts flac to mp3
#Assume you are in folder that flac exist
#Need anvconv libmp3lame
for FILE in *.flac;
do
    avconv -i "$FILE" -ab 320k -c:a libmp3lame -q:a 4 "${FILE%.*}.mp3";
    #echo ${FILE%.*}.mp3;
done
