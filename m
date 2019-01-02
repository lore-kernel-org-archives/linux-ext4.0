Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38229 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfABSR6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2019 13:17:58 -0500
Received: by mail-pf1-f193.google.com with SMTP id q1so15506059pfi.5
        for <linux-ext4@vger.kernel.org>; Wed, 02 Jan 2019 10:17:57 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <921FAE3E-D135-4705-82B4-8B353FED5021@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_EF044333-3AD8-450B-BB56-B8EBFCA786F4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v6 1/4] ext2fs: opening filesystem code refactoring
Date: Wed, 2 Jan 2019 11:17:54 -0700
In-Reply-To: <20190101210737.87248-2-c17828@cray.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
References: <20190101210737.87248-1-c17828@cray.com>
 <20190101210737.87248-2-c17828@cray.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_EF044333-3AD8-450B-BB56-B8EBFCA786F4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 1, 2019, at 2:07 PM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> There are similar opening filesystem code in different utilities.
>=20
> The patch moves improved handling from try_open_fs()
> into ext2fs_open(). This function make one of the action
> based on parameters:
> 1) open filesystem with given superblock, superblock size
> 2) open filesystem with given superblock, but try to
> find right block size
> 3) open filesystem with default superblock and block size
>=20
> Signed-off-by: Artem Blagodarenko <c17828@cray.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> e2fsck/unix.c       | 28 +++-------------------------
> lib/ext2fs/openfs.c | 41 +++++++++++++++++++++++++++++++++++++----
> misc/dumpe2fs.c     | 17 ++---------------
> 3 files changed, 42 insertions(+), 44 deletions(-)
>=20
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 5b3552ec..ddcf52a4 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1151,31 +1151,9 @@ static errcode_t try_open_fs(e2fsck_t ctx, int =
flags, io_manager io_ptr,
> 			     ext2_filsys *ret_fs)
> {
> 	errcode_t retval;
> -
> -	*ret_fs =3D NULL;
> -	if (ctx->superblock && ctx->blocksize) {
> -		retval =3D ext2fs_open2(ctx->filesystem_name, =
ctx->io_options,
> -				      flags, ctx->superblock, =
ctx->blocksize,
> -				      io_ptr, ret_fs);
> -	} else if (ctx->superblock) {
> -		int blocksize;
> -		for (blocksize =3D EXT2_MIN_BLOCK_SIZE;
> -		     blocksize <=3D EXT2_MAX_BLOCK_SIZE; blocksize *=3D =
2) {
> -			if (*ret_fs) {
> -				ext2fs_free(*ret_fs);
> -				*ret_fs =3D NULL;
> -			}
> -			retval =3D ext2fs_open2(ctx->filesystem_name,
> -					      ctx->io_options, flags,
> -					      ctx->superblock, =
blocksize,
> -					      io_ptr, ret_fs);
> -			if (!retval)
> -				break;
> -		}
> -	} else
> -		retval =3D ext2fs_open2(ctx->filesystem_name, =
ctx->io_options,
> -				      flags, 0, 0, io_ptr, ret_fs);
> -
> +	retval =3D ext2fs_open2(ctx->filesystem_name, ctx->io_options,
> +			   flags, ctx->superblock, ctx->blocksize,
> +			   io_ptr, ret_fs);
> 	if (retval =3D=3D 0) {
> 		(*ret_fs)->priv_data =3D ctx;
> 		e2fsck_set_bitmap_type(*ret_fs, EXT2FS_BMAP64_RBTREE,
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 85d73e2a..7c16e386 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -114,10 +114,10 @@ static void block_sha_map_free_entry(void *data)
>  *	EXT2_FLAG_64BITS - Allow 64-bit bitfields (needed for large
>  *				filesystems)
>  */
> -errcode_t ext2fs_open2(const char *name, const char *io_options,
> -		       int flags, int superblock,
> -		       unsigned int block_size, io_manager manager,
> -		       ext2_filsys *ret_fs)
> +static errcode_t __ext2fs_open2(const char *name, const char =
*io_options,
> +				int flags, int superblock,
> +				unsigned int block_size, io_manager =
manager,
> +				ext2_filsys *ret_fs)
> {
> 	ext2_filsys	fs;
> 	errcode_t	retval;
> @@ -515,6 +515,39 @@ cleanup:
> 	return retval;
> }
>=20
> +errcode_t ext2fs_open2(const char *name, const char *io_options,
> +		       int flags, int superblock,
> +		       unsigned int block_size, io_manager manager,
> +		       ext2_filsys *ret_fs)
> +{
> +	errcode_t retval;
> +
> +	*ret_fs =3D NULL;
> +	if (superblock && block_size) {
> +		retval =3D __ext2fs_open2(name, io_options,
> +				      flags, superblock, block_size,
> +				      manager, ret_fs);
> +	} else if (superblock) {
> +		int block_size;
> +
> +		for (block_size =3D EXT2_MIN_BLOCK_SIZE;
> +		     block_size <=3D EXT2_MAX_BLOCK_SIZE; block_size *=3D =
2) {
> +			if (*ret_fs) {
> +				ext2fs_free(*ret_fs);
> +				*ret_fs =3D NULL;
> +			}
> +			retval =3D __ext2fs_open2(name, io_options, =
flags,
> +						superblock, block_size,
> +						manager, ret_fs);
> +			if (!retval)
> +				break;
> +		}
> +	} else
> +		retval =3D __ext2fs_open2(name, io_options,
> +				      flags, 0, 0, manager, ret_fs);
> +	return retval;
> +}
> +
> /*
>  * Set/get the filesystem data I/O channel.
>  *
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 384ce925..183e2f6f 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -667,21 +667,8 @@ int main (int argc, char ** argv)
> 	if (image_dump)
> 		flags |=3D EXT2_FLAG_IMAGE_FILE;
> try_open_again:
> -	if (use_superblock && !use_blocksize) {
> -		for (use_blocksize =3D EXT2_MIN_BLOCK_SIZE;
> -		     use_blocksize <=3D EXT2_MAX_BLOCK_SIZE;
> -		     use_blocksize *=3D 2) {
> -			retval =3D ext2fs_open (device_name, flags,
> -					      use_superblock,
> -					      use_blocksize, =
unix_io_manager,
> -					      &fs);
> -			if (!retval)
> -				break;
> -		}
> -	} else {
> -		retval =3D ext2fs_open(device_name, flags, =
use_superblock,
> -				     use_blocksize, unix_io_manager, =
&fs);
> -	}
> +	retval =3D ext2fs_open2(device_name, 0, flags, use_superblock,
> +			      use_blocksize, unix_io_manager, &fs);
> 	flags |=3D EXT2_FLAG_IGNORE_CSUM_ERRORS;
> 	if (retval && !retval_csum) {
> 		retval_csum =3D retval;
> --
> 2.14.3
>=20


Cheers, Andreas






--Apple-Mail=_EF044333-3AD8-450B-BB56-B8EBFCA786F4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwtAFMACgkQcqXauRfM
H+DMmRAAkK89HiQeFB+htAQh1AqaYDBGyxuDh2qn7ztQZlCEeywYv8Hx/HszrFQy
JeSszHA1u16xFQhGfyml89WueuxoZbw2R5ZyAcEGilKifYypfckmPQ+pUuAPTYSo
4M0l7R9fLkYHePBhd7SuhIvee3XlWiqyvZbojo3TH2vOTVUqCH5KYLxu8uHFZ583
U4Lu9HcJFbz4Wj5EmuyXo4TuVHeLW0zkw6bi+aifQ1D1UVZO0aNESTxicU4PCDzF
jmmNvo3U2KtZUAM2TSsF5SdxVxFmkFSccid6quEFXfjY/2PZLfpaVKygYxRootNZ
0MqTwKqcVtskzUAQxzrFmsqFz35XyMjZkDCILSE7Ze8rXeXGE6sbOOUvNva6cUTV
drsyXPLFmhjWb37AnDggFL3XEzGVHTX5V8UrTbQJTFtlI5ZlKPxlUJwaTiv9iC3k
a3udtmvhIsKnxYP7V/7Ra0QQyW6eOyHv2BQEGeZpL+aJ+sI93+6/2H+LcMS6Wmdp
CDCAIFNL5oA0rEJmiPPhgHFw28xHD8WIRza8Yu+38Bd9Jh6HxdrVTnf/hiyiBelL
20VmmofpIPzy7kjnPLHqqTWUtENZhGb7eOcr4uaZDmKuDBMOr4h8pW+AAO5CwEf6
8ZYx5X3Jf2IdEceJvD2u9H3ZyO1tYo6BLAU5pHORtd1odA5m6n4=
=Xfei
-----END PGP SIGNATURE-----

--Apple-Mail=_EF044333-3AD8-450B-BB56-B8EBFCA786F4--
