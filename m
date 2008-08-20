From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 16:22:15 -0700
Message-ID: <1219274535.7895.55.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
	 <20080820104644.GA11267@skywalker>  <20080820115331.GA9965@mit.edu>
	 <1219265808.7895.14.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:34655 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbYHTXWT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 19:22:19 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KNMGUL030255
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 19:22:16 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KNMG3D207682
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 17:22:16 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KNMFkm031467
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 17:22:16 -0600
In-Reply-To: <1219265808.7895.14.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 13:56 -0700=EF=BC=8CMingming Cao=
=E5=86=99=E9=81=93=EF=BC=9A
> =E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 07:53 -0400=EF=BC=8CTheodore T=
so=E5=86=99=E9=81=93=EF=BC=9A
> > On Wed, Aug 20, 2008 at 04:16:44PM +0530, Aneesh Kumar K.V wrote:
> > > > mpage_da_map_blocks block allocation failed for inode 323784 at=
 logical
> > > > offset 313 with max blocks 11 with error -28
> > > > This should not happen.!! Data will be lost
> >=20
> > We don't actually lose the data if free blocks are subsequently mad=
e
> > available, correct?
> >=20
> > > I tried this patch. There are still multiple ways we can get wron=
g free
> > > block count. The patch reduced the number of errors. So we are do=
ing
> > > better with patch. But I guess we can't use the percpu_counter ba=
sed
> > > free block accounting with delalloc. Without delalloc it is ok ev=
en if
> > > we find some wrong free blocks count . The actual block allocatio=
n will fail in
> > > that case and we handle it perfectly fine. With delalloc we canno=
t
> > > afford to fail the block allocation. Should we look at a free blo=
ck
> > > accounting rewrite using simple ext4_fsblk_t and and a spin lock =
?
> >=20
> > It would be a shame if we did given that the whole point of the per=
cpu
> > counter was to avoid a scalability bottleneck.  Perhaps we could ta=
ke
> > a filesystem-level spinlock only when the number of free blocks as
> > reported by the percpu_counter falls below some critical level?
> >=20
>=20
> Agree, and perhaps we should fall back to non-delalloc mode if the fs
> free blocks below some critical level?

How about this?

ext4: fall back to non delalloc mode if filesystem is almost full
=46rom: Mingming Cao <cmm@us.ibm.com>

In the case of filesystem is close to full (free blocks is below=20
the watermark NRCPUS *4) and there is not enough to reserve blocks for
delayed allocation, instead of return user back with ENOSPC error, with
this patch, it tries to fall back to non delayed allocation mode.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/ext4.h  |    2 -
 fs/ext4/inode.c |   61 ++++++++++++++++++++++++++++++++++++++++++++---=
---------
 fs/ext4/namei.c |    4 +--
 3 files changed, 51 insertions(+), 16 deletions(-)

Index: linux-2.6.27-rc3/fs/ext4/inode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc3.orig/fs/ext4/inode.c	2008-08-20 15:20:10.000000000=
 -0700
+++ linux-2.6.27-rc3/fs/ext4/inode.c	2008-08-20 16:13:48.000000000 -070=
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
+static int ext4_write_begin_nondelalloc(struct file *file,
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
@@ -2435,8 +2454,14 @@
 		page_cache_release(page);
 	}
=20
-	if (ret =3D=3D -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retri=
es))
-		goto retry;
+	if (ret =3D=3D -ENOSPC) {
+		if (ext4_should_retry_alloc(inode->i_sb, &retries))
+			goto retry;
+		else
+			ret=3D ext4_write_begin_nondelalloc(file,mapping,pos,
+							  len, flags, pagep,
+							  fsdata);
+	}
 out:
 	return ret;
 }
@@ -3008,16 +3033,26 @@
 	.is_partially_uptodate  =3D block_is_partially_uptodate,
 };
=20
-void ext4_set_aops(struct inode *inode)
+#define	EXT4_MIN_FREE_BLOCKS	(NR_CPUS*4)
+
+void ext4_set_aops(struct inode *inode, int delalloc)
 {
-	if (ext4_should_order_data(inode) &&
-		test_opt(inode->i_sb, DELALLOC))
-		inode->i_mapping->a_ops =3D &ext4_da_aops;
-	else if (ext4_should_order_data(inode))
+	if (test_opt(inode->i_sb, DELALLOC)) {
+		if (ext4_has_free_blocks(EXT4_SB(inode->i_sb),
+			 EXT4_MIN_FREE_BLOCKS) > EXT4_MIN_FREE_BLOCKS)
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
@@ -4011,7 +4046,7 @@
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op =3D &ext4_file_inode_operations;
 		inode->i_fop =3D &ext4_file_operations;
-		ext4_set_aops(inode);
+		ext4_set_aops(inode, 1);
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op =3D &ext4_dir_inode_operations;
 		inode->i_fop =3D &ext4_dir_operations;
@@ -4020,7 +4055,7 @@
 			inode->i_op =3D &ext4_fast_symlink_inode_operations;
 		else {
 			inode->i_op =3D &ext4_symlink_inode_operations;
-			ext4_set_aops(inode);
+			ext4_set_aops(inode, 1);
 		}
 	} else {
 		inode->i_op =3D &ext4_special_inode_operations;
@@ -4783,7 +4818,7 @@
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
