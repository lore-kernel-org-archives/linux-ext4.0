From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] tests: for mktemp the exes must be the final characters of the name
Date: Wed, 4 Jun 2014 16:31:21 -0600
Message-ID: <850D72EC-599B-458C-BBE1-22E6A0F74E92@dilger.ca>
References: <1401884926-31722-1-git-send-email-bensberg@justemail.net>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_6971F38F-3C47-4184-A39A-0BF06CF5B257"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Benno Schulenberg <bensberg@justemail.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58335 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaFDWb1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2014 18:31:27 -0400
Received: by mail-pd0-f177.google.com with SMTP id g10so140903pdj.8
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jun 2014 15:31:26 -0700 (PDT)
In-Reply-To: <1401884926-31722-1-git-send-email-bensberg@justemail.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6971F38F-3C47-4184-A39A-0BF06CF5B257
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jun 4, 2014, at 6:28 AM, Benno Schulenberg <bensberg@justemail.net> wrote:
> Signed-off-by: Benno Schulenberg <bensberg@justemail.net>
> ---
> tests/scripts/resize_test |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
> index c9a7a1c..1e5756c 100755
> --- a/tests/scripts/resize_test
> +++ b/tests/scripts/resize_test
> @@ -21,7 +21,7 @@ if truncate -s $SIZE_2 $TMPFILE 2> /dev/null; then
> 	echo "using $TMPFILE" >> $LOG
> else
> 	rm $TMPFILE
> -	export TMPFILE=$(TMPDIR=. mktemp -t $test_name.XXXXXX.tmp)
> +	export TMPFILE=$(TMPDIR=. mktemp -t $test_name.tmp.XXXXXX)

The goal was that the temporary file ended with ".tmp" so that it would
be removed by "make clean" in case the test fails or is interrupted, so
it would be good to update the "make clean" rules to find these files.

I also notice that there are occasional e2fsprogs-tmp.XXXXXX files left
behind in /tmp after testing, and it would be nice if they contained the
test name so they can be found if there is a problem.

It looks like the same could be done in tests/test_one.in:

TMPFILE=$(mktemp -t e2fsprogs-$test_name.tmp.XXXXXX)


Cheers, Andreas






--Apple-Mail=_6971F38F-3C47-4184-A39A-0BF06CF5B257
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU4+eOXKl2rkXzB/gAQIbEQ//b36V9bekNNsv4gLyk71VQ1lx3GUe7oxZ
Y3k4GQA4b5kNs5cVswZgEQuLF/OR06/nf1qIxf8OSrAUOelEu2RX97vQ8bqd6cX8
4cl4c2fU3EQXMp6ylaKs2QFUrZfq9yIcu6iamP9XZUkBVfEMFmIs273cylXVEk2C
3d59WCuSHw3nz/fZ0f2dIJIW6GZHRLbsKzrpRr35GLswMIZ+lijeOmNRyOT7KgyJ
UwGnzvooG6FW1fAEyGRP+HCAIQNYz23ogUkHDtsSN5Fos/hY5G8oZJhDKhqNo5b9
qF/11qm/uSrBW4hhGoM4pq8rCZYhaL2fLFbvvzvJEIcJ8xk/DsXQehErzQvT7gDl
MRCDmWVP/eOB1YBrgJYzp2EbH8yVTp4M/JFeqTiSeVTBSTgTLKAJqtt15YpcpPT3
Ae05zo0g0C38/6i54EffLN5Ebl19piTbWsLlueoZ9ZAA6yLx6V/vEwf4biWk8dlL
+LLcDuPg48hVpDY4Il36WiDQj3OFV4LSwP827LkWsUqfcmurGWXCat6gJoyGGI3h
3K9ltqXc/n5Uwr6Dys3YKKmmrglMUneuWJglrJPxYHvS88PMwP0MTupi1NLTOckf
Lk1ilnmoxNV+Ea7fz7LWzzVj85OJhH4nxiiSVlp01prrHJRgZ0ey9sycAyNyd+tt
kwsITVN4kUM=
=cF62
-----END PGP SIGNATURE-----

--Apple-Mail=_6971F38F-3C47-4184-A39A-0BF06CF5B257--
