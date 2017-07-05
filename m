From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/4] ext2fs: opening filesystem code refactoring
Date: Wed, 5 Jul 2017 11:01:02 -0600
Message-ID: <C1DA2353-1CA0-4DC0-A15F-BA0364D98241@dilger.ca>
References: <1498496326-76684-1-git-send-email-artem.blagodarenko@gmail.com>
 <1498496326-76684-2-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_973A1A1D-8DF4-4E9E-A641-0F7629EDF765";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, alexey.lyashkov@gmail.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36593 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbdGEQ7w (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2017 12:59:52 -0400
Received: by mail-it0-f65.google.com with SMTP id k3so13984073ita.3
        for <linux-ext4@vger.kernel.org>; Wed, 05 Jul 2017 09:59:52 -0700 (PDT)
In-Reply-To: <1498496326-76684-2-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_973A1A1D-8DF4-4E9E-A641-0F7629EDF765
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 26, 2017, at 10:58 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>=20
> There are similar opening filesystem code in different utilities.
>=20
> The patch moves this code to ext2fs_try_open_fs().
> This function make one of the action based on parameters:
> 1) open filesystem with given superblock, superblock size
> 2) open filesystem with given superblock, but try to
> find right block size
> 3) open filesystem with default superblock and block size

I'm definitely in favour of this, but wonder if this should just become =
part
of ext2fs_open2(), so that other tools also get the benefit of this =
change?
That could be done only if the superblock number and blocksize are zero.

Should this also try at least a few backup superblocks (e.g. {1, 3, 5, =
7, 9} *
blocksize * 8)?

Also, e2fsck/util.c::get_backup_sb() does something very similar.  In =
"main()"
this is called just before calling try_open_fs(), which you've updated =
below.
If ext2fs_try_open() also tried backup superblocks then get_backup_sb() =
wouldn't
be needed at all.

> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> ---
> e2fsck/unix.c       |   28 +++-------------------------
> lib/ext2fs/ext2fs.h |    4 ++++
> lib/ext2fs/openfs.c |   32 ++++++++++++++++++++++++++++++++
> misc/dumpe2fs.c     |   17 +++--------------
> 4 files changed, 42 insertions(+), 39 deletions(-)
>=20
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index ff96148..76f984b 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1116,31 +1116,9 @@ static errcode_t try_open_fs(e2fsck_t ctx, int =
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
> +	retval =3D ext2fs_try_open_fs(ctx->filesystem_name, =
ctx->io_options,
> +			   ctx->superblock, ctx->blocksize, flags,
> +			   io_ptr, ret_fs);
> 	if (retval =3D=3D 0) {
> 		(*ret_fs)->priv_data =3D ctx;
> 		e2fsck_set_bitmap_type(*ret_fs, EXT2FS_BMAP64_RBTREE,
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index c18ea5f..1163ab6 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1577,6 +1577,10 @@ extern errcode_t ext2fs_open2(const char *name, =
const char *io_options,
> 			      int flags, int superblock,
> 			      unsigned int block_size, io_manager =
manager,
> 			      ext2_filsys *ret_fs);
> +extern errcode_t ext2fs_try_open_fs(char *filesystem_name, char =
*io_options,
> +			     blk64_t superblock, int blocksize, int =
flags,
> +			     io_manager io_ptr, ext2_filsys *ret_fs);
> +
> /*
>  * The dgrp_t argument to these two functions is not actually a group =
number
>  * but a block number offset within a group table!  Convert with the =
formula
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 93b02ed..a236b40 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -487,6 +487,38 @@ cleanup:
> 	return retval;
> }
>=20
> +errcode_t ext2fs_try_open_fs(char *filesystem_name, char *io_options,
> +			     blk64_t superblock, int blocksize, int =
flags,
> +			     io_manager io_ptr, ext2_filsys *ret_fs)
> +{
> +	errcode_t retval;
> +
> +	*ret_fs =3D NULL;
> +	if (superblock && blocksize) {
> +		retval =3D ext2fs_open2(filesystem_name, io_options,
> +				      flags, superblock, blocksize,
> +				      io_ptr, ret_fs);
> +	} else if (superblock) {
> +		int blocksize;
> +		for (blocksize =3D EXT2_MIN_BLOCK_SIZE;
> +		     blocksize <=3D EXT2_MAX_BLOCK_SIZE; blocksize *=3D =
2) {
> +			if (*ret_fs) {
> +				ext2fs_free(*ret_fs);
> +				*ret_fs =3D NULL;
> +			}
> +			retval =3D ext2fs_open2(filesystem_name,
> +					      io_options, flags,
> +					      superblock, blocksize,
> +					      io_ptr, ret_fs);
> +			if (!retval)
> +				break;
> +		}
> +	} else
> +		retval =3D ext2fs_open2(filesystem_name, io_options,
> +				      flags, 0, 0, io_ptr, ret_fs);
> +	return retval;
> +}
> +
> /*
>  * Set/get the filesystem data I/O channel.
>  *
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 395ea9e..0f55cfb 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -568,20 +568,9 @@ int main (int argc, char ** argv)
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
> -	} else
> -		retval =3D ext2fs_open (device_name, flags, =
use_superblock,
> -				      use_blocksize, unix_io_manager, =
&fs);
> +	retval =3D ext2fs_try_open_fs(device_name, 0,
> +				    use_superblock, use_blocksize, =
flags,
> +				    unix_io_manager, &fs);
> 	if (retval && !(flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)) {
> 		flags |=3D EXT2_FLAG_IGNORE_CSUM_ERRORS;
> 		goto try_open_again;
> --
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_973A1A1D-8DF4-4E9E-A641-0F7629EDF765
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZXRtOpIg59Q01vtYRAkVyAKCrtF+ATzSHlmceOjmqddKQriNPVACfSkMo
ZZMkbkLSqohlY/EhTtmu9zk=
=z+PN
-----END PGP SIGNATURE-----

--Apple-Mail=_973A1A1D-8DF4-4E9E-A641-0F7629EDF765--
