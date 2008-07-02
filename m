From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Gentoo with ext4-patch-queue snapshots
Date: Wed, 02 Jul 2008 13:33:57 -0700
Message-ID: <1215030837.6788.37.camel@mingming-laptop>
References: <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
	 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
	 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
	 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
	 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
	 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
	 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
	 <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
	 <3.0.6.32.20080701175011.02437350@pop.west.cox.net>
	 <1215019194.6788.10.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-2ifgtg/6zNDbF8gQjIqC"
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37364 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbYGBUd7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jul 2008 16:33:59 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m62KXwhE012039
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jul 2008 16:33:58 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m62KXwrK207450
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jul 2008 16:33:58 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m62KXvak030707
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jul 2008 16:33:58 -0400
In-Reply-To: <1215019194.6788.10.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-2ifgtg/6zNDbF8gQjIqC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 2008-07-02 at 10:19 -0700, Mingming Cao wrote:
> On Tue, 2008-07-01 at 17:50 +0000, Gary Hawco wrote:
> > Mingming,
> > 
> > Can you post that patch somewhere for download? I access my email using
> > Windows Vista, not in linux, so it would be very laborious to hand copy
> > this patch and recreate it in linux.
> > 
> Patch attached. 


Please use this patch instead, after discuss with Ted, I found an issue
with the patch I sent to the list. ext4 patch queue is also updated with
latest patch.

Ext4: fix delalloc i_disksize early update issue

From: Mingming Cao <cmm@us.ibm.com>

Ext4_da_write_end() uses ext4_bh_unmapped_or_delay() function to check
if it extend the file size without need for allocation. But at that time
the buffer has not being dirtied yet (done in code later in
block_commit_write()), so it always return true and update i_disksize
(before block allocation). we could fix that ext4_da_write_end() to not
use this helper function.

This also fixed another issue:
The i_disksize is updated at ext4_da_write_end() time if
writes to the end of file, and the buffers are all have
blocks allocated. But in the case blocksize < pagesize, and
if the page has, say, the first buffer marked
as buffer_delay, and the write is to EOF and on the third buffer, which
has block already allocated, we certainly need to extend the i_disksize.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc8/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc8.orig/fs/ext4/inode.c	2008-07-02 09:53:42.000000000 -0700
+++ linux-2.6.26-rc8/fs/ext4/inode.c	2008-07-02 13:22:52.000000000 -0700
@@ -1891,6 +1891,32 @@ out:
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
+		if (curr_off <= offset && offset < next_off)
+		   if (!buffer_mapped(bh) || (buffer_delay(bh)))
+			return 0;
+		   else
+			return 1;
+		curr_off = next_off;
+	} while ((bh = bh->b_this_page) != head);
+
+	return 1;
+}
+
 static int ext4_da_write_end(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
@@ -1900,6 +1926,10 @@ static int ext4_da_write_end(struct file
 	int ret = 0, ret2;
 	handle_t *handle = ext4_journal_current_handle();
 	loff_t new_i_size;
+	unsigned long start, end;
+
+	start = pos & (PAGE_CACHE_SIZE - 1);
+	end = start + copied;
 
 	/*
 	 * generic_write_end() will run mark_inode_dirty() if i_size
@@ -1909,8 +1939,7 @@ static int ext4_da_write_end(struct file
 
 	new_i_size = pos + copied;
 	if (new_i_size > EXT4_I(inode)->i_disksize)
-		if (!walk_page_buffers(NULL, page_buffers(page),
-				       0, len, NULL, ext4_bh_unmapped_or_delay)){
+		if (ext4_da_should_update_i_disksize(page, end)) {
 			/*
 			 * Updating i_disksize when extending file without
 			 * need block allocation


--=-2ifgtg/6zNDbF8gQjIqC
Content-Disposition: attachment; filename=delalloc_i_disksize_update-fix.patch
Content-Type: text/x-patch; name=delalloc_i_disksize_update-fix.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Ext4: fix delalloc i_disksize early update issue

From: Mingming Cao <cmm@us.ibm.com>

Ext4_da_write_end() uses ext4_bh_unmapped_or_delay() function to check
if it extend the file size without need for allocation. But at that time
the buffer has not being dirtied yet (done in code later in
block_commit_write()), so it always return true and update i_disksize
(before block allocation). we could fix that ext4_da_write_end() to not
use this helper function.

This also fixed another issue:
The i_disksize is updated at ext4_da_write_end() time if
writes to the end of file, and the buffers are all have
blocks allocated. But if the page had one buffer marked
as buffer_delay, and the write is at EOF and on a buffer has block
already allocated, we certainly need to extend the i_disksize.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc8/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc8.orig/fs/ext4/inode.c	2008-07-02 09:53:42.000000000 -0700
+++ linux-2.6.26-rc8/fs/ext4/inode.c	2008-07-02 13:22:52.000000000 -0700
@@ -1891,6 +1891,32 @@ out:
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
+		if (curr_off <= offset && offset < next_off)
+		   if (!buffer_mapped(bh) || (buffer_delay(bh)))
+			return 0;
+		   else
+			return 1;
+		curr_off = next_off;
+	} while ((bh = bh->b_this_page) != head);
+
+	return 1;
+}
+
 static int ext4_da_write_end(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
@@ -1900,6 +1926,10 @@ static int ext4_da_write_end(struct file
 	int ret = 0, ret2;
 	handle_t *handle = ext4_journal_current_handle();
 	loff_t new_i_size;
+	unsigned long start, end;
+
+	start = pos & (PAGE_CACHE_SIZE - 1);
+	end = start + copied;
 
 	/*
 	 * generic_write_end() will run mark_inode_dirty() if i_size
@@ -1909,8 +1939,7 @@ static int ext4_da_write_end(struct file
 
 	new_i_size = pos + copied;
 	if (new_i_size > EXT4_I(inode)->i_disksize)
-		if (!walk_page_buffers(NULL, page_buffers(page),
-				       0, len, NULL, ext4_bh_unmapped_or_delay)){
+		if (ext4_da_should_update_i_disksize(page, end)) {
 			/*
 			 * Updating i_disksize when extending file without
 			 * need block allocation

--=-2ifgtg/6zNDbF8gQjIqC--

