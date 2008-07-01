From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: delalloc filesystem corruption
Date: Tue, 01 Jul 2008 16:00:35 -0700
Message-ID: <1214953235.6940.37.camel@mingming-laptop>
References: <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
	 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
	 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
	 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
	 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
	 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
	 <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33282 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758331AbYGAXAq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jul 2008 19:00:46 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m61N0gMq017192
	for <linux-ext4@vger.kernel.org>; Tue, 1 Jul 2008 19:00:42 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m61N0aV7226146
	for <linux-ext4@vger.kernel.org>; Tue, 1 Jul 2008 19:00:36 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m61N0ZsT015622
	for <linux-ext4@vger.kernel.org>; Tue, 1 Jul 2008 19:00:36 -0400
In-Reply-To: <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Tue, 2008-07-01 at 10:54 +0000, Gary Hawco wrote:
> Ted,
> 
> Thanks for your quick reply.  With the newest rc8-based snapshots I am no
> longer getting segfaults, unless you wanted me to roll back to the
> rc6-based snapshots to reproduce the segfaults.
> 
> Per your latest request I disabled delalloc, and voila, no more data
> corruption! Then I enabled delalloc and disabled mballoc and file
> corruption to /lib/rc/init.d/nettree returned. So delalloc is the culprit.
> 
> I hope this will help figure this out.
> 

Could you try the following patch? It fixes the problem of update
on-disk size too early without block allocation, the problem is
introduced unintentionally by another bug fix patch added to the patch
queue yesterday.


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



> Thanks again,
> Gary
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

