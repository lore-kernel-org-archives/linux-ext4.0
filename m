From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Don't reuse released data blocks untill transaction commits
Date: Thu,  9 Oct 2008 21:02:08 +0530
Message-ID: <1223566329-29434-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55723 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYJIPcW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 11:32:22 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m99FVILc029881
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 02:31:18 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m99FWKdv306606
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 02:32:20 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m99FWKlJ026768
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 02:32:20 +1100
In-Reply-To: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to make sure we don't reuse the data blocks released
during the transaction untill the transaction commits. We force
this mode only for ordered and journalled mode. Writeback mode
already don't provided data consistency.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index bd2ece2..b9821be 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -568,8 +568,16 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 
 	/* this isn't the right place to decide whether block is metadata
 	 * inode.c/extents.c knows better, but for safety ... */
-	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode) ||
-			ext4_should_journal_data(inode))
+	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
+		metadata = 1;
+
+	/* We need to make sure we don't reuse
+	 * block released untill the transaction commit.
+	 * writeback mode have weak data consistency so
+	 * don't force data as metadata when freeing block
+	 * for writeback mode.
+	 */
+	if (metadata == 0 && !ext4_should_writeback_data(inode))
 		metadata = 1;
 
 	sb = inode->i_sb;
-- 
1.6.0.1.285.g1070

