From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] vfs: Move mark_inode_dirty() from under page lock in generic_write_end()
Date: Fri, 30 May 2008 19:09:26 +0530
Message-ID: <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:50335 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYE3NkJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 09:40:09 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4UDdZQM006209
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:39:35 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4UDiIRw166758
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:44:18 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4UDe7QJ024114
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:40:08 +1000
In-Reply-To: <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

There's no need to call mark_inode_dirty() under page lock in
generic_write_end(). It unnecessarily makes hold time of page lock longer
and more importantly it forces locking order of page lock and transaction
start for journaling filesystems.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/buffer.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a073f3f..24116f0 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2061,6 +2061,7 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 			struct page *page, void *fsdata)
 {
 	struct inode *inode = mapping->host;
+	int i_size_changed = 0;
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
@@ -2073,12 +2074,21 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 	 */
 	if (pos+copied > inode->i_size) {
 		i_size_write(inode, pos+copied);
-		mark_inode_dirty(inode);
+		i_size_changed = 1;
 	}
 
 	unlock_page(page);
 	page_cache_release(page);
 
+	/*
+	 * We don't mark inode dirty under page lock. First, it unnecessarily
+	 * makes the holding time of page lock longer. Second, it forces lock
+	 * ordering of page lock and transaction start for journaling
+	 * filesystems.
+	 */
+	if (i_size_changed)
+		mark_inode_dirty(inode);
+
 	return copied;
 }
 EXPORT_SYMBOL(generic_write_end);
-- 
1.5.5.1.357.g1af8b.dirty

