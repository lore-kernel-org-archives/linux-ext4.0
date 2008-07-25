From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Fri, 25 Jul 2008 12:26:42 -0700
Message-ID: <1217014002.6322.29.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36080 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYGYT1H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 15:27:07 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6PJQtWc022935
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 15:26:55 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6PJQjJJ197294
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 15:26:45 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6PJQiZu003078
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 15:26:44 -0400
In-Reply-To: <20080723074226.GA15091@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-23=E4=B8=89=E7=9A=84 13:12 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> Hi Mingming,
>=20
> Comments below

> On Tue, Jul 22, 2008 at 05:51:51PM -0700, Mingming Cao wrote:
> > Ext4: journal credits reservation fixes for DIO, fallocate and dela=
lloc writepages
> >=20
> > From: Mingming Cao <cmm@us.ibm.com>
> >=20
> > With delalloc, at writepages() time, we need to reserve enough cred=
its to start
> > a new handle, to allow possible multiple segment of block allocatio=
ns under a
> > single call mapge_da_writepages(), so that metadata updates could f=
it into a single
> > transaction. This patch fixed this by calculating the needed credit=
s for
> > write-out given number of dirty pages, with the consideration of di=
scontinues
> > block allocations. It fixed both extent files and non extent files.
> >=20
> > This patch also fixed the journal credit reservation for DIO. Curre=
ntly the
> > estimated credits for DIO is only based on non extent format file. =
That credit
> > is not enough for mballoc a single extent on extent based file. Thi=
s patch
> > fixed that.
> >=20
> > The fallocate double booking credits for modifying super block etc,=
 this patch
