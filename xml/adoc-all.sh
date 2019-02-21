for i in *.xml; do
  echo $i
  docbookrx --strict $i
done
