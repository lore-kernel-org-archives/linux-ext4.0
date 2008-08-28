From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH 2/4] Create the journal in the middle of the filesystem
Date: Thu, 28 Aug 2008 18:16:48 +0200
Message-ID: <1219940208.6206.10.camel@frecb007923.frec.bull.fr>
References: <20080827210636.GC26987@mit.edu>
	 <1219871676-18456-1-git-send-email-tytso@mit.edu>
	 <1219871676-18456-2-git-send-email-tytso@mit.edu>
	 <1219917321.3591.79.camel@frecb007923.frec.bull.fr>
	 <20080828133449.GG26987@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58418 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYH1OOx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 10:14:53 -0400
In-Reply-To: <20080828133449.GG26987@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le jeudi 28 ao=C3=BBt 2008 =C3=A0 09:34 -0400, Theodore Tso a =C3=A9cri=
t :
> On Thu, Aug 28, 2008 at 11:55:21AM +0200, Fr=C3=A9d=C3=A9ric Boh=C3=A9=
 wrote:
> > With 512 groups by flex group, meta-datas for a single flex-group a=
re 8
> > groups long ! If we have no luck and there are a bunch of groups
> > occupied by meta-datas at the middle of the filesystem, we should
> > slightly increase the number of groups scanned to find a completely=
 free
> > group.
>=20
> I'm not sure it ever makes sense to use such a huge -G setting, but
> yes, you're right.  It actually wasn't a major tragedy, since this
> just specifies the goal block, and so the block allocator would just
> search forward to find the first free block.  But it is better to mov=
e
> forward to the next free block group, so we leave space for interior
> nodes of the extent tree to be allocated.
>=20
> The following patch takes into account the flex_bg size, and will
> stash the journal in the first free block group after metadata; we do
> by starting at a flex_bg boundary, and then searching forward until
> bg_free_blocks_count is non-zero.  However, if the number of block
> groups is less than half of the flex_bg size, we'll just give up and
> throw it at the mid-point of the filesystem, since that (plus using
> extents instead of indirect blocks) is really the major optimization
> here. =20
>=20
> One or two discontinuities in the journal file really isn't a big
> deal, since we're normally seaking back and forth between the rest of
> the filesystem data blocks and the journal anyway.  The best benchmar=
k
> to see a problem isn't going to be bonnie, but something that which i=
s
> extremely fsync-intensive.
>=20
> 						- Ted
>=20
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index 96b574e..f5a9dba 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -275,7 +275,7 @@ static errcode_t write_journal_inode(ext2_filsys =
fs, ext2_ino_t journal_ino,
>  				     blk_t size, int flags)
>  {
>  	char			*buf;
> -	dgrp_t			group, start, end, i;
> +	dgrp_t			group, start, end, i, log_flex;
>  	errcode_t		retval;
>  	struct ext2_inode	inode;
>  	struct mkjournal_struct	es;
> @@ -311,7 +311,17 @@ static errcode_t write_journal_inode(ext2_filsys=
 fs, ext2_ino_t journal_ino,
>  	 */
>  	group =3D ext2fs_group_of_blk(fs, (fs->super->s_blocks_count -
>  					 fs->super->s_first_data_block) / 2);
> -	start =3D (group > 0) ? group-1 : group;
> +	log_flex =3D 1 << fs->super->s_log_groups_per_flex;
> +	if (fs->super->s_log_groups_per_flex && (group > log_flex)) {
> +		group =3D group & ~(log_flex - 1);
> +		while ((group < fs->group_desc_count) &&
> +		       fs->group_desc[group].bg_free_blocks_count =3D=3D 0)

I would have preferred this to test if a group is free :

			fs->group_desc[group].bg_free_blocks_count !=3D
				fs->super->s_blocks_per_group)

That's because there could be "holes" with free blocks in flex_bg
meta-datas when they cross backups superblocks and GDT. Very rare case
and not a big issue, I admit.

> +			group++;
> +		if (group =3D=3D fs->group_desc_count)
> +			group =3D 0;
> +		start =3D group;
> +	} else
> +		start =3D (group > 0) ? group-1 : group;
>  	end =3D ((group+1) < fs->group_desc_count) ? group+1 : group;
>  	group =3D start;
>  	for (i=3Dstart+1; i <=3D end; i++)
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
