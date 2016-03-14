From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Buffer Head Leak In mmp
Date: Mon, 14 Mar 2016 02:41:34 -0600
Message-ID: <BFF88A70-A864-4957-A807-30C6191C4D45@dilger.ca>
References: <CAJ-febOhan58G=Aw+-CD6OD2iKuFY3dxkzBfVMCwBd6vXs1rFg@mail.gmail.com> <B747AA6A-644E-475E-BE24-07C400041058@dilger.ca> <20160313215730.GI29218@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: multipart/signed; boundary="Apple-Mail=_AB23E310-3823-468E-91A0-C41ED3186D36"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: "vikram.jadhav07" <vikramjadhavpucsd2007@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34654 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbcCNIlk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2016 04:41:40 -0400
Received: by mail-ig0-f169.google.com with SMTP id av4so56649264igc.1
        for <linux-ext4@vger.kernel.org>; Mon, 14 Mar 2016 01:41:39 -0700 (PDT)
In-Reply-To: <20160313215730.GI29218@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_AB23E310-3823-468E-91A0-C41ED3186D36
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 13, 2016, at 3:57 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> I've made the changes Andreas suggested, and ended up with this.  =
Andreas, PTAL?

Sorry, not sure what "PTAL" means... :-)

In any case, the patch looks good to me.

Reviewed-by: Andreas Dilger <adilger@dilger.ca.

> commit 0304688676bdfc8159e165313d71da19c118ba27
> Author: vikram.jadhav07 <vikramjadhavpucsd2007@gmail.com>
> Date:   Sun Mar 13 17:56:52 2016 -0400
>=20
>    ext4: clean up error handling in the MMP support
>=20
>    There is memory leak as both caller function kmmpd() and callee
>    read_mmp_block() not releasing bh_check  (i.e buffer_head).
>    Given patch fixes this problem.
>=20
>    [ Additional changes suggested by Andreas Dilger -- TYT ]
>=20
>    Signed-off-by: Jadhav Vikram <vikramjadhavpucsd2007@gmail.com>
>    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>=20
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 0a512aa..2444527 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -91,21 +91,22 @@ static int read_mmp_block(struct super_block *sb, =
struct buffer_head **bh,
> 	submit_bh(READ_SYNC | REQ_META | REQ_PRIO, *bh);
> 	wait_on_buffer(*bh);
> 	if (!buffer_uptodate(*bh)) {
> -		brelse(*bh);
> -		*bh =3D NULL;
> 		ret =3D -EIO;
> 		goto warn_exit;
> 	}
> -
> 	mmp =3D (struct mmp_struct *)((*bh)->b_data);
> -	if (le32_to_cpu(mmp->mmp_magic) !=3D EXT4_MMP_MAGIC)
> +	if (le32_to_cpu(mmp->mmp_magic) !=3D EXT4_MMP_MAGIC) {
> 		ret =3D -EFSCORRUPTED;
> -	else if (!ext4_mmp_csum_verify(sb, mmp))
> +		goto warn_exit;
> +	}
> +	if (!ext4_mmp_csum_verify(sb, mmp)) {
> 		ret =3D -EFSBADCRC;
> -	else
> -		return 0;
> -
> +		goto warn_exit;
> +	}
> +	return 0;
> warn_exit:
> +	brelse(*bh);
> +	*bh =3D NULL;
> 	ext4_warning(sb, "Error %d while reading MMP block %llu",
> 		     ret, mmp_block);
> 	return ret;
> @@ -181,15 +182,13 @@ static int kmmpd(void *data)
> 		    EXT4_FEATURE_INCOMPAT_MMP)) {
> 			ext4_warning(sb, "kmmpd being stopped since MMP =
feature"
> 				     " has been disabled.");
> -			EXT4_SB(sb)->s_mmp_tsk =3D NULL;
> -			goto failed;
> +			goto exit_thread;
> 		}
>=20
> 		if (sb->s_flags & MS_RDONLY) {
> 			ext4_warning(sb, "kmmpd being stopped since =
filesystem "
> 				     "has been remounted as readonly.");
> -			EXT4_SB(sb)->s_mmp_tsk =3D NULL;
> -			goto failed;
> +			goto exit_thread;
> 		}
>=20
> 		diff =3D jiffies - last_update_time;
> @@ -211,9 +210,7 @@ static int kmmpd(void *data)
> 			if (retval) {
> 				ext4_error(sb, "error reading MMP data: =
%d",
> 					   retval);
> -
> -				EXT4_SB(sb)->s_mmp_tsk =3D NULL;
> -				goto failed;
> +				goto exit_thread;
> 			}
>=20
> 			mmp_check =3D (struct mmp_struct =
*)(bh_check->b_data);
> @@ -225,7 +222,9 @@ static int kmmpd(void *data)
> 					     "The filesystem seems to =
have been"
> 					     " multiply mounted.");
> 				ext4_error(sb, "abort");
> -				goto failed;
> +				put_bh(bh_check);
> +				retval =3D -EBUSY;
> +				goto exit_thread;
> 			}
> 			put_bh(bh_check);
> 		}
> @@ -248,7 +247,8 @@ static int kmmpd(void *data)
>=20
> 	retval =3D write_mmp_block(sb, bh);
>=20
> -failed:
> +exit_thread:
> +	EXT4_SB(sb)->s_mmp_tsk =3D NULL;
> 	kfree(data);
> 	brelse(bh);
> 	return retval;


Cheers, Andreas






--Apple-Mail=_AB23E310-3823-468E-91A0-C41ED3186D36
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVuZ5PnKl2rkXzB/gAQgkoQ//XFl/P+kLvFh6cn2bY7TLxcn3p1mmrPCU
sE9675eH2tm7HLrKK5U5adVOdoJLt1eAInLsSe4JZTvu43z3tftHTLnLBr9qXP2S
p+1dKpD/OFJEV/akfnsyXFUXTFUK6W+MWoFyqaEpcv195t8GTE21yZf3iXck7v3v
n3LGxP6+sLNXlatSuTeZLE33l3h2bHe5DI23aOCYi2QsaCSvkD3bpBBs0ukSGcr3
04UO/18DSIVkp7cAiAOt/J6aH05hGg59pqxmcboKBsQmOTPmo4NSjo0uuV8eIhVt
AuMxUQNO9Q1IPgJXnx00XD2QJ/Kpo65HIcUWAXOfNHLmDtb7loUlo2oHz6jVXyeL
QNAyyOX9ofNIsQ4TBb5BfWmsFMbrD2mZPRVkf5keZjvh9WdB6tX91jTlLwTkG8t0
SK5I6hgub5esWhDbNoo6WpItv6wAzA4wbM4Mht7p71y67GwSOFlFGpZ8aTStSWfe
qSwg6jpMz3vD4Ys9WCZrUZ9PGAA4if6yHS+2/zcIZCc4TKtL7Ic4q+V3JNxmwICa
x8ds/ZgnTCZ7fG1dQjLYFwsOZFVev6UjrcUoNuHl+lKD5TjqtYOmDm5xV7UZaUOT
JydiF6MJeGtEGMxP/EQpeBXcuwIPypouUaJvWNSIszY0w/6YHOfoWHOxcwCsLg/v
0dvgI0xfVzU=
=XdPU
-----END PGP SIGNATURE-----

--Apple-Mail=_AB23E310-3823-468E-91A0-C41ED3186D36--
