From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC][PATCH 5/6] delalloc ENOSPC: release reservation for
	unlink/truncate
Date: Sun, 01 Jun 2008 16:36:17 -0700
Message-ID: <1212363377.4368.68.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36744 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbYFAXgb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jun 2008 19:36:31 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m51NaMfJ000789
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:36:22 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m51NaMCM161624
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:36:22 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m51NaMPJ027730
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:36:22 -0400
Received: from [9.67.174.55] (wecm-9-67-174-55.wecm.ibm.com [9.67.174.55])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m51NaLsi027710
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:36:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: delalloc block reservation unlink/truncate handling

From: Mingming cao <cmm@us.ibm.com>

Release reserved blocks for unlink/truncate/invalidate page

Signed-off-by: Mingming cao <cmm@us.ibm.com>

---
 fs/ext4/inode.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

Index: linux-2.6.26-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/inode.c	2008-06-01 15:04:14.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/inode.c	2008-06-01 15:04:21.000000000 -0700
@@ -1477,6 +1477,27 @@ void ext4_da_release_space(struct inode 
 	EXT4_I(inode)->i_reserved_meta_blocks -= mdb;
 }
 
+static void ext4_da_page_release_reservation(struct page *page,
+						unsigned long offset)
+{
+	int to_release = 0;
+	struct buffer_head *head, *bh;
+	unsigned int curr_off = 0;
+
+	head = page_buffers(page);
+	bh = head;
+	do {
+		unsigned int next_off = curr_off + bh->b_size;
+
+		if ((offset <= curr_off) && (buffer_delay(bh))) {
+			to_release++;
+			clear_buffer_delay(bh);
+		}
+		curr_off = next_off;
+	} while ((bh = bh->b_this_page) != head);
+	ext4_da_release_space(page->mapping->host, 0, to_release);
+}
+
 /*
  * this is a special callback for ->write_begin() only
  * it's intention is to return mapped block or reserve space
@@ -1737,9 +1758,6 @@ static int ext4_da_write_begin(struct fi
 
 static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
 {
-	struct buffer_head *head, *bh;
-	unsigned int curr_off = 0;
-
 	/*
 	 * Drop reserved blocks
 	 */
@@ -1747,21 +1765,7 @@ static void ext4_da_invalidatepage(struc
 	if (!page_has_buffers(page))
 		goto out;
 
-	head = page_buffers(page);
-	bh = head;
-	do {
-		unsigned int next_off = curr_off + bh->b_size;
