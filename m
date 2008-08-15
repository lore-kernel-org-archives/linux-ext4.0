From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 0/6 ]Ext4 journal credits reservation fixes
Date: Fri, 15 Aug 2008 12:02:55 -0700
Message-ID: <1218826975.8183.28.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
	 <20080815173321.GC6511@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:43076 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760233AbYHOTDA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 15:03:00 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7FJ2xT5023086
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 15:02:59 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FJ2xae166638
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 13:02:59 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FJ2w36031428
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 13:02:59 -0600
In-Reply-To: <20080815173321.GC6511@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-15=E4=BA=94=E7=9A=84 23:03 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Tue, Aug 12, 2008 at 09:23:10AM -0700, Mingming Cao wrote:
> > This is a rework of journal credits fix patch in the ext4 patch que=
ue.
> > The patch series contains
> >=20
> > - patch 1: helper funtions for journal credits calculation and fix =
the
> > writepage/write_begin on nonextent files
> > - patch 2: journal credit fix wirtepahe/write_begin for extents fil=
es,
> > and migration
> > - patch 3: credit fix for dio, fallocate
> > -patch 4: rebase ext4_da_writepages_rework patch
> > - patch 5: credit fix for delalloc writepages
> > -patch 6: credit fix for defrag
> >=20
> >=20
>=20
> I see this patch is pushed to the patch queue. Below is the review in
> patch form.
>=20
> commit 679a6fa1de0bc67c0a444b748696a2f2c22428c7
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Fri Aug 15 22:13:07 2008 +0530
>=20
>     cleanup
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 258cd1a..164c988 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1150,7 +1150,8 @@ extern void ext4_set_inode_flags(struct inode *=
);
>  extern void ext4_get_inode_flags(struct ext4_inode_info *);
>  extern void ext4_set_aops(struct inode *inode);
>  extern int ext4_writepage_trans_blocks(struct inode *);
> -extern int ext4_meta_trans_blocks(struct inode *, int nrblocks, int =
idxblocks);
> +extern int ext4_meta_trans_blocks(struct inode *, int nrblocks,
> +					int idxblocks, bool chunk);

This might be the right thing to do , but  I don't see other places in
ext3/4 uses "bool" type for a flag.    I think just to keep the code
consistant,  using "int" as a flag varibale type is quit common, not a
big deal anyway.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0b34998..a843cd3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1568,9 +1568,9 @@ static void ext4_da_release_space(struct inode =
*inode, int to_free)
>  		 * but since this function is called from invalidate
>  		 * page, it's harmless to return without any action
>  		 */
> -		printk(KERN_INFO "ext4 delalloc try to release %d reserved"
> -			    "blocks for inode %lu, but there is no reserved"
> -			    "data blocks\n", inode->i_ino, to_free);
> +		printk(KERN_INFO "ext4 delalloc try to release %d reserved "
> +			    "blocks for inode %lu, but there is no reserved "
> +			    "data blocks\n", to_free, inode->i_ino);
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		return;
>  	}

The compile warning has already fixed in patch queue. I wan't sure what
do you mean in your last email about adding a space at the end of each
line?

> @@ -2303,13 +2303,13 @@ static int ext4_da_writepage(struct page *pag=
e,
>   * get_block is calculated
>   */
>=20
> -#define		EXT4_MAX_WRITEPAGES_SIZE	PAGEVEC_SIZE
> -static int ext4_writepages_trans_blocks(struct inode *inode)
> +static int ext4_da_writepages_trans_blocks(struct inode *inode)
>  {
> -	int bpp =3D ext4_journal_blocks_per_page(inode);
> -	int max_blocks =3D EXT4_MAX_WRITEPAGES_SIZE * bpp;
> -
> -	if (max_blocks > EXT4_I(inode)->i_reserved_data_blocks)
> +	int max_blocks;
> +	if (EXT4_I(inode)->i_reserved_data_blocks >
> +				EXT4_BLOCKS_PER_GROUP(inode->i_sb))
> +		max_blocks =3D  EXT4_BLOCKS_PER_GROUP(inode->i_sb);
> +	else
>  		max_blocks =3D  EXT4_I(inode)->i_reserved_data_blocks;
>=20

Hmm. EXT4_BLOCKS_PER_GROUP could still be too big for a single
transaction.  Default EXT4_BLOCKS_PER_GROUP is 32kblocks, that's could
still overflow the max capacity of a single journal log (default is 1/4
journal log size(128M)).

In fact, even if the EXT4_BLOCKS_PER_GROUP is the right value, and you
only limit the credit reservation here, later, we still need to  limit
the logical page extent to flush in mpage_da_writepages() to not exceed
the previously reserved credits.


> @@ -4459,13 +4459,19 @@ int ext4_getattr(struct vfsmount *mnt, struct=
 dentry *dentry,
>   * over different block groups
>   *
>   * Also account for superblock, inode, quota and xattr blocks
> + * This doesn't account for the blocks needed for journaled
> + * data blocks.
>   */
> -int ext4_meta_trans_blocks(struct inode* inode, int nrblocks, int id=
xblocks)
> +int ext4_meta_trans_blocks(struct inode* inode,
> +				int nrblocks, int idxblocks, bool chunk)
>  {
>  	int groups, gdpblocks;
>  	int ret =3D 0;
>=20
> -	groups =3D nrblocks + idxblocks;
> +	if (chunk)
> +		groups =3D 1 + idxblocks;

Not exactly right, the datablocks could spread over multiple block
groups with flex_bg.

if (chunk)
	groups =3D (nrblocks + 1 )/EXT4_BLOCKS_PER_GROUP + idxblocks;

> +	else
> +		groups =3D nrblocks + idxblocks;
>  	gdpblocks =3D groups;
>  	if (groups > EXT4_SB(inode->i_sb)->s_groups_count)
>  		groups =3D EXT4_SB(inode->i_sb)->s_groups_count;


I will fix the spell errors and update the patches.


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
