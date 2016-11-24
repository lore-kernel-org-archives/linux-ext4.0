From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] ext4: Inode flags diet
Date: Wed, 23 Nov 2016 20:44:54 -0700
Message-ID: <75CE3DA6-3A1B-4802-BC71-4BBE37095116@dilger.ca>
References: <1475671375-22969-1-git-send-email-jack@suse.cz> <1475671375-22969-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_D26F9795-9041-445B-A461-0B44DA7E5E43"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33171 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbcKXDq2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Nov 2016 22:46:28 -0500
Received: by mail-io0-f193.google.com with SMTP id j92so3802582ioi.0
        for <linux-ext4@vger.kernel.org>; Wed, 23 Nov 2016 19:45:04 -0800 (PST)
In-Reply-To: <1475671375-22969-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D26F9795-9041-445B-A461-0B44DA7E5E43
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 5, 2016, at 6:42 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> Remove 6 inode flags that were apparently never used and only take up
> space in inode flags field which is already full.
>=20
> There are also other inode flags of doubtful use (not used by current
> Linux kernel - IMAGIC, NOTAIL, EA_INODE) but let's leave them there =
for
> now since I'm not quite sure about their status.

The EA_INODE flag is in use for large xattrs by Lustre.  I keep meaning
to push that upstream, but it depends on implementing new functionality
(64KB direct-access xattr chunk) that Ted requested, so I haven't
resubmitted it.

IMAGIC was supposed to be used by AFS, not sure if it is or not.

NOTAIL is used by btrfs, and in theory we could also use it with ext4
to prevent inline data being stored in the file?

The DIRTY, COMPRBLK, and NOCOMPR flags could definitely be removed since
we have never used these in ext4.

The ext2 versions of these flags have been redefined in terms of the
corresponding FS_*_FL flags, which makes it easier to see which flags
are common and which (if any) are unique to ext4.

The SECRM_FL is basically unusable from userspace, since the files
could be snapshotted, COW'd, or FTL'd in different places before the
file is unlinked.  The only real way secure erase is usable is if the
file is encrypted before it is written to disk.  This flag is present
in several other kernel filesystems and should be deleted from all of
them, possibly leaving a comment that this flag was previously SECRM
until kernel version 4.9 (or whatever) so it is not re-used immediately.

The COMPR and NOCOMPR flags are used by other filesystems (btrfs, ubifs,
cifs at least), so we could use it internally but it would be hard to
use for a new visible feature.

It seems it would also be possible to remove FS_EOFBLOCKS_FL from fs.h
since it is not even used by ext4 anymore.

