From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 10:07:37 -0700
Message-ID: <1219338457.6342.15.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
	 <20080821164531.GE6509@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:47352 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948AbYHURHy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 13:07:54 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7LH7q4Q004041
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 13:07:52 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7LH7dbG096592
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 11:07:40 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7LH7cHB013818
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 11:07:39 -0600
In-Reply-To: <20080821164531.GE6509@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-21=E5=9B=9B=E7=9A=84 22:15 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Wed, Aug 20, 2008 at 11:13:39AM +0530, Aneesh Kumar K.V wrote:
> > Hi,
> >=20
> > I am getting this even with the latest patch queue. The test progra=
m is
> > a modified fsstress with fallocate support.
> >=20
> > mpage_da_map_blocks block allocation failed for inode 377954 at log=
ical
> > offset 313 with max blocks 4 with error -28
> > mpage_da_map_blocks block allocation failed for inode 336367 at log=
ical
> > offset 74 with max blocks 9 with error -28
> > mpage_da_map_blocks block allocation failed for inode 345560 at log=
ical
> > offset 542 with max blocks 7 with error -28
> > This should not happen.!! Data will be lost
> > mpage_da_map_blocks block allocation failed for inode 355317 at log=
ical
> > offset 152 with max blocks 10 with error -28
> > This should not happen.!! Data will be lost
> > mpage_da_map_blocks block allocation failed for inode 395261 at log=
ical
> > offset 462 with max blocks 1 with error -28
> > This should not happen.!! Data will be lost
> > mpage_da_map_blocks block allocation failed for inode 323784 at log=
ical
> > offset 313 with max blocks 11 with error -28
> > This should not happen.!! Data will be lost
> >=20
>=20
> With this patch i am not seeing error. It does the below
>=20
> a) use ext4_claim_free_blocks that also update the free blocks count
> b) Later after block allocation update the free blocks count if we
> allocated less with non-delayed mode
> c) Switch to non delay mode if we are low on free blocks.=20
>=20
I had sent a patch to do c) yesterday, I noticed that we can't switch t=
o
non delayed mode if the inode already have some delalloc dirty pages.


> @@ -2462,11 +2464,21 @@ static int ext4_da_write_begin(struct file *f=
ile, struct address_space *mapping,
>  	unsigned from, to;
>  	struct inode *inode =3D mapping->host;
>  	handle_t *handle;
> +	s64 free_blocks;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
>=20
>  	index =3D pos >> PAGE_CACHE_SHIFT;
>  	from =3D pos & (PAGE_CACHE_SIZE - 1);
>  	to =3D from + len;
>=20
> +	free_blocks =3D percpu_counter_read_positive(&sbi->s_freeblocks_cou=
nter);
> +	if (free_blocks < (4 * (FBC_BATCH * nr_cpu_ids))) {
> +		/* switch to non delalloc mode */
> +		*fsdata =3D (void *)1;
> +		return ext4_write_begin(file, mapping, pos,
> +					len, flags, pagep, fsdata);
> +	}
> +	*fsdata =3D (void *)0;

No, calling ext4_write_begin() directly won't work, as it start a
handle, do the block allocation , and leave the handle there.   It
expect later the write_end aops  to file the inode to the transaction
list, and close that handle.=20

With your change, the aops write_end still points to the
ext4_da_write_end(), which doesn't match the ext4_write_begin. We need
to switch the aop write_begin/write_end  function pointers all together=
=2E


I updated my patch, I have a few place I want to polish, since you are
looking at this , comments pls.


ext4: fall back to non delalloc mode if filesystem is almost full
=46rom: Mingming Cao <cmm@us.ibm.com>

In the case of filesystem is close to full (free blocks is below=20
the watermark FBC_BATCH * NRCPUS *4) and there is no delalloc dirty
pages in the page cache for the given inode, fall back to non delalloc
 mode for the inode to avoid possible later ENOSPC.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/ext4.h  |    2 -
 fs/ext4/inode.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++-=
---------
 fs/ext4/namei.c |    4 +-
 3 files changed, 65 insertions(+), 16 deletions(-)

Index: linux-2.6.27-rc3/fs/ext4/inode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc3.orig/fs/ext4/inode.c	2008-08-20 15:20:10.000000000=
 -0700
+++ linux-2.6.27-rc3/fs/ext4/inode.c	2008-08-20 17:59:20.000000000 -070=
0
@@ -2391,6 +2391,25 @@
 	return ret;
 }
=20
+/*
+ * In case of filesystem is almost full and delalloc could not
+ * get enough free blocks to reserve to prevent later ENOSPC,
+ * let's fall back to the nondelalloc mode
+ */
+static int ext4_fall_back_to_nondelalloc(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
+{
+	struct inode *inode =3D mapping->host;
+
+	/* turn off delalloc for this inode*/
+	ext4_set_aops(inode, 0);
+
+	return mapping->a_ops->write_begin(file, mapping, pos, len,
+					   flags, pagep, fsdata);
+}
+
 static int ext4_da_write_begin(struct file *file, struct address_space=
 *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -2402,6 +2421,15 @@
 	struct inode *inode =3D mapping->host;
 	handle_t *handle;
=20
+	/*
+	 * Fall back to nondelalloc mode if fs is about run out of free
+	 * blocks. We only do this if there is no delalloc dirty pages, those
+	 * dirty pages still need delalloc writepages aops to flush to disk.
+	 */
+	if (!ext4_has_delalloc_pages(inode) && ext4_free_blocks_low(inode))
+		ret=3D ext4_fall_back_to_nondelalloc(file,mapping,pos,
+						  len, flags, pagep,fsdata);
+
 	index =3D pos >> PAGE_CACHE_SHIFT;
 	from =3D pos & (PAGE_CACHE_SIZE - 1);
 	to =3D from + len;
@@ -2435,8 +2463,8 @@
 		page_cache_release(page);
 	}
=20
-	if (ret =3D=3D -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retri=
es))
-		goto retry;
+	if (ret =3D=3D -ENOSPC && (ext4_should_retry_alloc(inode->i_sb, &retr=
ies))
+			goto retry;
 out:
 	return ret;
 }
