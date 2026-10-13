# Rosalind

Splits selected HaGeZi DNS blocklists into chunks under UniFi's 100,000-entry
limit for dynamic network lists. A scheduled GitHub Action rebuilds them and
force-pushes a single commit to the `publish` branch, so history does not grow.

Source lists and licence: https://github.com/hagezi/dns-blocklists (GPL-3.0).
The NRD list originates from Stamus Labs data via https://github.com/hagezi/nrd.

Chunk URLs:

    https://raw.githubusercontent.com/Summerlytz/Rosalind/publish/hgz-pro-1.txt
    https://raw.githubusercontent.com/Summerlytz/Rosalind/publish/hgz-pro-2.txt
    https://raw.githubusercontent.com/Summerlytz/Rosalind/publish/hgz-pro-3.txt
    https://raw.githubusercontent.com/Summerlytz/Rosalind/publish/hgz-tif-mini-1.txt
    https://raw.githubusercontent.com/Summerlytz/Rosalind/publish/hgz-tif-mini-2.txt
    https://raw.githubusercontent.com/Summerlytz/Rosalind/publish/hgz-tif-mini-3.txt
    https://raw.githubusercontent.com/Summerlytz/Rosalind/publish/hgz-entropy-nrd-7d-1.txt
    ... through hgz-entropy-nrd-7d-7.txt

`status.txt` on the `publish` branch shows the build time and line counts.
Edit the `LISTS` array in `split.sh` to add lists or change chunk counts.
