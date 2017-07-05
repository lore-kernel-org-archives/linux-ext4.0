From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] e2fsprogs: add ext2fs_is_fast_symlink() function
Date: Wed, 5 Jul 2017 10:26:16 -0600
Message-ID: <4005AF3A-2FFA-4285-B4B8-9952633782FD@dilger.ca>
References: <20170630013159.28178-1-tahsin@google.com>
 <20170630013608.29185-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8C13ACAE-43AB-4E7B-A7EC-C01D07F2DA4D";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34195 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751681AbdGEQZI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2017 12:25:08 -0400
Received: by mail-it0-f65.google.com with SMTP id o202so14566722itc.1
        for <linux-ext4@vger.kernel.org>; Wed, 05 Jul 2017 09:25:08 -0700 (PDT)
In-Reply-To: <20170630013608.29185-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8C13ACAE-43AB-4E7B-A7EC-C01D07F2DA4D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 29, 2017, at 7:36 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> Current way of determining whether a symlink is in fast symlink
> format is to call ext2fs_inode_data_blocks2(). If number of data
> blocks is zero and EXT4_INLINE_DATA_FL flag is not set, then symlink
> data must be in inode->i_block.
>=20
> This heuristic is becoming increasingly hard to maintain because
> inode->i_blocks count can also be incremented for blocks used by
> extended attributes. Before ea_inode feature, extra block could come
> from xattr block, now more blocks can be added because of xattr
> inodes.
>=20
> To address the issue, add a ext2fs_is_fast_symlink() function that
> gives a direct answer based on inode->i_size field. This is
> equivalent to kernel's ext4_inode_is_fast_symlink() function.
>=20
> This patch also fixes a few issues related to fast symlink handling:
>=20
>  - Both rdump_symlink() and follow_link() interpreted symlinks with
>    0 data blocks to always mean fast symlinks. This is incorrect
>    because symlinks that are stored as inline data also have
>    0 data blocks. Thus, they try to read everything from
>    inode->i_block and miss the symlink suffix in inode extra area.
>=20
>  - e2fsck_pass1_check_symlink() had code to handle inode with
>    EXT4_INLINE_DATA_FL flag twice. The first if block always returns
>    from the function so the second one is unreachable code.

This looks mostly good, one question below.

> Suggested-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> v2: Added Suggested-by to commit message
>=20
> debugfs/debugfs.c    | 55 =
+++++++++++++++++++++++-----------------------------
> debugfs/dump.c       |  4 +---
> e2fsck/pass1.c       | 42 ++++++++-------------------------------
> lib/ext2fs/alloc.c   |  9 +++++----
> lib/ext2fs/ext2fs.h  |  1 +
> lib/ext2fs/namei.c   | 20 ++++++++++++++++---
> lib/ext2fs/swapfs.c  | 46 +++++++++++++++++++++----------------------
> lib/ext2fs/symlink.c | 11 +++++++++++
> misc/fuse2fs.c       |  9 ++++-----
> 9 files changed, 94 insertions(+), 103 deletions(-)
>=20
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 422a3d699111..dd650427795c 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
>=20
> @@ -221,12 +220,15 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, =
ext2_ino_t ino,
> 		return 1;
> 	}
>=20
> -	blocks =3D ext2fs_inode_data_blocks2(fs, inode);
> -	if (blocks) {
> -		if (inode->i_flags & EXT4_INLINE_DATA_FL)
> +	if (ext2fs_is_fast_symlink(inode)) {
> +		if (inode->i_size >=3D sizeof(inode->i_block))
> +			return 0;

If this is a fast symlink, which is now determined by the file size, I =
don't see
how this i_size check can ever be true?

> +
> +		len =3D strnlen((char *)inode->i_block, =
sizeof(inode->i_block));
> +		if (len =3D=3D sizeof(inode->i_block))
> 			return 0;
> +	} else {
> 		if ((inode->i_size >=3D fs->blocksize) ||
> 		    (inode->i_block[0] < fs->super->s_first_data_block) =
||
> 		    (inode->i_block[0] >=3D =
ext2fs_blocks_count(fs->super)))
> 			return 0;
> diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
> index 0e6f9a9fd14e..271aa1ccc134 100644
> --- a/lib/ext2fs/symlink.c
> +++ b/lib/ext2fs/symlink.c
> @@ -174,3 +174,14 @@ cleanup:
> 		ext2fs_free_mem(&block_buf);
> 	return retval;
> }
> +
> +/*
> + * Test whether an inode is a fast symlink.
> + *
> + * A fast symlink has its symlink data stored in inode->i_block.
> + */
> +int ext2fs_is_fast_symlink(struct ext2_inode *inode)
> +{
> +	return LINUX_S_ISLNK(inode->i_mode) && EXT2_I_SIZE(inode) &&
> +	       EXT2_I_SIZE(inode) < sizeof(inode->i_block);
> +}
> \ No newline at end of file

Need to add newline here?


Cheers, Andreas






--Apple-Mail=_8C13ACAE-43AB-4E7B-A7EC-C01D07F2DA4D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZXRMqpIg59Q01vtYRAoInAKDZVNQQcW/lDipCyP9mDj/0kljQ1wCfW8GO
pMOoUmTgIc3t8a+6Ct1zms4=
=pa00
-----END PGP SIGNATURE-----

--Apple-Mail=_8C13ACAE-43AB-4E7B-A7EC-C01D07F2DA4D--
