From: "Aneesh Kumar" <aneesh.kumar@gmail.com>
Subject: Re: Gentoo with ext4-patch-queue snapshots
Date: Thu, 3 Jul 2008 19:37:24 +0530
Message-ID: <cc723f590807030707j5ec31f0p5db26bf8529c61ef@mail.gmail.com>
References: <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
	 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
	 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
	 <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
	 <3.0.6.32.20080701175011.02437350@pop.west.cox.net>
	 <1215019194.6788.10.camel@mingming-laptop>
	 <1215030837.6788.37.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:58253 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYGCOH1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2008 10:07:27 -0400
Received: by yx-out-2324.google.com with SMTP id 8so248524yxm.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jul 2008 07:07:26 -0700 (PDT)
In-Reply-To: <1215030837.6788.37.camel@mingming-laptop>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[sending via gmail  ]

On Thu, Jul 03, 2008 at 05:03:25PM +0530, Aneesh Kumar K.V wrote:
> On Wed, Jul 02, 2008 at 10:19:54AM -0700, Mingming Cao wrote:
> >
> > On Tue, 2008-07-01 at 17:50 +0000, Gary Hawco wrote:
> > > Mingming,
> > >
> > > Can you post that patch somewhere for download? I access my email using
> > > Windows Vista, not in linux, so it would be very laborious to hand copy
> > > this patch and recreate it in linux.
> > >
> > Patch attached.
> >
> > > Updated the 2.6.26-rc8 kernel with the latest snapshot from today at
> > > 1833hrs GMT. All hell broke loose in Gentoo, The new kernel wouldn't allow
> > > the system to remount read/write on boot.  But it worked fine in Slackware.
> > > Gentoo with the experimental openrc-0.2.5 and baselayout2 apparently does
> > > not like ext4.
> > >
> >
>
> I think we need to protect i_disksize update with i_data_sem. Otherwise
> a parallel writepages and write_end can cause issues. I guess that is
> what Gary is finding. I also did some cleanup for the patch
>

better one moving ext4_truncate i_disksize update under i_data_sem.
ext4_ext_truncate is already doing this.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fcaafe4..05e9790 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1893,18 +1893,29 @@ static int ext4_da_write_begin(struct file
*file, struct address_space *mapping,
 /*
  * Check if we should update i_disksize
  * when write to the end of file but not require block allocation
+ * We check only the buffer head mapping the offset.
+ * ex: File with blocksize 1K page size 4K
+ * block 1 and 2 are holes, block 3 is mapped and half filled
+ * seek to block 1 and write ( marked the buffer delay )
+ * seek to block 3 and extent the end of file with end of file still
+ * falling within block 3. Here the writepages won't update the i_disksize
+ * properly because it allocate only block 1. So we need to update
+ * i_disksize in write_end checking only the offset
+ *
  */
-static int ext4_da_should_update_i_disksize(struct page *page,
-					 unsigned long offset)
+static int ext4_da_should_update_i_disksize(struct address_space *mapping,
+					struct page *page, unsigned long offset)
 {
-	struct buffer_head *bh;
-	unsigned int idx;
 	int i;
+	unsigned int idx;
+	struct buffer_head *bh;
+	struct inode *inode = mapping->host;
+	unsigned blocksize = inode->i_sb->s_blocksize;

 	bh = page_buffers(page);
-	idx = offset/bh->b_size;
+	idx = (offset + blocksize - 1)/blocksize;

-	for (i=0; i < idx; i++)
+	for (i = 1; i < idx; i++)
 		bh = bh->b_this_page;

 	if (!buffer_mapped(bh) || (buffer_delay(bh)))
@@ -1934,15 +1945,20 @@ static int ext4_da_write_end(struct file *file,

 	new_i_size = pos + copied;
 	if (new_i_size > EXT4_I(inode)->i_disksize)
-		if (ext4_da_should_update_i_disksize(page, end)) {
+		if (ext4_da_should_update_i_disksize(mapping, page, end)) {
 			/*
 			 * Updating i_disksize when extending file without
 			 * need block allocation
 			 */
-			if (ext4_should_order_data(inode))
-				ret = ext4_jbd2_file_inode(handle, inode);
+			down_write(&EXT4_I(inode)->i_data_sem);
+			if (new_i_size > EXT4_I(inode)->i_disksize) {
+				if (ext4_should_order_data(inode))
+					ret = ext4_jbd2_file_inode(handle,
+									inode);

-			EXT4_I(inode)->i_disksize = new_i_size;
+				EXT4_I(inode)->i_disksize = new_i_size;
+			}
+			up_write(&EXT4_I(inode)->i_data_sem);
 		}
 	ret2 = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
@@ -2987,6 +3003,11 @@ void ext4_truncate(struct inode *inode)
 	 */
 	if (ext4_orphan_add(handle, inode))
 		goto out_stop;
+	/*
+	 * From here we block out all ext4_get_block() callers who want to
+	 * modify the block allocation tree.
+	 */
+	down_write(&ei->i_data_sem);

 	/*
 	 * The orphan list entry will now protect us from any crash which
@@ -2997,12 +3018,6 @@ void ext4_truncate(struct inode *inode)
 	 */
 	ei->i_disksize = inode->i_size;

-	/*
-	 * From here we block out all ext4_get_block() callers who want to
-	 * modify the block allocation tree.
-	 */
-	down_write(&ei->i_data_sem);
