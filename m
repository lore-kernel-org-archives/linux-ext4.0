From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: jbd2_handle and i_data_sem circular locking dependency detected
Date: Wed, 6 Feb 2008 01:36:37 +0530
Message-ID: <20080205200637.GA6490@skywalker>
References: <20080204101228.GA1939@skywalker> <20080204163156.GC3426@duck.suse.cz> <20080205122342.GC7038@skywalker> <20080205134228.GA25464@duck.suse.cz> <20080205162703.GD7038@skywalker> <20080205163404.GL25464@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:54189 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908AbYBEUGr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 15:06:47 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m15K712U024752
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 07:07:01 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m15KAMKi284010
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 07:10:22 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m15K6hWQ001834
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 07:06:44 +1100
Content-Disposition: inline
In-Reply-To: <20080205163404.GL25464@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 05, 2008 at 05:34:04PM +0100, Jan Kara wrote:
> On Tue 05-02-08 21:57:03, Aneesh Kumar K.V wrote:
> > 
> > I have a FIXME at migrate.c:524 documenting exactly that. The
> > difficult question was by how much we should extent the journal. ? But
> > in reality we might have accumulated enough journal credits, I never
> > really ran across a case where we are running out of the journal credit.
>   Yes, I don't think it is likely to happen in reality but if somebody
> would trigger this, it would be almost impossible to track down so one
> should be quite careful with these things...
>   And as I described, doing it failsafe is easy - just look how
> try_to_extend_transaction() in ext4/inode.c handles similar problems with
> truncate.
> 

I moved the indirect block freeing after i update the original inode.
That makes sure even if we fail to free the indirect blocks we have the
original inode converted. Now since i don't need atomicity with freeing of
blocks i extend the journal for each block freed. Below is the diff i have
right now.

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 1712844..1b00587 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -233,11 +233,14 @@ static int free_dind_blocks(handle_t *handle,
 
 	tmp_idata = (__le32 *)bh->b_data;
 	for (i = 0; i < max_entries; i++) {
-		if (tmp_idata[i])
+		if (tmp_idata[i]) {
+			extend_blkdelete_credit(handle, inode);
 			ext4_free_blocks(handle, inode,
 					le32_to_cpu(tmp_idata[i]), 1, 1);
+		}
 	}
 	put_bh(bh);
+	extend_blkdelete_credit(handle, inode);
 	ext4_free_blocks(handle, inode, le32_to_cpu(i_data), 1, 1);
 	return 0;
 }
@@ -266,29 +269,32 @@ static int free_tind_blocks(handle_t *handle,
 		}
 	}
 	put_bh(bh);
+	extend_blkdelete_credit(handle, inode);
 	ext4_free_blocks(handle, inode, le32_to_cpu(i_data), 1, 1);
 	return 0;
 }
 
-static int free_ind_block(handle_t *handle, struct inode *inode)
+static int free_ind_block(handle_t *handle, __le32 *i_data)
 {
 	int retval;
-	struct ext4_inode_info *ei = EXT4_I(inode);
 
-	if (ei->i_data[EXT4_IND_BLOCK])
+	/* ei->i_data[EXT4_IND_BLOCK] */
+	if (i_data[0]) {
+		extend_blkdelete_credit(handle, inode);
 		ext4_free_blocks(handle, inode,
-				le32_to_cpu(ei->i_data[EXT4_IND_BLOCK]), 1, 1);
+				le32_to_cpu(i_data[0]), 1, 1);
+	}
 
