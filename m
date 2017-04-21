From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] e2fsck: update quota when optimizing the extent tree
Date: Fri, 21 Apr 2017 15:15:07 -0600
Message-ID: <C0EE07FD-40C0-4074-83CE-32F6A092A265@dilger.ca>
References: <20170415134118.17808-1-tytso@mit.edu>
 <20170416191739.GA5185@birch.djwong.org>
 <20170421073743.btwz6274h4ou3bze@thunk.org>
 <20170421162711.GA3972@birch.djwong.org>
 <20170421200600.zvgjbblbrftvlfb4@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_0356107E-0340-4A74-AAC2-1F995CAD75C0";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35676 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422809AbdDUVPM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Apr 2017 17:15:12 -0400
Received: by mail-io0-f196.google.com with SMTP id d203so34599781iof.2
        for <linux-ext4@vger.kernel.org>; Fri, 21 Apr 2017 14:15:11 -0700 (PDT)
In-Reply-To: <20170421200600.zvgjbblbrftvlfb4@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_0356107E-0340-4A74-AAC2-1F995CAD75C0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 21, 2017, at 2:06 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> =46rom bc177d425d4fe33b0ae774b218b055465a840ca1 Mon Sep 17 00:00:00 =
2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sat, 15 Apr 2017 00:29:46 -0400
> Subject: [PATCH] e2fsck: update quota when optimizing the extent tree
>=20
> If quota is enabled, optimizing the extent tree wouldn't update the
> in-memory quota statistics, so that a subsequent e2fsck run would show
> that the quota usage statistics on disk were incorrect.
>=20
> Google-Bug-Id: 36391645
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> e2fsck/extents.c | 26 +++++++++++++++++++++-----
> 1 file changed, 21 insertions(+), 5 deletions(-)
>=20
> diff --git a/e2fsck/extents.c b/e2fsck/extents.c
> index c4167e16..7f28e6dd 100644
> --- a/e2fsck/extents.c
> +++ b/e2fsck/extents.c
> @@ -208,17 +208,19 @@ static int find_blocks(ext2_filsys fs, blk64_t =
*blocknr, e2_blkcnt_t blockcnt,
> static errcode_t rebuild_extent_tree(e2fsck_t ctx, struct extent_list =
*list,
> 				     ext2_ino_t ino)
> {
> -	struct ext2_inode	inode;
> +	struct ext2_inode_large	inode;
> 	errcode_t		retval;
> 	ext2_extent_handle_t	handle;
> 	unsigned int		i, ext_written;
> 	struct ext2fs_extent	*ex, extent;
> +	blk64_t			start_val, delta;
>=20
> 	list->count =3D 0;
> 	list->blocks_freed =3D 0;
> 	list->ino =3D ino;
> 	list->ext_read =3D 0;
> -	e2fsck_read_inode(ctx, ino, &inode, "rebuild_extents");
> +	e2fsck_read_inode_full(ctx, ino, EXT2_INODE(&inode), =
sizeof(inode),
> +			       "rebuild_extents");

I'm always a bit puzzled why e2fsck_read_inode_full() takes ext2_inode
as an argument instead of ext2_inode_large, but that isn't the fault of
this patch.

>=20
> 	/* Skip deleted inodes and inline data files */
> 	if (inode.i_links_count =3D=3D 0 ||
> @@ -248,16 +250,20 @@ extents_loaded:
> 	memset(inode.i_block, 0, sizeof(inode.i_block));
>=20
> 	/* Make a note of freed blocks */
> -	retval =3D ext2fs_iblk_sub_blocks(ctx->fs, &inode, =
list->blocks_freed);
> +	quota_data_sub(ctx->qctx, &inode, ino,
> +		       list->blocks_freed * ctx->fs->blocksize);

Should this quota_data_sub() call be after ext2fs_iblk_sub_blocks() has
completed successfully, or are the blocks already freed at this point
and only the inode->i_blocks counter would be outdated?

> +	retval =3D ext2fs_iblk_sub_blocks(ctx->fs, EXT2_INODE(&inode),
> +					list->blocks_freed);
> 	if (retval)
> 		goto err;
>=20
> 	/* Now stuff extents into the file */
> -	retval =3D ext2fs_extent_open2(ctx->fs, ino, &inode, &handle);
> +	retval =3D ext2fs_extent_open2(ctx->fs, ino, EXT2_INODE(&inode), =
&handle);
> 	if (retval)
> 		goto err;
>=20
> 	ext_written =3D 0;
> +	start_val =3D ext2fs_inode_i_blocks(ctx->fs, =
EXT2_INODE(&inode));

In theory this could go at the start before any changes are made to the
inode, and then there wouldn't be the need for the intermediate call to
quota_data_sub() above?  That avoids a small amount of overhead, and
also avoids the more complicated issue of the quota file being modified
even if this operation hits an error and is skipped (i.e. any "goto err"
case).

Cheers, Andreas

> 	for (i =3D 0, ex =3D list->extents; i < list->count; i++, ex++) =
{
> 		memcpy(&extent, ex, sizeof(struct ext2fs_extent));
> 		extent.e_flags &=3D EXT2_EXTENT_FLAGS_UNINIT;
> @@ -295,11 +301,21 @@ extents_loaded:
> 		ext_written++;
> 	}
>=20
> +	delta =3D ext2fs_inode_i_blocks(ctx->fs, EXT2_INODE(&inode)) - =
start_val;
> +	if (delta) {
> +		if (!ext2fs_has_feature_huge_file(ctx->fs->super) ||
> +		    !(inode.i_flags & EXT4_HUGE_FILE_FL))
> +			delta <<=3D 9;
> +		else
> +			delta *=3D ctx->fs->blocksize;
> +		quota_data_add(ctx->qctx, &inode, ino, delta);
> +	}
> +
> #if defined(DEBUG) || defined(DEBUG_SUMMARY)
> 	printf("rebuild: ino=3D%d extents=3D%d->%d\n", ino, =
list->ext_read,
> 	       ext_written);
> #endif
> -	e2fsck_write_inode(ctx, ino, &inode, "rebuild_extents");
> +	e2fsck_write_inode(ctx, ino, EXT2_INODE(&inode), =
"rebuild_extents");
>=20
> err2:
> 	ext2fs_extent_free(handle);
> --
> 2.11.0.rc0.7.gbe5a750
>=20


Cheers, Andreas






--Apple-Mail=_0356107E-0340-4A74-AAC2-1F995CAD75C0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY+nZbpIg59Q01vtYRAlmtAKCtEYZcoqkWsa3/nnwZL+fBX2af5gCg7vmW
iCXnQiiuFSPiryxSEd11+Ww=
=c2Y2
-----END PGP SIGNATURE-----

--Apple-Mail=_0356107E-0340-4A74-AAC2-1F995CAD75C0--
