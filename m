Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44652 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbfABS0U (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2019 13:26:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id t13so14893465pgr.11
        for <linux-ext4@vger.kernel.org>; Wed, 02 Jan 2019 10:26:19 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <B4DC657E-8B7E-4F4E-8E1C-98BCABA9BC0C@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DFB5C416-7C0B-4412-A893-B92357689543";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v6 3/4] tests: add test for e2image -b option
Date: Wed, 2 Jan 2019 11:26:17 -0700
In-Reply-To: <20190101210737.87248-4-c17828@cray.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
References: <20190101210737.87248-1-c17828@cray.com>
 <20190101210737.87248-4-c17828@cray.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DFB5C416-7C0B-4412-A893-B92357689543
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 1, 2019, at 2:07 PM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> The test makes raw image from partition with broken super block
> and executes e2fsck.

It isn't really needed to store an image file for this test.  It would =
be
trivial to format a test filesystem in the test script and clobber the
superblock with "dd if=3D/dev/urandom of=3D$TMPFILE bs=3D1024 count=3D1 =
seek=3D1".

Not sure what Ted thinks about this.

Cheers, Andreas

> Signed-off-by: Artem Blagodarenko <c17828@cray.com>
> ---
> tests/i_zero_super/expect.1 |  22 ++++++++++++++++++++++
> tests/i_zero_super/image.gz | Bin 0 -> 13262 bytes
> tests/i_zero_super/script   |  11 +++++++++++
> 3 files changed, 33 insertions(+)
>=20
> diff --git a/tests/i_zero_super/expect.1 b/tests/i_zero_super/expect.1
> new file mode 100644
> index 00000000..fda32b96
> --- /dev/null
> +++ b/tests/i_zero_super/expect.1
> @@ -0,0 +1,22 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +Free blocks count wrong for group #0 (7987, counted=3D7982).
> +Fix? no
> +
> +Free blocks count wrong (11602, counted=3D11597).
> +Fix? no
> +
> +Free inodes count wrong for group #0 (1493, counted=3D1488).
> +Fix? no
> +
> +Free inodes count wrong (2997, counted=3D2992).
> +Fix? no
> +
> +
> +test_filesys: ********** WARNING: Filesystem still has errors =
**********
> +
> +test_filesys: 11/3008 files (0.0% non-contiguous), 398/12000 blocks
> +Exit status is 4
> diff --git a/tests/i_zero_super/image.gz b/tests/i_zero_super/image.gz
> new file mode 100644
> index =
0000000000000000000000000000000000000000..eea9140194f4dd9ec9dc8bb7b9e2215b=
950587d2
> GIT binary patch
> literal 13262
> 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
>=20
> literal 0
> HcmV?d00001
>=20
> diff --git a/tests/i_zero_super/script b/tests/i_zero_super/script
> new file mode 100644
> index 00000000..6b02d86d
> --- /dev/null
> +++ b/tests/i_zero_super/script
> @@ -0,0 +1,11 @@
> +if test -x $E2IMAGE_EXE; then
> +
> +ONE_PASS_ONLY=3Dtrue
> +FSCK_OPT=3D"-n -b 8193 -f"
> +PREP_CMD=3D"$E2IMAGE_EXE -r -b 8193 -B 1024 $TMPFILE $TMPFILE.raw; \
> +	  mv $TMPFILE.raw $TMPFILE"
> +. $cmd_dir/run_e2fsck
> +
> +else
> +	echo "$test_name: $test_description: skipped"
> +fi
> --
> 2.14.3
>=20


Cheers, Andreas






--Apple-Mail=_DFB5C416-7C0B-4412-A893-B92357689543
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwtAkkACgkQcqXauRfM
H+DekBAAtc/j15foBdD5M8dcyfI7Mwp3CZ0s5F6k0iDB8WA3fRgWp5XGV0ozaqRC
tIZCcyjF+9mlJ7dQs8H6FvnnaY4OeLdwFHj0Eo+BHaqxbpgcMtAX7plxU8gheAw6
BT5tbZ0kkhAm3GIvMXJp87++pdfrJMrvuRfZZ9u7NkXaJybkGUFYX1KbzbHsN+4v
x1v+tHf7Ren1pR2/4JUqNzlOxfzHFUKvv79WzuwpA/PSUyueXrWz2QadjruUQzlY
T+q0FT7IPL+N04O8pjDKxojzEfv1UhF3cWrw7vPRKkPS33DXCDJUz5ZRiVM2fS06
R0AA5tGKF/JZCzzR+bDgpNbzVFkjDDL6gVNrf4pLoj2Iavh82W8wLKew7XkbQGup
DWz8xin+CDL3xdpZZtTIJVUkiNmCkSC0Sc8frmmJ2fE7XqJvSsPi6f+nqRF9xcAT
3943Yn8fXI9hXCYYDMsqjQSCE4uZSioAPDc4T66Tr+8RQvMr0ZpWNDDyjbpIIGV5
G5o74asuilr/42wbrBgeOJAINFn8i0TjLAOqUKGW5GHz9Bj/mEASPGGlGlYp2KUx
WaxckBSg7fGXZEaMmG3NRCbfBlJ8vgP4SYLSVqBQXjHec7kK2XAjzplEGGzjZ23Y
gGFOMyN4d5Zp69AiwTY8AgfsYnyK8u9dvijKImvCjX94V8ArTkE=
=G3gP
-----END PGP SIGNATURE-----

--Apple-Mail=_DFB5C416-7C0B-4412-A893-B92357689543--
