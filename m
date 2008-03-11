From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Fix the locking with respect to ext3 to ext4
	migrate.
Date: Tue, 11 Mar 2008 22:28:59 +0530
Message-ID: <20080311165859.GA6490@skywalker>
References: <1204887184-9902-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204888653.3627.37.camel@localhost.localdomain> <20080307113106.GA9896@skywalker> <20080307234751.GL1881@webber.adilger.int> <20080311152537.GE6544@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Mingming Cao <cmm@us.ibm.com>,
	tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:59256 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYCKQ7M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2008 12:59:12 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2BGwq2J004440
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 03:58:52 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2BGxAEw4575446
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 03:59:10 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2BGx9MD007646
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 03:59:10 +1100
Content-Disposition: inline
In-Reply-To: <20080311152537.GE6544@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2008 at 04:25:37PM +0100, Jan Kara wrote:
> > On Mar 07, 2008  17:01 +0530, Aneesh Kumar K.V wrote:
> > > On Fri, Mar 07, 2008 at 03:17:33AM -0800, Mingming Cao wrote:
> > > > How about we start a journal with estimated worse case transaction
> > > > credits  and then take the i_data_sem down? So that we could ensure that
> > > > whenever the i_data_sem is hold, the i_data is protected. That is what
> > > > currently DIO does, I think. It would be nice to avoid introducing
> > > > another semaphore to protect i_data for migration if we could.
> > > 
> > > Estimating transaction for a single page directIO write may be easy. But
> > > in case of migrate it involves new blocks allocated to carry the extents
> > > and also we free the indirect blocks of ext3 and that would involve
> > > update of bitmap from different groups. I am not sure we will be able to
> > > come up with a value. But if yes and if we can get that many credits
> > > from journal i agree that would be better than introducing a new
> > > semaphore.
> > 
> > Agreed - and if we have a generic routine to calculate the journal
> > credits needed for a full-file (or better a range) indirect block
> > operation (including bitmaps, group descriptors, and [dt]indirect
> > blocks).
> > 
> > I don't think there would be a serious failure case if it wasn't possible
> > to convert a block-mapped file to extent-mapped while it was mmapped.
> > At worst the administrator would need to do that some time later, or
> > after a system reboot, so long as the conversion actually failed if the
> > file had any mmaps.  If this same requirement is introduced when we
> > get defrag for ext4 (because the block mapping is changing on the file)
> > then we may have to reconsider the benefits of the more complex code.
>   I agree here. IMHO the better option would be to just build the
> extent-tree for converted inode on best-effort basis. If we find in
> the end that someone has allocated new block to the file (via mmap
> filling a hole) while we are converting, we can just cancel the
> conversion. Because I think the cost of extra rwsem (both in terms of
> additional memory needed for each inode structure and in time needed for
> rwsem acquisitions) is more than I as a user would like to bear given
> how rare the conversion is.
> 
Something like the below ??

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 059f2fc..a52904b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3502,9 +3502,5 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	 * access and zero out the page. The journal handle get initialized
 	 * in ext4_get_block.
 	 */
-	/* FIXME!! should we take inode->i_mutex ? Currently we can't because
-	 * it has a circular locking dependency with DIO. But migrate expect
-	 * i_mutex to ensure no i_data changes
-	 */
 	return block_page_mkwrite(vma, page, ext4_get_block);
 }
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5c1e27d..c6391e9 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -327,7 +327,7 @@ static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
 }
 
 static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
-				struct inode *tmp_inode)
+				struct inode *tmp_inode, blkcnt_t total_blocks)
 {
 	int retval;
 	__le32	i_data[3];
@@ -350,6 +350,13 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	i_data[2] = ei->i_data[EXT4_TIND_BLOCK];
 
 	down_write(&EXT4_I(inode)->i_data_sem);
+	/* check for number of blocks */
+	if (total_blocks  != inode->i_blocks) {
+		retval = -EAGAIN;
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto err_out;
+
+	}
 	/*
 	 * We have the extent map build with the tmp inode.
 	 * Now copy the i_data across
@@ -445,6 +452,7 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	struct inode *tmp_inode = NULL;
 	struct list_blocks_struct lb;
 	unsigned long max_entries;
+	blkcnt_t total_blocks;
 
 	if (!test_opt(inode->i_sb, EXTENTS))
 		/*
@@ -508,6 +516,12 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	 * switch the inode format to prevent read.
 	 */
 	mutex_lock(&(inode->i_mutex));
+	/*
+	 * Even though we take i_mutex we can still cause block allocation
+	 * via mmap write to holes. If we have allocated new blocks we fail
+	 * migrate.
+	 */
+	total_blocks  = inode->i_blocks;
 	handle = ext4_journal_start(inode, 1);
 
 	ei = EXT4_I(inode);
@@ -561,7 +575,7 @@ err_out:
 		free_ext_block(handle, tmp_inode);
 	else
 		retval = ext4_ext_swap_inode_data(handle, inode,
-							tmp_inode);
+						tmp_inode, total_blocks);
 
 	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
 	if (ext4_journal_extend(handle, 1) != 0)