Cheers, Andreas

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> fs/ext4/ext4.h | 34 +++++-----------------------------
> 1 file changed, 5 insertions(+), 29 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index a77a15df15b0..29605fb01cf8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -363,19 +363,11 @@ struct flex_groups {
> /*
>  * Inode flags
>  */
> -#define	EXT4_SECRM_FL			0x00000001 /* Secure =
deletion */
> -#define	EXT4_UNRM_FL			0x00000002 /* Undelete =
*/
> -#define	EXT4_COMPR_FL			0x00000004 /* Compress =
file */
> #define EXT4_SYNC_FL			0x00000008 /* Synchronous =
updates */
> #define EXT4_IMMUTABLE_FL		0x00000010 /* Immutable file */
> #define EXT4_APPEND_FL			0x00000020 /* writes to =
file may only append */
> #define EXT4_NODUMP_FL			0x00000040 /* do not =
dump file */
> #define EXT4_NOATIME_FL			0x00000080 /* do not =
update atime */
> -/* Reserved for compression usage... */
> -#define EXT4_DIRTY_FL			0x00000100
> -#define EXT4_COMPRBLK_FL		0x00000200 /* One or more =
compressed clusters */
> -#define EXT4_NOCOMPR_FL			0x00000400 /* Don't =
compress */
> -	/* nb: was previously EXT2_ECOMPR_FL */
> #define EXT4_ENCRYPT_FL			0x00000800 /* encrypted =
file */
> /* End compression flags --- maybe not all used */
> #define EXT4_INDEX_FL			0x00001000 /* hash-indexed =
directory */
> @@ -392,8 +384,8 @@ struct flex_groups {
> #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with =
parents projid */
> #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 =
lib */
>=20
> -#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags =
*/
> -#define EXT4_FL_USER_MODIFIABLE		0x204380FF /* User =
modifiable flags */
> +#define EXT4_FL_USER_VISIBLE		0x304BD8F8 /* User visible flags =
*/
> +#define EXT4_FL_USER_MODIFIABLE		0x204380F8 /* User =
modifiable flags */
>=20
> /* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
> #define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
> @@ -404,11 +396,9 @@ struct flex_groups {
> 					 EXT4_PROJINHERIT_FL)
>=20
> /* Flags that should be inherited by new inodes from their parent. */
> -#define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | =
EXT4_COMPR_FL |\
> -			   EXT4_SYNC_FL | EXT4_NODUMP_FL | =
EXT4_NOATIME_FL |\
> -			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
> -			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
> -			   EXT4_PROJINHERIT_FL)
> +#define EXT4_FL_INHERITED (EXT4_SYNC_FL | EXT4_NODUMP_FL | =
EXT4_NOATIME_FL |\
> +			   EXT4_JOURNAL_DATA_FL | EXT4_NOTAIL_FL | \
> +			   EXT4_DIRSYNC_FL | EXT4_PROJINHERIT_FL)
>=20
> /* Flags that are appropriate for regular files (all but dir-specific =
ones). */
> #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
> @@ -431,20 +421,12 @@ static inline __u32 ext4_mask_flags(umode_t =
mode, __u32 flags)
>  * Inode flags used for atomic set/get
>  */
> enum {
> -	EXT4_INODE_SECRM	=3D 0,	/* Secure deletion */
> -	EXT4_INODE_UNRM		=3D 1,	/* Undelete */
> -	EXT4_INODE_COMPR	=3D 2,	/* Compress file */
> 	EXT4_INODE_SYNC		=3D 3,	/* Synchronous updates */
> 	EXT4_INODE_IMMUTABLE	=3D 4,	/* Immutable file */
> 	EXT4_INODE_APPEND	=3D 5,	/* writes to file may only =
append */
> 	EXT4_INODE_NODUMP	=3D 6,	/* do not dump file */
> 	EXT4_INODE_NOATIME	=3D 7,	/* do not update atime */
> -/* Reserved for compression usage... */
> -	EXT4_INODE_DIRTY	=3D 8,
> -	EXT4_INODE_COMPRBLK	=3D 9,	/* One or more compressed =
clusters */
> -	EXT4_INODE_NOCOMPR	=3D 10,	/* Don't compress */
> 	EXT4_INODE_ENCRYPT	=3D 11,	/* Encrypted file */
> -/* End compression flags --- maybe not all used */
> 	EXT4_INODE_INDEX	=3D 12,	/* hash-indexed directory */
> 	EXT4_INODE_IMAGIC	=3D 13,	/* AFS directory */
> 	EXT4_INODE_JOURNAL_DATA	=3D 14,	/* file data should be journaled =
*/
> @@ -478,17 +460,11 @@ enum {
>=20
> static inline void ext4_check_flag_values(void)
> {
> -	CHECK_FLAG_VALUE(SECRM);
> -	CHECK_FLAG_VALUE(UNRM);
> -	CHECK_FLAG_VALUE(COMPR);
> 	CHECK_FLAG_VALUE(SYNC);
> 	CHECK_FLAG_VALUE(IMMUTABLE);
> 	CHECK_FLAG_VALUE(APPEND);
> 	CHECK_FLAG_VALUE(NODUMP);
> 	CHECK_FLAG_VALUE(NOATIME);
> -	CHECK_FLAG_VALUE(DIRTY);
> -	CHECK_FLAG_VALUE(COMPRBLK);
> -	CHECK_FLAG_VALUE(NOCOMPR);
> 	CHECK_FLAG_VALUE(ENCRYPT);
> 	CHECK_FLAG_VALUE(INDEX);
> 	CHECK_FLAG_VALUE(IMAGIC);
> --
> 2.6.6
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_D26F9795-9041-445B-A461-0B44DA7E5E43
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDZiOHKl2rkXzB/gAQjONRAAhvQZ/jBD3wAcNXPPheqpz0yPb+0s5qkl
94uL+O5f6WEtcehIY/RIqqCin1Q9edheHhhw7ccWexd/KTgDMJSqsnrKb5dl1DCW
Lq5BH3dV5Tmo40PXKfvkuIHCU9ekqJ3MhsaSXIfFhmRaGQ1Qgm3vwOHF9mFO+3Ns
gtR2/u0fuBSfW0d1hiSJYmJtEAUAfrGiRcwuHJr7ceD5F1irhEbXOlpdh5uTv1OS
LSmsrA0bA37e+YiW6N1UcXfd9niAFENRFLemIyQud9wWDuQazKdgbezyZd5i1gTZ
C+AwE+hdsFox5mtVQ0xxqPYkWz6rT71/IPsTroEmIHQq4vYQHpo38Lg2Gi7My/y/
UzT2rCUd1SSzI6gbSmiMg+mhtUvTi294rYCFic9/2sK04i6gAqcuh2DG5EU0Kpr1
C8pmcKdxm8rQTE2I6c9C/47vvgzVJ1VzZ/pDxTFZQb0QwbFZt9qtQJbVRbp82IE1
d362kpE03OXQo7NhPxRcxFi/pdK2iADw4p/lOvD+uvg+/ZNU4UlnxhUKWYxWtPQM
vKbH7yBew5A2vf+KcqnEY9jZIIbTdfjrXHs3Eth1wd9ah/CUVWYYRd8W8w7ZSnF3
Xj7R8FCb4JtC/roBVVyRqxsCMm6cD4I2TETZHleUzkMoi/pPuf+Dnz1vYoQOsnnR
NQPD2wjopV8=
=DSNC
-----END PGP SIGNATURE-----

--Apple-Mail=_D26F9795-9041-445B-A461-0B44DA7E5E43--
