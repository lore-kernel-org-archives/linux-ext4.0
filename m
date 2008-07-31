From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Thu, 31 Jul 2008 11:07:11 -0700
Message-ID: <1217527631.6317.6.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1217383118.27664.14.camel@mingming-laptop>
	 <1217417361.3373.15.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60158 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYGaSH2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2008 14:07:28 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6VI9nPM013655
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 14:09:49 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6VI7Fdn1011830
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 14:07:15 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6VI7DIY004998
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 12:07:15 -0600
In-Reply-To: <1217417361.3373.15.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-30=E4=B8=89=E7=9A=84 13:29 +0200=EF=BC=8CFr=C3=A9d=C3=
=A9ric Boh=C3=A9=E5=86=99=E9=81=93=EF=BC=9A=20
> While doing some perf test on flex bg, I tried to run bonnie++ on
> 2.6.27-rc1 + patch queue including your journal credit fix but I had =
a
> very similar crash. Here are the details, I hope this help :
>=20
> kernel 2.6.27-rc1
> patch queue snapshot :
> ext4-patch-queue-25fb9834f3814b3aa567c5af090fba688a86eea9
>=20
> With latest e2fsprogs :
> mkfs.ext4 -t ext4dev -b1024 -G256 /dev/sdb1 4G

Looks like a 1k blocksize ext4, I have tested 1k briefly it seems okay
for single test. I will try bonnie myself. The stack shows there isn't
enought credit to delete an file.  But the journal credit fix mostly fi=
x
the code path on writepages(), so it should not affact the unlink case.

Is this a regression with this patch or it's a existing issue that this
patch did not fix?

There is one bug Aneesh pointed out today, I will update the patch, but
I don't think this matters to this issue.

> mount -t ext4dev /dev/sdb1 /mnt/test
> bonnie++ -u root -s 2g:256 -r 1024 -n 200 -d /mnt/test/
>=20
> after a while, it ends up with :
>=20
> kernel BUG at fs/jbd2/transaction.c:984!
> invalid opcode: 0000 [#1] SMP=20
> Modules linked in: ext4dev jbd2 crc16 kvm_intel kvm megaraid_mbox
> megaraid_mm
>=20
> Pid: 13965, comm: bonnie++ Not tainted (2.6.27-rc1 #3)
> EIP: 0060:[<f8b186a6>] EFLAGS: 00010246 CPU: 4
> EIP is at jbd2_journal_dirty_metadata+0xc6/0xd0 [jbd2]
> EAX: 00000000 EBX: f0acc380 ECX: f0acc380 EDX: f0069f80
> ESI: f3964700 EDI: f5daa1b0 EBP: f6dd7e00 ESP: f5949ebc
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process bonnie++ (pid: 13965, ti=3Df5948000 task=3Df5404ba0
> task.ti=3Df5948000)
> Stack: f7cb0100 f5daa1b0 f0acc380 f8b8ca12 f8b7ef62 f7cb0000 f68a5d00
> f7cb0100=20
>        00000000 f7183e00 f5daa1b0 f8b6a06e 00000040 f8b736db f7cb2134
> f2c94238=20
>        0000000b 00000000 00008000 00000000 f0acc380 f7cb0000 f08b2ac0
> f2c942c8=20
> Call Trace:
>  [<f8b7ef62>] __ext4_journal_dirty_metadata+0x22/0x60 [ext4dev]
>  [<f8b6a06e>] ext4_free_inode+0x26e/0x2f0 [ext4dev]
>  [<f8b736db>] ext4_orphan_del+0xcb/0x180 [ext4dev]
>  [<f8b6fb3c>] ext4_delete_inode+0x11c/0x140 [ext4dev]
>  [<f8b6fa20>] ext4_delete_inode+0x0/0x140 [ext4dev]
>  [<c018fe6a>] generic_delete_inode+0x5a/0xc0
>  [<c018f4a4>] iput+0x44/0x50
>  [<c0186271>] do_unlinkat+0xd1/0x150
>  [<c017cdd6>] vfs_write+0x106/0x140
>  [<c02aa7b0>] tty_write+0x0/0x1e0
>  [<c017d2d1>] sys_write+0x41/0x70
>  [<c0102fc9>] sysenter_do_call+0x12/0x25
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Code: 55 2c 8d 76 00 74 aa 0f 0b eb fe 0f 0b eb fe 8d b6 00 00 00 00 =
0f
> 0b eb fe f6 43 02 20 0f 84 5d ff ff ff f3 90 eb f2 0f 0b eb fe <0f> 0=
b
> eb fe 8d b6 00 00 00 00 55 57 56 53 89 d3 83 ec 10 89 44=20
> EIP: [<f8b186a6>] jbd2_journal_dirty_metadata+0xc6/0xd0 [jbd2] SS:ESP
> 0068:f5949ebc
>=20
>=20
> Fred
>=20
>=20
>=20
> Le mardi 29 juillet 2008 =C3=A0 18:58 -0700, Mingming Cao a =C3=A9cri=
t :
> > Ext4: journal credits reservation fixes for DIO, fallocate and dela=
lloc writepages
> >=20
> > From: Mingming Cao <cmm@us.ibm.com>
> >=20
> > With delalloc, at writepages() time, we need to reserve enough cred=
its to start
> > a new handle, to allow possible multiple segment of block allocatio=
ns under a
> > single call mapge_da_writepages(), to fit metadata updates into the=
 single
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
> >=20
> > Changes since v2:
> >=20
> > 1) fix  writepages() inefficency issue. sync() will invoke writepag=
es()
> > twice( not sure exactly why), the second time all the pages are cle=
an so
> > it waste the cpu time to walk though all pages and find they are no=
t
> > dirty . But  it's simple to workaround by skip writepages() if ther=
e is
> > no dirty pages pointed by the mapping.
> >=20
> >=20
> > 2) extent based credit calculate is quit conservetive. It always us=
e the
> > max possible depth to estimate the needed credits to support extent
> > insert/tree split. In fact the depth info for each inode is quite e=
asy
> > to get, so we could use more accurate info to calculate
> >=20
> > 3) Limit the max number of pages that could  flush at once from
> > ext4_da_writepages(), so that the max possible transaction credits =
could
> > fit under the  allowed credits for starting a  new transaction.  Re=
duce
> > the number of pages to flush  if necesary.   Currently with 4K page=
 size