> > fixed that.
> >=20
> > This also fix credit reservation in migration and defrag code.
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/ext4/defrag.c  |    4 +-
> >  fs/ext4/ext4.h    |    4 +-
> >  fs/ext4/extents.c |   37 ++++++++++++---------
> >  fs/ext4/inode.c   |   93 ++++++++++++++++++++++++-----------------=
-------------
> >  fs/ext4/migrate.c |    4 +-
> >  5 files changed, 72 insertions(+), 70 deletions(-)
> >=20
> > Index: linux-2.6.26-git6/fs/ext4/ext4.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.26-git6.orig/fs/ext4/ext4.h	2008-07-21 17:35:17.00000=
0000 -0700
> > +++ linux-2.6.26-git6/fs/ext4/ext4.h	2008-07-21 17:36:17.000000000 =
-0700
> > @@ -1149,7 +1149,7 @@ extern void ext4_truncate (struct inode=20
> >  extern void ext4_set_inode_flags(struct inode *);
> >  extern void ext4_get_inode_flags(struct ext4_inode_info *);
> >  extern void ext4_set_aops(struct inode *inode);
> > -extern int ext4_writepage_trans_blocks(struct inode *);
> > +extern int ext4_writepages_trans_blocks(struct inode *, int num);
> >  extern int ext4_block_truncate_page(handle_t *handle,
> >  		struct address_space *mapping, loff_t from);
> >  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct pa=
ge *page);
> > @@ -1314,7 +1314,7 @@ extern const struct inode_operations ext
> >=20
> >  /* extents.c */
> >  extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
> > -extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
> > +extern int ext4_ext_writepages_trans_blocks(struct inode *inode, i=
nt);
> >  extern int ext4_ext_get_blocks(handle_t *handle, struct inode *ino=
de,
> >  			ext4_lblk_t iblock,
> >  			unsigned long max_blocks, struct buffer_head *bh_result,
> > Index: linux-2.6.26-git6/fs/ext4/extents.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.26-git6.orig/fs/ext4/extents.c	2008-07-21 17:35:17.00=
0000000 -0700
> > +++ linux-2.6.26-git6/fs/ext4/extents.c	2008-07-21 17:36:17.0000000=
00 -0700
> > @@ -1887,11 +1887,12 @@ static int ext4_ext_rm_idx(handle_t *han
> >=20
> >  /*
> >   * ext4_ext_calc_credits_for_insert:
> > - * This routine returns max. credits that the extent tree can cons=
ume.
> > + * This routine returns max. credits that needed to insert an exte=
nt
> > + * to the extent tree.
> >   * It should be OK for low-performance paths like ->writepage()
> >   * To allow many writing processes to fit into a single transactio=
n,
> > - * the caller should calculate credits under i_data_sem and
> > - * pass the actual path.
> > + * When pass the actual path, the caller should calculate credits
> > + * under i_data_sem.
> >   */
> >  int ext4_ext_calc_credits_for_insert(struct inode *inode,
> >  						struct ext4_ext_path *path)
> > @@ -1930,9 +1931,6 @@ int ext4_ext_calc_credits_for_insert(str
> >  	 */
> >  	needed +=3D (depth * 2) + (depth * 2);
> >=20
> > -	/* any allocation modifies superblock */
> > -	needed +=3D 1;
> > -
>=20
>=20
> Why are we dropping the super block modification credit ? An insert o=
f
> an extent can result in super block modification also. If the goal is=
 to
> use ext4_writepages_trans_blocks everywhere then this change is corre=
ct.
> But i see  many place not using ext4_writepages_trans_blocks.
>=20
ext4_writepages_trans_blocks() will take care of the credits need for
updating superblock, for just once.ext4_ext_calc_credits_for_insert()
calculate the credits needed for inserting a single extent, You could
see in ext4_writepages_trans_blocks(), it will multiple it will the
total numberof blocks. If we account for superblock credit in
ext4_ext_calc_credits_for_insert(),  then super block updates for
multiple extents allocation will be overaccounted, and have to remove
that later in ext4_writepages_trans_blocks()

Other places calling  ext4_ext_calc_credits_for_insert() (mostly
migrate.c and defrag,c) are updated to add extra 4 credits, including
superblock, inode block and quota blocks.

> You also need to update the function comment saying that super block
> update is not accounted.Also it doesn't account for block bitmap,
> group descriptor and inode block update.
>=20

Credits for block bitmap and group descriptors are accounted in
ext4_ext_calc_credits_for_insert()

inode block update is only accounted once per writepages, so it's
accounted in
ext4_writepages_trans_blocks()/ext4_ext_writepages_trans_blocks()

> >  	return needed;
> >  }
> >=20
> > @@ -2940,8 +2938,8 @@ void ext4_ext_truncate(struct inode *ino
> >  	/*
> >  	 * probably first extent we're gonna free will be last in block
> >  	 */
> > -	err =3D ext4_writepage_trans_blocks(inode) + 3;
> > -	handle =3D ext4_journal_start(inode, err);
> > +	handle =3D ext4_journal_start(inode,
> > +				    ext4_writepages_trans_blocks(inode, 1) + 3);
>=20
>=20
> What is +3 for ? Can you add a comment on that.  I understand that it
> was there before. I guess +3 is not needed.?
>=20
 I guess it was there for superblock +inode block + quota block, but
actually superblock and inode block and quota blocks are already
accounted, it probably could be removed.=20
I did not pay a lot attention  to it, I guess  a little overbooking
probably safer, I could remove it if you feel strong about it.

>=20
>=20
> >  	if (IS_ERR(handle))
> >  		return;
> >=20
> > @@ -2994,18 +2992,28 @@ out_stop:
> >  }
> >=20
> >  /*
> > - * ext4_ext_writepage_trans_blocks:
> > + * ext4_ext_writepages_trans_blocks:
> >   * calculate max number of blocks we could modify
> >   * in order to allocate new block for an inode
> >   */
> > -int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
> > +int ext4_ext_writepages_trans_blocks(struct inode *inode, int num)
> >  {
>=20
> I guess the name is misleading. @num above is number of blocks. how
> about ext4_ext_writeblocks_trans(struct inode *node, int nrblocks)
>=20
>=20

> Also add a comment stating we consider the worst case where each bloc=
k
> can result in an extent.
>=20

I will add a comment about the worse case,  and change num to nrblocks.

> >  	int needed;
> >=20
> > +	/* cost of adding a single extent:
> > +	 * index blocks, leafs, bitmaps,
> > +	 * groupdescp
> > +	 */
> >  	needed =3D ext4_ext_calc_credits_for_insert(inode, NULL);
> >=20
> > -	/* caller wants to allocate num blocks, but note it includes sb *=
/
> > -	needed =3D needed * num - (num - 1);
> > +	/*
> > +	 * For data=3Djournalled mode need to account for the data blocks
> > +	 * Also need to add super block and inode block
> > +	 */
> > +	if (ext4_should_journal_data(inode))
> > +		needed =3D num * (needed + 1)  + 2;
> > +	else
> > +		needed =3D num * needed  + 2;
> >=20
>=20
>=20
> We are not accounting here for the bitmap and group descriptor.
> ext4_ext_calc_credits_for_insert is not accounting for the credit nee=
d
> to update bitmap and group descriptor.


>  We also need to account updating
> bitmap and group descriptor for new blocks that would be allocated
> as a part of extent insert.
>=20
>=20

No need for that. It's being accounted in
ext4_ext_calc_credits_for_insert(). In the worse case the tree depth is
5, inserting a extent would require a 2 updates (bitmap and group
descriptor) for each level (including the leaf, the new blocks), for ol=
d
tree and new tree.

/*
         * Index split can happen, we would need:
         *    allocate intermediate indexes (bitmap + group)
         *  + change two blocks at each level, but root (already
included)
         */
        needed +=3D (depth * 2) + (depth * 2);



> >  #ifdef CONFIG_QUOTA
> >  	needed +=3D 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> > @@ -3074,10 +3082,9 @@ long ext4_fallocate(struct inode *inode,
> >  	max_blocks =3D (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbit=
s)
> >  							- block;
> >  	/*
> > -	 * credits to insert 1 extent into extent tree + buffers to be ab=
le to
> > -	 * modify 1 super block, 1 block bitmap and 1 group descriptor.
> > +	 * credits to insert 1 extent into extent tree
> >  	 */
> > -	credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb) + 3;
> > +	credits =3D  EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
>=20
>=20
>=20
> Why is this change ?

 modify for block bitmap and  group descriptor  is included in
EXT4_DATA_TRANS_BLOCKS(inode->i_sb)-> (EXT4_SINGLEDATA_TRANS_BLOCKS(sb)=
=20

/* Define the number of blocks we need to account to a transaction to
 * modify one block of data.
 *
 * We may have to touch one inode, one bitmap buffer, up to three
 * indirection blocks, the group and superblock summaries, and the data
 * block to complete the transaction.
 *
 * For extents-enabled fs we may have to allocate and modify up to
 * 5 levels of tree + root which are stored in the inode. */

#define EXT4_SINGLEDATA_TRANS_BLOCKS(sb)
\
        (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)
\
                || test_opt(sb, EXTENTS) ? 27U : 8U)



others including superblock, inode block, quota and xattr blocks are
also included in=20


/* Define the minimum size for a transaction which modifies data.  This
 * needs to take into account the fact that we may end up modifying two
 * quota files too (one for the group, one for the user quota).  The
 * superblock only gets updated once, of course, so don't bother
 * counting that again for the quota updates. */

#define EXT4_DATA_TRANS_BLOCKS(sb)
(EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + \
                                         EXT4_XATTR_TRANS_BLOCKS - 2 + =
\
                                         2*EXT4_QUOTA_TRANS_BLOCKS(sb))


>=20
> >  	mutex_lock(&inode->i_mutex);
> >  retry:
> >  	while (ret >=3D 0 && ret < max_blocks) {
> > Index: linux-2.6.26-git6/fs/ext4/inode.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.26-git6.orig/fs/ext4/inode.c	2008-07-21 17:35:17.0000=
00000 -0700
> > +++ linux-2.6.26-git6/fs/ext4/inode.c	2008-07-21 17:44:45.000000000=
 -0700
> > @@ -1015,15 +1015,6 @@ static void ext4_da_update_reserve_space
> >=20
> >  /* Maximum number of blocks we map for direct IO at once. */
> >  #define DIO_MAX_BLOCKS 4096
> > -/*
> > - * Number of credits we need for writing DIO_MAX_BLOCKS:
> > - * We need sb + group descriptor + bitmap + inode -> 4
> > - * For B blocks with A block pointers per block we need:
> > - * 1 (triple ind.) + (B/A/A + 2) (doubly ind.) + (B/A + 2) (indire=
ct).
> > - * If we plug in 4096 for B and 256 for A (for 1KB block size), we=
 get 25.
> > - */
> > -#define DIO_CREDITS 25
> > -
> >=20
> >  /*
> >   *
> > @@ -1142,13 +1133,13 @@ int ext4_get_block(struct inode *inode,=20
> >  	handle_t *handle =3D ext4_journal_current_handle();
> >  	int ret =3D 0, started =3D 0;
> >  	unsigned max_blocks =3D bh_result->b_size >> inode->i_blkbits;
> > +	int dio_credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
>=20
> Again this should be
> 	int dio_credits =3D ext4_writeblocks_trans(inode, DIO_MAX_BLOCKS);
>=20
No. DIO case is different than writepages(). When get_block() is called
from DIO path, the get_block()  is called in a loop, and the credit is
reserved inside the loop. Each time get_block(),will return a single
extent, so we should use   EXT4_DATA_TRANS_BLOCKS(inode->i_sb) which is
calculate a single chunk of allocation credits.

ext4_da_writepages() is different, we have to reserve the credits
outside the loop of calling get_block(), since the underlying
get_block() could be called multiple times, we need to worse case, so
ext4_writepages_trans_blocks() is called to handling the worse case.

> >=20
> >  	if (create && !handle) {
> >  		/* Direct IO write... */
> >  		if (max_blocks > DIO_MAX_BLOCKS)
> >  			max_blocks =3D DIO_MAX_BLOCKS;
> > -		handle =3D ext4_journal_start(inode, DIO_CREDITS +
> > -			      2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
> > +		handle =3D ext4_journal_start(inode, dio_credits);
> >  		if (IS_ERR(handle)) {
> >  			ret =3D PTR_ERR(handle);
> >  			goto out;
> > @@ -1327,7 +1318,7 @@ static int ext4_write_begin(struct file=20
> >  				struct page **pagep, void **fsdata)
> >  {
> >   	struct inode *inode =3D mapping->host;
> > -	int ret, needed_blocks =3D ext4_writepage_trans_blocks(inode);
> > +	int ret, needed_blocks =3D ext4_writepages_trans_blocks(inode, 1)=
;
> >  	handle_t *handle;
> >  	int retries =3D 0;
> >   	struct page *page;
> > @@ -2179,18 +2170,7 @@ static int ext4_da_writepage(struct page
> >  	return ret;
> >  }
> >=20
> > -/*
> > - * For now just follow the DIO way to estimate the max credits
> > - * needed to write out EXT4_MAX_WRITEBACK_PAGES.
> > - * todo: need to calculate the max credits need for
> > - * extent based files, currently the DIO credits is based on
> > - * indirect-blocks mapping way.
> > - *
> > - * Probably should have a generic way to calculate credits
> > - * for DIO, writepages, and truncate
> > - */
> >  #define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
> > -#define EXT4_MAX_WRITEBACK_CREDITS    DIO_CREDITS
> >=20
> >  static int ext4_da_writepages(struct address_space *mapping,
> >  				struct writeback_control *wbc)
> > @@ -2210,13 +2190,8 @@ static int ext4_da_writepages(struct add
> >  	if (!mapping->nrpages)
> >  		return 0;
> >=20
> > -	/*
> > -	 * Estimate the worse case needed credits to write out
> > -	 * EXT4_MAX_BUF_BLOCKS pages
> > -	 */
> > -	needed_blocks =3D EXT4_MAX_WRITEBACK_CREDITS;
> > -
> >  	to_write =3D wbc->nr_to_write;
> > +
> >  	if (!wbc->range_cyclic) {
> >  		/*
> >  		 * If range_cyclic is not set force range_cont
> > @@ -2227,6 +2202,20 @@ static int ext4_da_writepages(struct add
> >  	}
> >=20
> >  	while (!ret && to_write) {
> > +		/*
> > +		 * set the max dirty pages could be write at a time
> > +		 * to fit into the reserved transaction credits
> > +		 */
> > +		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
> > +			wbc->nr_to_write =3D EXT4_MAX_WRITEBACK_PAGES;
> > +
> > +		/*
> > +		 * Estimate the worse case needed credits to write out
> > +		 * to_write pages
> > +		 */
> > +		needed_blocks =3D ext4_writepages_trans_blocks(inode,
> > +							     wbc->nr_to_write);
> > +
> >  		/* start a new transaction*/
> >  		handle =3D ext4_journal_start(inode, needed_blocks);
> >  		if (IS_ERR(handle)) {
> > @@ -2246,12 +2235,6 @@ static int ext4_da_writepages(struct add
> >  			}
> >=20
> >  		}
> > -		/*
> > -		 * set the max dirty pages could be write at a time
> > -		 * to fit into the reserved transaction credits
> > -		 */
> > -		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
> > -			wbc->nr_to_write =3D EXT4_MAX_WRITEBACK_PAGES;
> >=20
> >  		to_write -=3D wbc->nr_to_write;
> >  		ret =3D mpage_da_writepages(mapping, wbc,
> > @@ -2612,7 +2595,8 @@ static int __ext4_journalled_writepage(s
> >  	 * references to buffers so we are safe */
> >  	unlock_page(page);
> >=20
> > -	handle =3D ext4_journal_start(inode, ext4_writepage_trans_blocks(=
inode));
> > +	handle =3D ext4_journal_start(inode,
> > +				    ext4_writepages_trans_blocks(inode, 1));
> >  	if (IS_ERR(handle)) {
> >  		ret =3D PTR_ERR(handle);
> >  		goto out;
> > @@ -4286,20 +4270,20 @@ int ext4_getattr(struct vfsmount *mnt, s
> >  /*
> >   * How many blocks doth make a writepage()?
> >   *
> > - * With N blocks per page, it may be:
> > - * N data blocks
> > + * With N blocks per page,  and P pages, it may be:
> > + * N*P data blocks
> >   * 2 indirect block
> >   * 2 dindirect
> >   * 1 tindirect
> > - * N+5 bitmap blocks (from the above)
> > - * N+5 group descriptor summary blocks
> > + * N*P+5 bitmap blocks (from the above)
> > + * N*P+5 group descriptor summary blocks
> >   * 1 inode block
> >   * 1 superblock.
> >   * 2 * EXT4_SINGLEDATA_TRANS_BLOCKS for the quote files
> >   *
> > - * 3 * (N + 5) + 2 + 2 * EXT4_SINGLEDATA_TRANS_BLOCKS
> > + * 3 * (N*P + 5) + 2 + 2 * EXT4_SINGLEDATA_TRANS_BLOCKS
> >   *
> > - * With ordered or writeback data it's the same, less the N data b=
locks.
> > + * With ordered or writeback data it's the same, less the N*P data=
 blocks.
> >   *
> >   * If the inode's direct blocks can hold an integral number of pag=
es then a
> >   * page cannot straddle two indirect blocks, and we can only touch=
 one indirect
> > @@ -4310,19 +4294,15 @@ int ext4_getattr(struct vfsmount *mnt, s
> >   * block and work out the exact number of indirects which are touc=
hed.  Pah.
> >   */
> >=20
> > -int ext4_writepage_trans_blocks(struct inode *inode)
> > +static int ext4_writepages_trans_blocks_old(struct inode *inode, i=
nt num)
> >  {
>=20
> a better name would be
>=20
> static int ext4_writeblocks_trans_old(struct inode *inode, int nrbloc=
ks)
>=20
>=20
>=20
> > -	int bpp =3D ext4_journal_blocks_per_page(inode);
> > -	int indirects =3D (EXT4_NDIR_BLOCKS % bpp) ? 5 : 3;
> > +	int indirects =3D (EXT4_NDIR_BLOCKS % num) ? 5 : 3;
> >  	int ret;
> >=20
> > -	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> > -		return ext4_ext_writepage_trans_blocks(inode, bpp);
> > -
> >  	if (ext4_should_journal_data(inode))
> > -		ret =3D 3 * (bpp + indirects) + 2;
> > +		ret =3D 3 * (num + indirects) + 2;
> >  	else
> > -		ret =3D 2 * (bpp + indirects) + 2;
> > +		ret =3D 2 * (num + indirects) + 2;
>=20
>=20
> With non journalled moded we should just decrease num. I guess the ab=
ove
> should be
> 	if (ext4_should_journal_data(inode))
> 		ret =3D 3 * (num + indirects) + 2;
> 	else
> 		ret =3D 3 * (num + indirects) + 2 - num;
>=20
>=20
>=20

Well, I think in the journalled mode we need to journal the content of
the indirect/double indirect blocks also, no?


Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
