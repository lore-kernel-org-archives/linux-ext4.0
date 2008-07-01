From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH updated] ext4: Handle page without buffers in
	ext4_*_writepage()
Date: Tue, 01 Jul 2008 15:56:12 -0700
Message-ID: <1214952972.6940.31.camel@mingming-laptop>
References: <1214820374-5464-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:44275 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbYGAW4P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2008 18:56:15 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m61MuE7P008886
	for <linux-ext4@vger.kernel.org>; Tue, 1 Jul 2008 18:56:14 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m61MuDNg166520
	for <linux-ext4@vger.kernel.org>; Tue, 1 Jul 2008 16:56:13 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m61MuCIK030270
	for <linux-ext4@vger.kernel.org>; Tue, 1 Jul 2008 16:56:13 -0600
In-Reply-To: <1214820374-5464-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mon, 2008-06-30 at 15:36 +0530, Aneesh Kumar K.V wrote:
> From: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
> 
> It can happen that buffers are removed from the page before it gets
> marked dirty and then is passed to writepage(). In writepage()
> we just initialize the buffers and check whether they are mapped and non
> delay. If they are mapped and non delay we write the page. Otherwise we
> mark then dirty. With this change we don't do block allocation at all in
> ext4_*_write_page.
> 
> writepage() get called under many condition and with a locking order
> of journal_start -> lock_page we shouldnot try to allocate blocks in
> writepage() which get called after taking page lock. writepage can get
> called via shrink_page_list even with a journal handle which was created
> for doing inode update. For example when doing ext4_da_write_begin we
> create a journal handle with credit 1 expecting a i_disksize update for
> the inode. But ext4_da_write_begin can cause shrink_page_list via
> _grab_page_cache. So having a valid handle via ext4_journal_current_handle
> is not a guarantee that we can use the handle for block allocation in
> writepage. We should not be using credits which are taken for other updates.
> That would result in we running out of credits when we update inodes.
> 
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |  169 ++++++++++++++++++++++++++++++++++++++++---------------
>  1 files changed, 124 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cd5c165..18af94a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1591,11 +1591,15 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
>  	handle_t *handle = NULL;
> 
>  	handle = ext4_journal_current_handle();
> -	BUG_ON(handle == NULL);
> -	BUG_ON(create == 0);
> -
> -	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
> +	if (!handle) {
> +		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
> +				   bh_result, 0, 0, 0);
> +		BUG_ON(!ret);
> +	} else {
> +		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
>  				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
> +	}
> +
>  	if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
> 
> @@ -1633,15 +1637,37 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
> 
>  static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
>  {
> -	return !buffer_mapped(bh) || buffer_delay(bh);
> +	/*
> +	 * unmapped buffer is possible for holes.
> +	 * delay buffer is possible with delayed allocation
> +	 */
> +	return ((!buffer_mapped(bh) || buffer_delay(bh)) && buffer_dirty(bh));
> +}
> +

Could you clarify why we need to add buffer_dirty check here. the
comment about "unmapped buffer is possible for holes" seems trying to
clarifying that, but it doesn't help me much:)


But the problem of above change, which adding buffer_dirty(bh) check
here, will cause i_disksize updated too earliy in ext4_da_write_end(), 

Ext4_da_write_end() uses ext4_bh_unmapped_or_delay() function to check
if it extend the file size without need for allocation. But at that time
the buffer has not being dirtied yet (done in code later in
block_commit_write()), so it always return true and update i_disksize
(before block allocation). we could fix that ext4_da_write_end() to not
use this helper function, also there is another issue :

The i_disksize is updated at ext4_da_write_end() time if
writes to the end of file, and the buffers are all have
blocks allocated. But if the page had one buffer marked
as buffer_delay, and the write is at EOF and on a buffer has block
already allocated, we certainly need to extend the i_disksize.

patch below...

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc8/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc8.orig/fs/ext4/inode.c	2008-07-01 15:13:00.000000000 -0700
+++ linux-2.6.26-rc8/fs/ext4/inode.c	2008-07-01 15:34:19.000000000 -0700
@@ -1892,6 +1892,31 @@ out:
 	return ret;
 }
 
+/*
+ * Check if we should update i_disksize
+ * when write to the end of file but not require block allocation
+ */
+static int ext4_da_should_update_i_disksize(struct page *page,
+					 unsigned long offset)
+{
+	struct buffer_head *head, *bh;
+	unsigned int curr_off = 0;
+
+	head = page_buffers(page);
+	bh = head;
+	do {
+		unsigned int next_off = curr_off + bh->b_size;
+
+		if ((curr_off >= offset) &&
+		   (!buffer_mapped || (buffer_delay(bh))) {
+			return 0;
+		}
+		curr_off = next_off;
+	} while ((bh = bh->b_this_page) != head);
+
+	return 1;
+}
+
 static int ext4_da_write_end(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
@@ -1901,6 +1926,10 @@ static int ext4_da_write_end(struct file
 	int ret = 0, ret2;
 	handle_t *handle = ext4_journal_current_handle();
 	loff_t new_i_size;
+	unsigned long start, end;
+
+	start = pos & (PAGE_CACHE_SIZE - 1);
+	end = start + copied;
 
 	/*
 	 * generic_write_end() will run mark_inode_dirty() if i_size
@@ -1910,8 +1939,7 @@ static int ext4_da_write_end(struct file
 
 	new_i_size = pos + copied;
 	if (new_i_size > EXT4_I(inode)->i_disksize)
-		if (!walk_page_buffers(NULL, page_buffers(page),
-				       0, len, NULL, ext4_bh_unmapped_or_delay)){
+		if (ext4_da_should_update_i_disksize(page, end))
 			/*
 			 * Updating i_disksize when extending file without
 			 * need block allocation