@@ -3008,16 +3036,37 @@
 	.is_partially_uptodate  =3D block_is_partially_uptodate,
 };
=20
-void ext4_set_aops(struct inode *inode)
+#define	EXT4_MIN_FREE_BLOCKS	(NR_CPUS * 4 * NR_CPUS*4)
+
+static int ext4_free_blocks_low(struct inode* inode)
+{
+	return (ext4_has_free_blocks(EXT4_SB(inode->i_sb),
+			 EXT4_MIN_FREE_BLOCKS) > EXT4_MIN_FREE_BLOCKS);
+}
+
+static int ext4_has_delalloc_pages(struct inode* inode)
+{
+	return EXT4_I(inode)->i_reserved_data_blocks;
+}
+
+void ext4_set_aops(struct inode *inode, int delalloc)
 {
-	if (ext4_should_order_data(inode) &&
-		test_opt(inode->i_sb, DELALLOC))
-		inode->i_mapping->a_ops =3D &ext4_da_aops;
-	else if (ext4_should_order_data(inode))
+	if (test_opt(inode->i_sb, DELALLOC)) {
+		if (delalloc && !ext4_has_delalloc_pages(inode)
+			&& ext4_free_blocks_low(inode))
+			delalloc =3D 0;
+
+		if (delalloc) {
+			inode->i_mapping->a_ops =3D &ext4_da_aops;
+			return;
+		} else
+			printk(KERN_INFO "filesystem is close to full, "
+				"delayed allocation is turned off for "
+				" inode %lu\n", inode->i_ino);
+	}
+
+	if (ext4_should_order_data(inode))
 		inode->i_mapping->a_ops =3D &ext4_ordered_aops;
-	else if (ext4_should_writeback_data(inode) &&
-		 test_opt(inode->i_sb, DELALLOC))
-		inode->i_mapping->a_ops =3D &ext4_da_aops;
 	else if (ext4_should_writeback_data(inode))
 		inode->i_mapping->a_ops =3D &ext4_writeback_aops;
 	else
@@ -4011,7 +4060,7 @@
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op =3D &ext4_file_inode_operations;
 		inode->i_fop =3D &ext4_file_operations;
-		ext4_set_aops(inode);
+		ext4_set_aops(inode, 1);
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op =3D &ext4_dir_inode_operations;
 		inode->i_fop =3D &ext4_dir_operations;
@@ -4020,7 +4069,7 @@
 			inode->i_op =3D &ext4_fast_symlink_inode_operations;
 		else {
 			inode->i_op =3D &ext4_symlink_inode_operations;
-			ext4_set_aops(inode);
+			ext4_set_aops(inode, 1);
 		}
 	} else {
 		inode->i_op =3D &ext4_special_inode_operations;
@@ -4783,7 +4832,7 @@
 		EXT4_I(inode)->i_flags |=3D EXT4_JOURNAL_DATA_FL;
 	else
 		EXT4_I(inode)->i_flags &=3D ~EXT4_JOURNAL_DATA_FL;
-	ext4_set_aops(inode);
+	ext4_set_aops(inode, 1);
=20
 	jbd2_journal_unlock_updates(journal);
=20
Index: linux-2.6.27-rc3/fs/ext4/ext4.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc3.orig/fs/ext4/ext4.h	2008-08-20 15:41:36.000000000 =
-0700
+++ linux-2.6.27-rc3/fs/ext4/ext4.h	2008-08-20 15:41:56.000000000 -0700
@@ -1070,7 +1070,7 @@
 extern void ext4_truncate (struct inode *);
 extern void ext4_set_inode_flags(struct inode *);
 extern void ext4_get_inode_flags(struct ext4_inode_info *);
-extern void ext4_set_aops(struct inode *inode);
+extern void ext4_set_aops(struct inode *inode, int delalloc);
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_meta_trans_blocks(struct inode *, int nrblocks, int id=
xblocks);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
Index: linux-2.6.27-rc3/fs/ext4/namei.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc3.orig/fs/ext4/namei.c	2008-08-20 15:42:13.000000000=
 -0700
+++ linux-2.6.27-rc3/fs/ext4/namei.c	2008-08-20 15:42:41.000000000 -070=
0
@@ -1738,7 +1738,7 @@
 	if (!IS_ERR(inode)) {
 		inode->i_op =3D &ext4_file_inode_operations;
 		inode->i_fop =3D &ext4_file_operations;
-		ext4_set_aops(inode);
+		ext4_set_aops(inode, 1);
 		err =3D ext4_add_nondir(handle, dentry, inode);
 	}
 	ext4_journal_stop(handle);
@@ -2210,7 +2210,7 @@
=20
 	if (l > sizeof (EXT4_I(inode)->i_data)) {
 		inode->i_op =3D &ext4_symlink_inode_operations;
-		ext4_set_aops(inode);
+		ext4_set_aops(inode, 1);
 		/*
 		 * page_symlink() calls into ext4_prepare/commit_write.
 		 * We have a transaction open.  All is sweetness.  It also sets


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
