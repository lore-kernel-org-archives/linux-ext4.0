From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH 2/4] Create the journal in the middle of the filesystem
Date: Thu, 28 Aug 2008 11:55:21 +0200
Message-ID: <1219917321.3591.79.camel@frecb007923.frec.bull.fr>
References: <20080827210636.GC26987@mit.edu>
	 <1219871676-18456-1-git-send-email-tytso@mit.edu>
	 <1219871676-18456-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58192 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYH1HxX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 03:53:23 -0400
In-Reply-To: <1219871676-18456-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le mercredi 27 ao=C3=BBt 2008 =C3=A0 17:14 -0400, Theodore Ts'o a =C3=A9=
crit :
> This speeds up access to the journal by eliminating worst-case seeks
> from one end of the disk to another, which can be quite common in ver=
y
> fsync-intensive workloads if the file is located near the end of the
> disk, and the journal is located the beginning of the disk.
>=20
> In addition, this can help eliminate journal fragmentation when
> flex_bg is enabled, since the first block group has a large amount of
> metadata.
>=20
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/mkjournal.c |   28 +++++++++++++++++++++++-----
>  1 files changed, 23 insertions(+), 5 deletions(-)
>=20
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index 3cae874..cd3df07 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -198,6 +198,7 @@ errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_=
t blk, int num,
>  struct mkjournal_struct {
>  	int		num_blocks;
>  	int		newblocks;
> +	blk_t		goal;
>  	blk_t		blk_to_zero;
>  	int		zero_count;
>  	char		*buf;
> @@ -213,14 +214,13 @@ static int mkjournal_proc(ext2_filsys	fs,
>  {
>  	struct mkjournal_struct *es =3D (struct mkjournal_struct *) priv_da=
ta;
>  	blk_t	new_blk;
> -	static blk_t	last_blk =3D 0;
>  	errcode_t	retval;
>  =09
>  	if (*blocknr) {
> -		last_blk =3D *blocknr;
> +		es->goal =3D *blocknr;
>  		return 0;
>  	}
> -	retval =3D ext2fs_new_block(fs, last_blk, 0, &new_blk);
> +	retval =3D ext2fs_new_block(fs, es->goal, 0, &new_blk);
>  	if (retval) {
>  		es->err =3D retval;
>  		return BLOCK_ABORT;
> @@ -258,8 +258,7 @@ static int mkjournal_proc(ext2_filsys	fs,
>  		es->err =3D retval;
>  		return BLOCK_ABORT;
>  	}
> -	*blocknr =3D new_blk;
> -	last_blk =3D new_blk;
> +	*blocknr =3D es->goal =3D new_blk;
>  	ext2fs_block_alloc_stats(fs, new_blk, +1);
> =20
>  	if (es->num_blocks =3D=3D 0)
> @@ -276,6 +275,7 @@ static errcode_t write_journal_inode(ext2_filsys =
fs, ext2_ino_t journal_ino,
>  				     blk_t size, int flags)
>  {
>  	char			*buf;
> +	dgrp_t			group, start, end, i;
>  	errcode_t		retval;
>  	struct ext2_inode	inode;
>  	struct mkjournal_struct	es;
> @@ -298,6 +298,24 @@ static errcode_t write_journal_inode(ext2_filsys=
 fs, ext2_ino_t journal_ino,
>  	es.err =3D 0;
>  	es.zero_count =3D 0;
> =20
> +	/*
> +	 * Set the initial goal block to be roughly at the middle of
> +	 * the filesystem.  Pick a group that has the largest number
> +	 * of free blocks.
> +	 */
> +	group =3D ext2fs_group_of_blk(fs, (fs->super->s_blocks_count -=20
> +					 fs->super->s_first_data_block) / 2);
> +	start =3D (group > 0) ? group-1 : group;
> +	end =3D ((group+1) < fs->group_desc_count) ? group+1 : group;

With 512 groups by flex group, meta-datas for a single flex-group are 8
groups long ! If we have no luck and there are a bunch of groups
occupied by meta-datas at the middle of the filesystem, we should
slightly increase the number of groups scanned to find a completely fre=
e
group.

> +	group =3D start;
> +	for (i=3Dstart+1; i <=3D end; i++)
> +		if (fs->group_desc[i].bg_free_blocks_count >
> +		    fs->group_desc[group].bg_free_blocks_count)
> +			group =3D i;

This is ok if the journal file has the default size, but not optimal if
it's bigger than one group.

> +
> +	es.goal =3D (fs->super->s_blocks_per_group * group) +
> +		fs->super->s_first_data_block;
> +
>  	retval =3D ext2fs_block_iterate2(fs, journal_ino, BLOCK_FLAG_APPEND=
,
>  				       0, mkjournal_proc, &es);
>  	if (es.err) {

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
