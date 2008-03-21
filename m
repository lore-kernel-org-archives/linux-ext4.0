From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] ext4:  Update i_diskzie during writepage for delayed allocation.
Date: Fri, 21 Mar 2008 11:48:56 +0530
Message-ID: <1206080337-8732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	Solofo.Ramangalahy@bull.net, dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58868 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbYCUGTH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Mar 2008 02:19:07 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2L6Ikph004393
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 17:18:46 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2L6J3Qr4644876
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 17:19:03 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2L6J23K028121
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 17:19:03 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to update i_disksize after allocating blocks. writepages
already does this. Update writepage to also  update i_disksize.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 79930df..50d700f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1488,6 +1488,44 @@ out:
 
 	return ret;
 }
+/* FIXME!! only support data=writeback mode */
+static int ext4_da_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	handle_t *handle = NULL;
+	int ret = 0;
+	int err;
+
+	if (ext4_journal_current_handle())
+		goto out_fail;
+
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_fail;
+	}
+
+	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
+		ret = nobh_writepage(page, ext4_get_block, wbc);
+	else
+		ret = block_write_full_page(page, ext4_get_block, wbc);
+
+	if (!ret && inode->i_size > EXT4_I(inode)->i_disksize) {
+		EXT4_I(inode)->i_disksize = inode->i_size;
+		ext4_mark_inode_dirty(handle, inode);
+	}
+
+	err = ext4_journal_stop(handle);
+	if (!ret)
+		ret = err;
+	return ret;
+
+out_fail:
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+	return ret;
+}
 
 static int ext4_da_writepages(struct address_space *mapping,
 				struct writeback_control *wbc)
@@ -2015,7 +2053,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 static const struct address_space_operations ext4_da_aops = {
 	.readpage	= ext4_readpage,
 	.readpages	= ext4_readpages,
-	.writepage	= ext4_writeback_writepage,
+	.writepage	= ext4_da_writepage,
 	.writepages	= ext4_da_writepages,
 	.sync_page	= block_sync_page,
 	.write_begin	= ext4_da_write_begin,
-- 
1.5.5.rc0.16.g02b00.dirty

