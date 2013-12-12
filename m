From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 03/74] mke2fs: load configfile blocksize setting before 64bit checks
Date: Thu, 12 Dec 2013 15:28:14 -0700
Message-ID: <2EB0A146-8AAA-4F4A-9B11-29ED1D2B42F2@dilger.ca>
References: <20131211011813.30655.39624.stgit@birch.djwong.org> <20131211011837.30655.67812.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E6D3804D-E844-4DFA-B59A-6AE03D78AD39"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53381 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3LLW2U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Dec 2013 17:28:20 -0500
Received: by mail-pd0-f177.google.com with SMTP id q10so1274837pdj.22
        for <linux-ext4@vger.kernel.org>; Thu, 12 Dec 2013 14:28:20 -0800 (PST)
In-Reply-To: <20131211011837.30655.67812.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E6D3804D-E844-4DFA-B59A-6AE03D78AD39
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Dec 10, 2013, at 6:18 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:

> mke2fs has a series of checks to ensure that we don't create a
> filesystem too big for its blocksize -- if auto-64bit is on, then it
> turns on 64bit; otherwise it complains.  Unfortunately, it performs
> these checks before looking in mke2fs.conf for a blocksize, which
> means that the checks are incorrect if the user specifies a non-4096
> blocksize in the config file and says nothing on the command line.
> The bug also has the effect of mandating a 4k block size on any block
> device larger than 4T in that situation.  Therefore, read the block
> size from the config file before performing the 64bit checks.
>=20
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> misc/mke2fs.c |  134 =
+++++++++++++++++++++++++++++++--------------------------
> 1 file changed, 72 insertions(+), 62 deletions(-)
>=20
>=20
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 67c9225..19b6e85 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1780,15 +1795,67 @@ profile_error:
> 		}
> 	}
>=20
> +	/* Get the hardware sector sizes, if available */
> +	retval =3D ext2fs_get_device_sectsize(device_name, =
&lsector_size);
> +	if (retval) {
> +		com_err(program_name, retval,
> +			_("while trying to determine hardware sector =
size"));
> +		exit(1);
> +	}
> +	retval =3D ext2fs_get_device_phys_sectsize(device_name, =
&psector_size);
> +	if (retval) {
> +		com_err(program_name, retval,
> +			_("while trying to determine physical sector =
size"));
> +		exit(1);
> +	}
> +
> +	tmp =3D getenv("MKE2FS_DEVICE_SECTSIZE");
> +	if (tmp !=3D NULL)
> +		lsector_size =3D atoi(tmp);
> +	tmp =3D getenv("MKE2FS_DEVICE_PHYS_SECTSIZE");
> +	if (tmp !=3D NULL)
> +		psector_size =3D atoi(tmp);
> +
> +	/* Older kernels may not have physical/logical distinction */
> +	if (!psector_size)
> +		psector_size =3D lsector_size;
> +
> +	if (blocksize <=3D 0) {
> +		use_bsize =3D get_int_from_profile(fs_types, =
"blocksize", 4096);
> +
> +		if (use_bsize =3D=3D -1) {
> +			use_bsize =3D sys_page_size;
> +			if ((linux_version_code < (2*65536 + 6*256)) &&

Would be nice to have a helper to compute the linux_version_code =
comparison,
the above is a bit too much detail for this code.

> +			    (use_bsize > 4096))
> +				use_bsize =3D 4096;
> +		}
> +		if (lsector_size && use_bsize < lsector_size)
> +			use_bsize =3D lsector_size;
> +		if ((blocksize < 0) && (use_bsize < (-blocksize)))
> +			use_bsize =3D -blocksize;
> +		blocksize =3D use_bsize;
> +		fs_blocks_count /=3D (blocksize / 1024);
> +	} else {
> +		if (blocksize < lsector_size) {			/* =
Impossible */
> +			com_err(program_name, EINVAL,
> +				_("while setting blocksize; too small "
> +				  "for device\n"));
> +			exit(1);
> +		} else if ((blocksize < psector_size) &&
> +			   (psector_size <=3D sys_page_size)) {	/* =
Suboptimal */
> +			fprintf(stderr, _("Warning: specified blocksize =
%d is "
> +				"less than device physical sectorsize =
%d\n"),
> +				blocksize, psector_size);
> +		}
> +	}
> +
> +	fs_param.s_log_block_size =3D
> +		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);

Does it make sense to wrap this whole block size guessing dance into a =
small
helper routine, like "figure_fs_blocksize()" or similar?


Cheers, Andreas






--Apple-Mail=_E6D3804D-E844-4DFA-B59A-6AE03D78AD39
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUqo4f3Kl2rkXzB/gAQL0sw/5AYJTplYW0M1dAtaQwVIpgONzT3oAMwLY
aTJKs9Yk67Kod7UfBHKYF4Hmi+pucxNx9yxbLKKtvN9Bw3hod8SYSK5yERNlJJeC
uXcdv5Su1yzd/EWeQ86lKB7EzdXQquM/xIqr4Sc0uAIHLJU5Mni1NfkqYjzWDzfK
ugi+qyucSAO2PRRCLH83c+PWzFCS0oxpzG07v+1eV5LedqtidP952ZwEjlp9Qlrd
lDS0pGmgRgiGlieLlD0hlVCNjFHQkxnprHLfJ4D0kPhDL0jjQDOL/0AvZ4u+c2fx
oI1556r1HOzlcgy0nTgrBl9UbwMOu3YHmr5ao42StHDGGzdf+r3F25tMUgI7tIla
zr8VapG9m+oRNsQgewSM7ju+E5uYp1MYey2wpqTZpLkY0PClLNbg9Adx3wDvEjx0
5TMFZHakBSu6Ci8bP6hS0MS/ii5qvu/qyABlzRrQQ3BsYU1x99FbAXRAs2olR4Jf
ylpY6gU6D2rE8yQAA3qddBtCjUu6+pSo1btAvrfpU7RbsfgLyvjisbkp4QUihhYI
oDzbrMZrJPESCq0M6KVbAmnJwKGYGo1fgbUB8FkojdKDjww+fN/g+yiooxDFOEEf
C2bGDHEsgFOUYYTYK106RiqctCCggJ1/dL3AeW+116HU4CyZRkCOqZRIHmnOfKvS
VBf7qmQUW4Y=
=H+aA
-----END PGP SIGNATURE-----

--Apple-Mail=_E6D3804D-E844-4DFA-B59A-6AE03D78AD39--