> > and 4K block size, with extent file, it's possible to flush about 1=
K
> > pages under a single transaction.
> >=20
> >=20
> > Verified with memory pressure case and umount case,
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/ext4/ext4.h         |    4 -
> >  fs/ext4/ext4_extents.h |    3 -
> >  fs/ext4/ext4_jbd2.h    |   10 ++++
> >  fs/ext4/extents.c      |   78 ++++++++++++++++++-------------
> >  fs/ext4/inode.c        |  120 ++++++++++++++++++++++++++----------=
-------------
> >  fs/ext4/migrate.c      |    6 +-
> >  6 files changed, 129 insertions(+), 92 deletions(-)
> >=20
> > Index: linux-2.6.26git6/fs/ext4/ext4.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.26git6.orig/fs/ext4/ext4.h	2008-07-28 22:47:22.000000=
000 -0700
> > +++ linux-2.6.26git6/fs/ext4/ext4.h	2008-07-29 17:40:40.000000000 -=
0700
> > @@ -1072,7 +1072,7 @@ extern void ext4_truncate (struct inode=20
> >  extern void ext4_set_inode_flags(struct inode *);
> >  extern void ext4_get_inode_flags(struct ext4_inode_info *);
> >  extern void ext4_set_aops(struct inode *inode);
> > -extern int ext4_writepage_trans_blocks(struct inode *);
> > +extern int ext4_writepages_trans_blocks(struct inode *, int nrpage=
s);
> >  extern int ext4_block_truncate_page(handle_t *handle,
> >  		struct address_space *mapping, loff_t from);
> >  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct pa=
ge *page);
> > @@ -1227,7 +1227,7 @@ extern const struct inode_operations ext
> > =20
> >  /* extents.c */
> >  extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
> > -extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
> > +extern int ext4_ext_writeblocks_trans_credits(struct inode *inode,=
 int);
