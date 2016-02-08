From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Buffer Head Leak In mmp
Date: Mon, 8 Feb 2016 14:40:21 -0700
Message-ID: <B747AA6A-644E-475E-BE24-07C400041058@dilger.ca>
References: <CAJ-febOhan58G=Aw+-CD6OD2iKuFY3dxkzBfVMCwBd6vXs1rFg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_D3B353CE-F286-4A44-AFB2-96DE542F3B0D"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "vikram.jadhav07" <vikramjadhavpucsd2007@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35987 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbcBHVk0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2016 16:40:26 -0500
Received: by mail-pf0-f171.google.com with SMTP id e127so20416327pfe.3
        for <linux-ext4@vger.kernel.org>; Mon, 08 Feb 2016 13:40:26 -0800 (PST)
In-Reply-To: <CAJ-febOhan58G=Aw+-CD6OD2iKuFY3dxkzBfVMCwBd6vXs1rFg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D3B353CE-F286-4A44-AFB2-96DE542F3B0D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 20, 2016, at 8:48 AM, vikram.jadhav07 =
<vikramjadhavpucsd2007@gmail.com> wrote:
>=20
> Description:  ext4: Buffer Head Leak In mmp
>=20
> There is memory leak as both caller function kmmpd() and callee
> read_mmp_block() not releasing bh_check  (i.e buffer_head).
> Given patch fixes this problem.

I was going to give this a Signed-off-by, since it matches patches that =
we
have included into the Lustre ext4 patch series, but it seems the code =
is
different in newer kernels because of the metadata checksum feature and
could be improved a bit further.

> Signed-off-by: Jadhav Vikram <vikramjadhavpucsd2007@gmail.com>
>=20
> Patch:
> =3D=3D=3D=3D=3D
> --- /root/linux.orig/fs/ext4/mmp.c      2016-01-18 07:23:06.227519005 =
+0530
> +++ /root/linux/fs/ext4/mmp.c   2016-01-18 07:31:18.545518552 +0530
> @@ -98,12 +98,17 @@
>         }
>=20
>         mmp =3D (struct mmp_struct *)((*bh)->b_data);
> +       if (le32_to_cpu(mmp->mmp_magic) !=3D EXT4_MMP_MAGIC) {
>                ret =3D -EFSCORRUPTED;
> +               brelse(*bh);
> +               *bh =3D NULL;
> +       } else if (!ext4_mmp_csum_verify(sb, mmp)) {
>                ret =3D -EFSBADCRC;
> +               brelse(*bh);
> +               *bh =3D NULL;
> +       } else {
>                return 0;
> +       }

Having the normal return be at the end of the error handling is =
non-standard
and would be better structured to have "goto out_bh;" in each of the
error cases, and then the "naked" return at the end.  That avoids =
duplicating
the error handling, and will avoid bugs/leaks in the future if this code =
is
changed to add more failure conditions or returns.


	mmp =3D (struct mmp_struct *)((*bh)->b_data);
	if (le32_to_cpu(mmp->mmp_magic) !=3D EXT4_MMP_MAGIC) {
		ret =3D -EFSCORRUPTED;
		goto out_bh;
	}
	if (!ext4_mmp_csum_verify(sb, mmp)) {
		ret =3D -EFSBADCRC;
		goto out_bh;
	}

	return 0;

out_bh:
	brelse(*bh);
	*bh =3D NULL;
warn_exit:
	ext4_warning(sb, "Error %d while reading MMP block %llu",
		     ret, mmp_block);
	return ret;

> @@ -225,6 +230,7 @@
>                                             "The filesystem seems to =
have been"
>                                             " multiply mounted.");
>                                ext4_error(sb, "abort");
> +                               put_bh(bh_check);
>                                goto failed;
>                        }
>                        put_bh(bh_check);

I was going to suggest something similar here to consolidate the =
"put_bh()"
calls, but it doesn't look like that can be done easily.

Instead I found a bug because this isn't setting s_mmp_tsk =3D NULL as =
the
other error branches are doing, which will lead to the filesystem =
cleanup
code trying to stop this thread again.  Could you please remove the =
duplicate
"s_mmp_tsk =3D NULL" assignments.  I also see that the error handling is =
still
not quite correct because "retval" is not set in this branch, which =
further
emphasizes the benefits of using the "goto NNN" style of error handling.
It should be something like:

			if (retval) {
				ext4_error(sb, "error reading MMP data: =
%d",
					   retval);
				goto out_tsk;
			}
			if (mmp->mmp_seq !=3D ...) {
				dump_mmp_msg(sb, mmp_check, ...);
				ext4_error(sb, "abort due to multiple =
mount");
				put_bh(bh_check);
				retval =3D -EBUSY;
				goto out_tsk;
			}
			put_bh(bh_check);
		}

		:
		:
	}

	:
	:

out_tsk:
	EXT4_SB(sb)->s_mmp_tsk =3D NULL;
out_free:
	kfree(data);
	brelse(bh);
	return retval;
}

Note "failed:" is renamed to "out_free:" since that code path is also =
used
in non-failure cases, for normal thread exit, and also to ensure that =
the
other two cases that explicitly set s_mmp_tsk =3D NULL and jumped to =
"failed:"
will also be cleaned up.

Cheers, Andreas






--Apple-Mail=_D3B353CE-F286-4A44-AFB2-96DE542F3B0D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVrkLRXKl2rkXzB/gAQg0YRAAoDPWCHmXT9dyVYwXpw0UqovbsFb0jt7M
uI+4GKD1y0KQxvJtlJU4TXtiNxvW7zgXcofNcb/+kn1xNrcEyPKNTH5Y52q83nF6
oGsiIYPXgJnHj4oimgYcT416xCfVdpy2/fVX37IyLAPKExulHDBVSUvDClptjozA
tFvJN/3A7hYp3w3UACyorM6yei/fJEpu4f9elbGVAEd++/btbU7TfPQhiLvCI+7l
imFNAI9X5HJMioHHALeQYGjsLJyDZ0d1Euj2Trns7Ad4LrZiHMvG6zxheIplsdIH
t4Vi7aYuv8q2TpD8ksv9EsaDQg6GJ65XKM4LYGHKDaLWEiv7D3uM5pQK0Tkr2j3z
2bqvkxmoimHZB0heB9AH1fXcCbaHLia9r3H0/2g9krPIjS3nYM5ucYEJ8ryppkQv
AkWu//vmTeuBDwaVJMVzVCxUtSe3Qx03U6V3chNGUDQVCkspcGG4ol6FSOhMnvLf
FQi1tvYnCcuD63A97GWJp6349mzn80FBT5s0kRR/JSqQUwQoJfsrrnlcWj6GDKT+
bfpwSshsRl96oddNqIUf/2YV/QNDbftYF3p2Yu/eQO6rjE0qXWXKHRtS2BSEpMCq
Zeki4a+mTgoywsnr47JG6hIeMkohFqfnAy2TKVSPuQOTM5TktrkcGM7t8+3WDUIu
ne4x7MuiUGg=
=RNCv
-----END PGP SIGNATURE-----

--Apple-Mail=_D3B353CE-F286-4A44-AFB2-96DE542F3B0D--
