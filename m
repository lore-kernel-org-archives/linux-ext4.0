From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 1/4] ext2fs: opening filesystem code refactoring
Date: Mon, 20 Nov 2017 12:42:34 -0700
Message-ID: <472F8A4A-63CF-4286-BD9A-5BE4981D2443@dilger.ca>
References: <20171116135546.9991-1-artem.blagodarenko@gmail.com>
 <20171116135546.9991-2-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_EB04C767-A7A1-443B-B036-C15A9CDA48D6";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:40143 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbdKTTmZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Nov 2017 14:42:25 -0500
Received: by mail-it0-f66.google.com with SMTP id 72so13102591itl.5
        for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2017 11:42:24 -0800 (PST)
In-Reply-To: <20171116135546.9991-2-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_EB04C767-A7A1-443B-B036-C15A9CDA48D6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 16, 2017, at 6:55 AM, Artem Blagodarenko =
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
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> e2fsck/unix.c       | 28 +++-------------------------
> lib/ext2fs/ext2fs.h |  4 ++++
> lib/ext2fs/openfs.c | 36 +++++++++++++++++++++++++++++++++++-
> misc/dumpe2fs.c     | 17 +++--------------
> 4 files changed, 45 insertions(+), 40 deletions(-)
>=20
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 6774e32c..c394ec80 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1588,6 +1588,10 @@ extern errcode_t ext2fs_open2(const char *name, =
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

This ext2fs_try_open_fs() function is declared here, but isn't added in =
this
patch.  It is removed in the next patch, but should really have been =
removed
here instead.

> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index f74cd245..585ad766 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -497,6 +497,40 @@ cleanup:
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
> +			retval =3D __ext2fs_open2(name,
> +					      io_options, flags,
> +					      superblock, block_size,
> +					      manager, ret_fs);
> +			if (!retval)
> +				break;
> +		}
> +	} else
> +		retval =3D __ext2fs_open2(name, io_options,
> +				      flags, 0, 0, manager, ret_fs);

I still think it would be useful to automatically try to open the backup
superblocks, if no superblock number is specified.  That could be done
in a separate patch.

In general, it looks like a good cleanup of the code.

Cheers, Andreas






--Apple-Mail=_EB04C767-A7A1-443B-B036-C15A9CDA48D6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaEzArpIg59Q01vtYRApIhAKDiqW9zxnxOigiB8wTcWM7GKuk8XACgnW4W
rIMELZG9eCAnnv0aTtRr09Y=
=8Lop
-----END PGP SIGNATURE-----

--Apple-Mail=_EB04C767-A7A1-443B-B036-C15A9CDA48D6--