> >  extern int ext4_ext_get_blocks(handle_t *handle, struct inode *ino=
de,
> >  			ext4_lblk_t iblock,
> >  			unsigned long max_blocks, struct buffer_head *bh_result,
> > Index: linux-2.6.26git6/fs/ext4/extents.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.26git6.orig/fs/ext4/extents.c	2008-07-28 22:53:20.000=
000000 -0700
> > +++ linux-2.6.26git6/fs/ext4/extents.c	2008-07-29 17:40:50.00000000=
0 -0700
> > @@ -1747,34 +1747,43 @@ static int ext4_ext_rm_idx(handle_t *han
> >  }
> > =20
> >  /*
> > - * ext4_ext_calc_credits_for_insert:
> > - * This routine returns max. credits that the extent tree can cons=
ume.
> > + * ext4_ext_calc_credits_for_single_extent:
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
> > + *
> > + * For inserting a single extent, in the worse case extent tree de=
pth is 5
> > + * for old tree and new tree, for every level we need to reserve
> > + * credits to log the bitmap and block group descriptors
> > + *
> > + * credit needed for the update of super block + inode block + quo=
ta files
> > + * are not included here. The caller of this function need to take=
 care of this.
> >   */
> > -int ext4_ext_calc_credits_for_insert(struct inode *inode,
> > +int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
> >  						struct ext4_ext_path *path)
> >  {
> >  	int depth, needed;
> > =20
> > +	depth =3D ext_depth(inode);
> > +
> >  	if (path) {
> >  		/* probably there is space in leaf? */
> > -		depth =3D ext_depth(inode);
> >  		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
> >  				< le16_to_cpu(path[depth].p_hdr->eh_max))
> > -			return 1;
> > +			/* 1 for block bitmap, 1 for group descriptor */
> > +			return 2;
> >  	}
> > =20
> > -	/*
> > -	 * given 32-bit logical block (4294967296 blocks), max. tree
> > -	 * can be 4 levels in depth -- 4 * 340^4 =3D=3D 53453440000.
> > -	 * Let's also add one more level for imbalance.
> > -	 */
> > -	depth =3D 5;
> > +	/* add one more level in case of tree increase when insert a exte=
nt */
> > +	depth +=3D 1;
> > =20
> > -	/* allocation of new data block(s) */
> > +	/*
> > +	 * bitmap blocks and group descriptor block for
> > + 	 * allocation of new extent
> > + 	 */
> >  	needed =3D 2;
> > =20
> >  	/*
> > @@ -1791,9 +1800,6 @@ int ext4_ext_calc_credits_for_insert(str
> >  	 */
> >  	needed +=3D (depth * 2) + (depth * 2);
> > =20
> > -	/* any allocation modifies superblock */
> > -	needed +=3D 1;
> > -
> >  	return needed;
> >  }
> > =20
> > @@ -1917,9 +1923,7 @@ ext4_ext_rm_leaf(handle_t *handle, struc
> >  			correct_index =3D 1;
> >  			credits +=3D (ext_depth(inode)) + 1;
> >  		}
> > -#ifdef CONFIG_QUOTA
> >  		credits +=3D 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> > -#endif
> > =20
> >  		err =3D ext4_ext_journal_restart(handle, credits);
> >  		if (err)
> > @@ -2801,8 +2805,8 @@ void ext4_ext_truncate(struct inode *ino
> >  	/*
> >  	 * probably first extent we're gonna free will be last in block
> >  	 */
> > -	err =3D ext4_writepage_trans_blocks(inode) + 3;
> > -	handle =3D ext4_journal_start(inode, err);
> > +	handle =3D ext4_journal_start(inode,
> > +				    ext4_writepages_trans_blocks(inode, 1) + 3);
> >  	if (IS_ERR(handle))
> >  		return;
> > =20
> > @@ -2855,22 +2859,32 @@ out_stop:
> >  }
> > =20
> >  /*
> > - * ext4_ext_writepage_trans_blocks:
> > + * ext4_ext_writeblocks_trans_credits:
> >   * calculate max number of blocks we could modify
> > - * in order to allocate new block for an inode
> > + * in order to allocate the required number of new blocks
> > + *
> > + * In the worse case, one block per extent.
> > + *
> >   */
> > -int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
> > +int  ext4_ext_writeblocks_trans_credits(struct inode *inode, int n=
rblocks)
> >  {
> >  	int needed;
> > =20
> > -	needed =3D ext4_ext_calc_credits_for_insert(inode, NULL);
> > -
> > -	/* caller wants to allocate num blocks, but note it includes sb *=
/
> > -	needed =3D needed * num - (num - 1);
> > +	/* cost of adding a single extent:
> > +	 * index blocks, leafs, bitmaps,
> > +	 * groupdescp
> > +	 */
> > +	needed =3D ext4_ext_calc_credits_for_single_extent(inode, NULL);
> > +	/*
> > +	 * For data=3Djournalled mode need to account for the data blocks
> > +	 * Also need to add super block and inode block
> > +	 */
> > +	if (ext4_should_journal_data(inode))
> > +		needed =3D nrblocks * (needed + 1)  + 2;
> > +	else
> > +		needed =3D nrblocks * needed  + 2;
> > =20
> > -#ifdef CONFIG_QUOTA
> >  	needed +=3D 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> > -#endif
> > =20
> >  	return needed;
> >  }
> > @@ -2935,10 +2949,9 @@ long ext4_fallocate(struct inode *inode,
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
> > +	credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> >  	mutex_lock(&inode->i_mutex);
> >  retry:
> >  	while (ret >=3D 0 && ret < max_blocks) {
> > Index: linux-2.6.26git6/fs/ext4/inode.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.26git6.orig/fs/ext4/inode.c	2008-07-28 22:53:21.00000=
0000 -0700
> > +++ linux-2.6.26git6/fs/ext4/inode.c	2008-07-29 17:45:43.000000000 =
-0700
> > @@ -1,5 +1,5 @@
> >  /*
> > - *  linux/fs/ext4/inode.c
> > + * linux/fs/ext4/inode.c
> >   *
> >   * Copyright (C) 1992, 1993, 1994, 1995
> >   * Remy Card (card@masi.ibp.fr)
> > @@ -954,15 +954,6 @@ out:
> > =20
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
> > =20
> >  /*
> >   *
> > @@ -1082,13 +1073,13 @@ static int ext4_get_block(struct inode *
> >  	handle_t *handle =3D ext4_journal_current_handle();
> >  	int ret =3D 0, started =3D 0;
> >  	unsigned max_blocks =3D bh_result->b_size >> inode->i_blkbits;
> > +	int dio_credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> > =20
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
> > @@ -1267,7 +1258,7 @@ static int ext4_write_begin(struct file=20
> >  				struct page **pagep, void **fsdata)
> >  {
> >   	struct inode *inode =3D mapping->host;
> > -	int ret, needed_blocks =3D ext4_writepage_trans_blocks(inode);
> > +	int ret, needed_blocks =3D ext4_writepages_trans_blocks(inode, 1)=
;
> >  	handle_t *handle;
> >  	int retries =3D 0;
> >   	struct page *page;
> > @@ -2153,20 +2144,6 @@ static int ext4_da_writepage(struct page
> > =20
> >  	return ret;
> >  }
> > -
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
> > -#define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
> > -#define EXT4_MAX_WRITEBACK_CREDITS    DIO_CREDITS
> > -
> >  static int ext4_da_writepages(struct address_space *mapping,
> >  				struct writeback_control *wbc)
> >  {
> > @@ -2176,22 +2153,24 @@ static int ext4_da_writepages(struct add
> >  	int ret =3D 0;
> >  	long to_write;
> >  	loff_t range_start =3D 0;
> > +	int blocks_per_page =3D PAGE_CACHE_SIZE >> inode->i_blkbits;
> > +	int max_credit_blocks =3D ext4_journal_max_transaction_buffers(in=
ode);
> > +	int need_credits_per_page =3D  ext4_writepages_trans_blocks(inode=
, 1);
> > +	int max_writeback_pages =3D (max_credit_blocks / blocks_per_page)=
 / need_credits_per_page;
> > =20
> >  	/*
> >  	 * No pages to write? This is mainly a kludge to avoid starting
> >  	 * a transaction for special inodes like journal inode on last ip=
ut()
> >  	 * because that could violate lock ordering on umount
> >  	 */
> > -	if (!mapping->nrpages)
> > +	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_D=
IRTY))
> >  		return 0;
> > =20
> > -	/*
> > -	 * Estimate the worse case needed credits to write out
> > -	 * EXT4_MAX_BUF_BLOCKS pages
> > -	 */
> > -	needed_blocks =3D EXT4_MAX_WRITEBACK_CREDITS;
> > +	if (wbc->nr_to_write > mapping->nrpages)
> > +		wbc->nr_to_write =3D mapping->nrpages;
> > =20
> >  	to_write =3D wbc->nr_to_write;
> > +
> >  	if (!wbc->range_cyclic) {
> >  		/*
> >  		 * If range_cyclic is not set force range_cont
> > @@ -2202,10 +2181,31 @@ static int ext4_da_writepages(struct add
> >  	}
> > =20
> >  	while (!ret && to_write) {
> > +		/*
> > +		 * set the max dirty pages could be write at a time
> > +		 * to fit into the reserved transaction credits
> > +		 */
> > +		if (wbc->nr_to_write > max_writeback_pages)
> > +			wbc->nr_to_write =3D max_writeback_pages;
> > +
> > +		/*
> > +		 * Estimate the worse case needed credits to write out
> > +		 * to_write pages
> > +		 */
> > +		needed_blocks =3D ext4_writepages_trans_blocks(inode,
> > +							     wbc->nr_to_write);
> > +		while (needed_blocks > max_credit_blocks) {
> > +			wbc->nr_to_write --;
> > +			needed_blocks =3D ext4_writepages_trans_blocks(inode,
> > +							     wbc->nr_to_write);
> > +		}
> >  		/* start a new transaction*/
> >  		handle =3D ext4_journal_start(inode, needed_blocks);
> >  		if (IS_ERR(handle)) {
> >  			ret =3D PTR_ERR(handle);
> > +			printk(KERN_EMERG "%s: Not enough credits to flush %ld pages\n"=
, __func__,
> > +				wbc->nr_to_write);
> > +			dump_stack();
> >  			goto out_writepages;
> >  		}
> >  		if (ext4_should_order_data(inode)) {
> > @@ -2221,12 +2221,6 @@ static int ext4_da_writepages(struct add
> >  			}
> > =20
> >  		}
> > -		/*
> > -		 * set the max dirty pages could be write at a time
> > -		 * to fit into the reserved transaction credits
> > -		 */
> > -		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
> > -			wbc->nr_to_write =3D EXT4_MAX_WRITEBACK_PAGES;
> > =20
> >  		to_write -=3D wbc->nr_to_write;
> >  		ret =3D mpage_da_writepages(mapping, wbc,
> > @@ -2587,7 +2581,8 @@ static int __ext4_journalled_writepage(s
> >  	 * references to buffers so we are safe */
> >  	unlock_page(page);
> > =20
> > -	handle =3D ext4_journal_start(inode, ext4_writepage_trans_blocks(=
inode));
> > +	handle =3D ext4_journal_start(inode,
> > +				    ext4_writepages_trans_blocks(inode, 1));
> >  	if (IS_ERR(handle)) {
> >  		ret =3D PTR_ERR(handle);
> >  		goto out;
> > @@ -4271,20 +4266,20 @@ int ext4_getattr(struct vfsmount *mnt, s
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
> > @@ -4295,30 +4290,49 @@ int ext4_getattr(struct vfsmount *mnt, s
> >   * block and work out the exact number of indirects which are touc=
hed.  Pah.
> >   */
> > =20
> > -int ext4_writepage_trans_blocks(struct inode *inode)
> > +static int ext4_writeblocks_trans_credits_old(struct inode *inode,=
 int nrblocks)
> >  {
> > -	int bpp =3D ext4_journal_blocks_per_page(inode);
> > -	int indirects =3D (EXT4_NDIR_BLOCKS % bpp) ? 5 : 3;
> > +	int indirects =3D (EXT4_NDIR_BLOCKS % nrblocks) ? 5 : 3;
> >  	int ret;
> > =20
> > -	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> > -		return ext4_ext_writepage_trans_blocks(inode, bpp);
> > -
> >  	if (ext4_should_journal_data(inode))
> > -		ret =3D 3 * (bpp + indirects) + 2;
> > +		ret =3D 3 * (nrblocks + indirects) + 2;
> >  	else
> > -		ret =3D 2 * (bpp + indirects) + 2;
> > +		ret =3D 2 * nrblocks + 3* indirects + 2;
> > =20
> > -#ifdef CONFIG_QUOTA
> >  	/* We know that structure was already allocated during DQUOT_INIT=
 so
> >  	 * we will be updating only the data blocks + inodes */
> >  	ret +=3D 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> > -#endif
> > =20
> >  	return ret;
> >  }
> > =20
> >  /*
> > + * Calulate the total number of credits to reserve to fit
> > + * the modification of @num pages into a single transaction
> > + *
> > + * This could be called via ext4_write_begin() or later
> > + * ext4_da_writepages() in delalyed allocation case.
> > + *
> > + * In both case it's possible that we could allocating multiple
> > + * chunks of blocks. We need to consider the worse case, when
> > + * one new block per extent.
> > + *
> > + * For Direct IO and fallocate, the journal credits reservation
> > + * is based on one single extent allocation, so they could use
> > + * EXT4_DATA_TRANS_BLOCKS to get the needed credit to log a single
> > + * chunk of allocation needs.
> > + */
> > +int ext4_writepages_trans_blocks(struct inode *inode, int nrpages)
> > +{
> > +	int bpp =3D ext4_journal_blocks_per_page(inode);
> > +	int nrblocks =3D nrpages * bpp;
> > +
> > +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> > +		return ext4_writeblocks_trans_credits_old(inode, nrblocks);
> > +	return ext4_ext_writeblocks_trans_credits(inode, nrblocks);
> > +}
> > +/*
> >   * The caller must have previously called ext4_reserve_inode_write=
().
> >   * Give this, we know that the caller already has write access to =
iloc->bh.
> >   */
> > Index: linux-2.6.26git6/fs/ext4/migrate.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.26git6.orig/fs/ext4/migrate.c	2008-07-13 14:51:29.000=
000000 -0700
> > +++ linux-2.6.26git6/fs/ext4/migrate.c	2008-07-28 22:53:21.00000000=
0 -0700
> > @@ -52,9 +52,11 @@ static int finish_range(handle_t *handle
> >  	 * Since we are doing this in loop we may accumalate extra
> >  	 * credit. But below we try to not accumalate too much
> >  	 * of them by restarting the journal.
> > +	 *
> > +	 * extra 4 credits for: 1 superblock, 1 inode block, 2 quotas
> >  	 */
> > -	needed =3D ext4_ext_calc_credits_for_insert(inode, path);
> > -
> > +	needed =3D ext4_ext_calc_credits_for_single_extent(inode, path) +=
 2
> > +		 + 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> >  	/*
> >  	 * Make sure the credit we accumalated is not really high
> >  	 */
> > Index: linux-2.6.26git6/fs/ext4/ext4_extents.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.26git6.orig/fs/ext4/ext4_extents.h	2008-07-28 22:47:2=
2.000000000 -0700
> > +++ linux-2.6.26git6/fs/ext4/ext4_extents.h	2008-07-28 22:55:40.000=
000000 -0700
> > @@ -216,7 +216,8 @@ extern int ext4_ext_calc_metadata_amount
> >  extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
> >  extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk=
_t);
> >  extern int ext4_extent_tree_init(handle_t *, struct inode *);
> > -extern int ext4_ext_calc_credits_for_insert(struct inode *, struct=
 ext4_ext_path *);
> > +extern int ext4_ext_calc_credits_for_single_extent(struct inode *i=
node,
> > +						   struct ext4_ext_path *path);
> >  extern int ext4_ext_try_to_merge(struct inode *inode,
> >  				 struct ext4_ext_path *path,
> >  				 struct ext4_extent *);
> > Index: linux-2.6.26git6/fs/ext4/ext4_jbd2.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.26git6.orig/fs/ext4/ext4_jbd2.h	2008-07-28 22:47:22.0=
00000000 -0700
> > +++ linux-2.6.26git6/fs/ext4/ext4_jbd2.h	2008-07-28 22:53:21.000000=
000 -0700
> > @@ -231,4 +231,14 @@ static inline int ext4_should_writeback_
> >  	return 0;
> >  }
> > =20
> > +static inline int ext4_journal_max_transaction_buffers(struct inod=
e *inode)
> > +{
> > +	/*
> > +	 * max transaction buffers
> > + 	 * calculation based on
> > + 	 * journal->j_max_transaction_buffers =3D journal->j_maxlen / 4;
> > + 	 */
> > +        return (EXT4_JOURNAL(inode))->j_maxlen / 4;
> > +}
> > +
> >  #endif	/* _EXT4_JBD2_H */
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