-	if (ei->i_data[EXT4_DIND_BLOCK]) {
-		retval = free_dind_blocks(handle, inode,
-						ei->i_data[EXT4_DIND_BLOCK]);
+	/* ei->i_data[EXT4_DIND_BLOCK] */
+	if (i_data[1]) {
+		retval = free_dind_blocks(handle, inode, i_data[1]);
 		if (retval)
 			return retval;
 	}
 
-	if (ei->i_data[EXT4_TIND_BLOCK]) {
-		retval = free_tind_blocks(handle, inode,
-						ei->i_data[EXT4_TIND_BLOCK]);
+	/* ei->i_data[EXT4_TIND_BLOCK] */
+	if (i_data[2]) {
+		retval = free_tind_blocks(handle, inode, i_data[2]);
 		if (retval)
 			return retval;
 	}
@@ -299,6 +305,7 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 				struct inode *tmp_inode)
 {
 	int retval;
+	__le32	i_data[3];
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_inode_info *tmp_ei = EXT4_I(tmp_inode);
 
@@ -313,11 +320,11 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 			goto err_out;
 	}
 
-	down_write(&EXT4_I(inode)->i_data_sem);
-	retval = free_ind_block(handle, inode);
-	if (retval)
-		goto err_out;
+	i_data[0] = ei->i_data[EXT4_IND_BLOCK];
+	i_data[1] = ei->i_data[EXT4_DIND_BLOCK];
+	i_data[2] = ei->i_data[EXT4_TIND_BLOCK];
 
+	down_write(&EXT4_I(inode)->i_data_sem);
 	/*
 	 * We have the extent map build with the tmp inode.
 	 * Now copy the i_data across
@@ -338,8 +345,12 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	inode->i_blocks += tmp_inode->i_blocks;
 	spin_unlock(&inode->i_lock);
 	up_write(&EXT4_I(inode)->i_data_sem);
-
 	ext4_mark_inode_dirty(handle, inode);
+
+	/* Now free the indirec block of the  inode */
+	retval = free_ind_block(handle, i_data);
+	if (retval)
+		goto err_out;
 err_out:
 	return retval;
 }
@@ -367,6 +378,7 @@ static int free_ext_idx(handle_t *handle, struct inode *inode,
 		}
 	}
 	put_bh(bh);
+	extend_blkdelete_credit(handle, inode);
 	ext4_free_blocks(handle, inode, block, 1, 1);
 	return retval;
 }
@@ -394,6 +406,25 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
 	return retval;
 
 }
+static int extend_blkdelete_credit(handle_t *handle, struct inode *inode)
+{
+	int retval, needed;
+
+	if (handle->h_buffer_credits > EXT4_RESERVE_TRANS_BLOCKS)
+		return 0;
+	/*
+	 * We are freeing a blocks. During this we touch
+	 * superblock, group descriptor and block bitmap.
+	 * So allocate a credit of 3. We may update
+	 * quota (user and group).
+	 */
+	needed = 3 + 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
+
+	if (ext4_journal_extend(handle, needed) != 0)
+		retval = ext4_journal_restart(handle, needed);
+
+	return retval;
+}
 
 int ext4_ext_migrate(struct inode *inode, struct file *filp,
 				unsigned int cmd, unsigned long arg)
@@ -514,19 +545,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	 */
 	retval = finish_range(handle, tmp_inode, &lb);
 err_out:
-	/*
-	 * We are either freeing extent information or indirect
-	 * blocks. During this we touch superblock, group descriptor
-	 * and block bitmap. Later we mark the tmp_inode dirty
-	 * via ext4_ext_tree_init. So allocate a credit of 4
-	 * We may update quota (user and group).
-	 *
-	 * FIXME!! we may be touching bitmaps in different block groups.
-	 */
-	if (ext4_journal_extend(handle,
-			4 + 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb)) != 0)
-		ext4_journal_restart(handle,
-				4 + 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
 	if (retval)
 		/*
 		 * Failure case delete the extent information with the
@@ -537,6 +555,10 @@ err_out:
 		retval = ext4_ext_swap_inode_data(handle, inode,
 							tmp_inode);
 
+	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
+	if (ext4_journal_extend(handle, 1) != 0)
+		ext4_journal_restart(handle, 1);
+
 	/*
 	 * Mark the tmp_inode as of size zero
 	 */
