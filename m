From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 01/49] create_inode: clean up return mess in do_write_internal
Date: Tue, 11 Mar 2014 14:30:02 -0600
Message-ID: <9EBDB4AF-4901-4416-ACC4-6F25233316BD@dilger.ca>
References: <20140311065356.30585.47192.stgit@birch.djwong.org> <20140311065404.30585.9687.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E182FBA7-635D-4D54-9EAA-B48C15F635FE"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52805 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbaCKUaa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 16:30:30 -0400
Received: by mail-pa0-f53.google.com with SMTP id ld10so60660pab.12
        for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 13:30:30 -0700 (PDT)
In-Reply-To: <20140311065404.30585.9687.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E182FBA7-635D-4D54-9EAA-B48C15F635FE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 11, 2014, at 12:54 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
> do_write_internal returns errno when ext2 library calls fail; since
> errno only reflects the outcome of the last C library call, this will
> result in confused callers.  Eliminate the naked return since
> this results in an undefined return value.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> misc/create_inode.c |   17 ++++++++++-------
> 1 file changed, 10 insertions(+), 7 deletions(-)
>=20
>=20
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index cf4a58f..647480c 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -353,14 +353,14 @@ errcode_t do_write_internal(ext2_ino_t cwd, =
const char *src, const char *dest)
> 	if (retval =3D=3D 0) {
> 		com_err(__func__, 0, "The file '%s' already exists\n", =
dest);
> 		close(fd);
> -		return errno;
> +		return retval;
> 	}

This seems a bit strange.  It looks like an error return, but it will
actually return "0" since this branch is only entered if retval =3D=3D =
0.
Should this return an explicit error value here?

Cheers, Andreas

> 	retval =3D ext2fs_new_inode(current_fs, cwd, 010755, 0, =
&newfile);
> 	if (retval) {
> 		com_err(__func__, retval, 0);
> 		close(fd);
> -		return errno;
> +		return retval;
> 	}
> #ifdef DEBUGFS
> 	printf("Allocated inode: %u\n", newfile);
> @@ -372,7 +372,7 @@ errcode_t do_write_internal(ext2_ino_t cwd, const =
char *src, const char *dest)
> 		if (retval) {
> 			com_err(__func__, retval, "while expanding =
directory");
> 			close(fd);
> -			return errno;
> +			return retval;
> 		}
> 		retval =3D ext2fs_link(current_fs, cwd, dest, newfile,
> 					EXT2_FT_REG_FILE);
> @@ -412,12 +412,15 @@ errcode_t do_write_internal(ext2_ino_t cwd, =
const char *src, const char *dest)
> 	if ((retval =3D ext2fs_write_new_inode(current_fs, newfile, =
&inode))) {
> 		com_err(__func__, retval, "while creating inode %u", =
newfile);
> 		close(fd);
> -		return errno;
> +		return retval;
> 	}
> 	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
> 		retval =3D ext2fs_inline_data_init(current_fs, newfile);
> -		if (retval)
> -			return;
> +		if (retval) {
> +			com_err("copy_file", retval, 0);
> +			close(fd);
> +			return retval;
> +		}
> 	}
> 	if (LINUX_S_ISREG(inode.i_mode)) {
> 		if (statbuf.st_blocks < statbuf.st_size / S_BLKSIZE) {
> @@ -434,7 +437,7 @@ errcode_t do_write_internal(ext2_ino_t cwd, const =
char *src, const char *dest)
> 	}
> 	close(fd);
>=20
> -	return 0;
> +	return retval;
> }
>=20
> /* Copy files from source_dir to fs */
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_E182FBA7-635D-4D54-9EAA-B48C15F635FE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUx9ySnKl2rkXzB/gAQLe9hAAti/CIF9tiXLemzWjqvi96W8cQNf+11Kt
YsKa+voe++q85pjcyIbJbCDB+J7Fq91b1cANNifzBJB8cKgn3SC1u2QNiFb4jjFt
S9+U/yBNC937+w+xAmEs/23BQFaMW/zbwRKIG7toQ/Xrs35/bcOAqJeCE9BsETGv
FPq1axcGaLUiBU1m7xx1d1z/9DQp8Id/7rHGroQ9MBndQYR3+AiwGWeRnZQruaTU
DS28k+tse/E76IV4AbrUJrVcHmCuanuXAp4mvZfMHZhD+BBiZGC6TZQ5vMI6/qlH
tNQumZ+WuBUixTzR+oueZNrD967J+ew8RVVPn16MbIEWpVM9PfK/ANrjJMhyvUHX
8jHUXHa4AxtJadNKBcHDEhPrmQbNexH5lwqGsAis4yO+RvzavAwCTmSOvR4OZULL
oHm/fBxsX0XSzBJr3lPBhXT2s5KTpxy18yLIGs1iro0vqDl/iqee4/T7/BuTvlPp
v8SBn/1eZcESW6iBa9/G7o/6CAvxus7GC8JIUd8uflvcfv7xhrts3eZbpDB1b7Y5
qeF9YDEZxbsjPrt7hY7J+EbbOkuyzFplALG1+vYBfqUY2qR8pbsFlsNHw91kJLpZ
lVJKgcr+8+RmVt1FxM6KKVG9hTY4swFPui/STFQ2d4lp1aN7kaiX9pr19E/Um7uk
0uCEpqaYQz4=
=ae+j
-----END PGP SIGNATURE-----

--Apple-Mail=_E182FBA7-635D-4D54-9EAA-B48C15F635FE--
