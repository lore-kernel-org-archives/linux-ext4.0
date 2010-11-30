From: jiayingz@google.com (Jiaying Zhang)
Subject: [PATCH, RFC] Flush the i_completed_io_list during ext4_truncate
Date: Mon, 29 Nov 2010 17:22:28 -0800 (PST)
Message-ID: <20101130012228.2144B42716@ruihe.smo.corp.google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:7031 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab0K3BWa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 20:22:30 -0500
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id oAU1MTTl026244
	for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 17:22:29 -0800
Received: from ruihe.smo.corp.google.com (ruihe.smo.corp.google.com [172.29.60.109])
	by wpaz13.hot.corp.google.com with ESMTP id oAU1MSF4012748
	for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 17:22:28 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted first found the bug when running 2.6.36 kernel with dioread_nolock
mount option that xfstests #13 complained about wrong file size during fsck.
However, the bug exists in the older kernels as well although it is
somehow harder to trigger.

The problem is that ext4_end_io_work() can happen after we have truncated an
inode to a smaller size. Then when ext4_end_io_work() calls 
ext4_convert_unwritten_extents(), we may reallocate some blocks that have 
been truncated, so the inode size becomes inconsistent with the allocated
blocks. 

The following patch flushes the i_completed_io_list during truncate to reduce 
the risk that some pending end_io requests are executed later and convert 
already truncated blocks to initialized. 

Note that although the fix helps reduce the problem a lot there may still 
be a race window between vmtruncate() and ext4_end_io_work(). The fundamental
problem is that if vmtruncate() is called without either i_mutex or i_alloc_sem
held, it can race with an ongoing write request so that the io_end request is
processed later when the corresponding blocks have been truncated.

Ted and I have discussed the problem offline and we saw a few ways to fix
the race completely:

a) We guarantee that i_mutex lock and i_alloc_sem write lock are both hold 
whenever vmtruncate() is called. The i_mutex lock prevents any new write
requests from entering writeback and the i_alloc_sem prevents the race
from ext4_page_mkwrite(). Currently we hold both locks if vmtruncate()
is called from do_truncate(), which is probably the most common case.
However, there are places where we may call vmtruncate() without holding
either i_mutex or i_alloc_sem. I would like to ask for other people's
opinions on what locks are expected to be held before calling vmtruncate().
There seems a disagreement among the callers of that function.

b) We change the ext4 write path so that we change the extent tree to contain 
the newly allocated blocks and update i_size both at the same time --- when 
the write of the data blocks is completed.

c) We add some additional locking to synchronize vmtruncate() and 
ext4_end_io_work(). This approach may have performance implications so we
need to be careful.

All of the above proposals may require more substantial changes, so
we may consider to take the following patch as a bandaid.

ext4: Flush the i_completed_io_list during truncate to reduce the risk
that some pending end_io requests are executed later and convert already
truncated blocks to initialized.
    
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0554c48..5c50896 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3519,6 +3519,12 @@ void ext4_ext_truncate(struct inode *inode)
 	int err = 0;
 
 	/*
+	 * finish any pending end_io work so we won't run the risk of
+	 * converting any truncated blocks to initialized later
+	 */
+	flush_completed_IO(inode);
+
+	/*
 	 * probably first extent we're gonna free will be last in block
 	 */
 	err = ext4_writepage_trans_blocks(inode);
