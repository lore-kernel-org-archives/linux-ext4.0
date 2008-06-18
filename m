From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix ext4_bmap to flush the data to the disk with delalloc
Date: Wed, 18 Jun 2008 23:22:11 +0530
Message-ID: <1213811531-23829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48776 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYFRRwW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jun 2008 13:52:22 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5IHq8K0011748
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 03:52:08 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5IHpvGq4616402
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 03:51:57 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5IHqI8f007346
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 03:52:18 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With delalloc we don't do block allocation in the write_begin/write_end.
So when using bmap we first need to flush data to the disk so that blocks
get allocated and then call generic_block_bmap.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7035621..cfeb869 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1833,6 +1833,17 @@ sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	journal_t *journal;
 	int err;
 
+	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
+			test_opt(inode->i_sb, DELALLOC)) {
+		/*
+		 * With delalloc we want to sync the file
+		 * so that we can make sure we allocate
+		 * blocks for file
+		 */
+		filemap_fdatawrite(mapping);
+		filemap_fdatawait(mapping);
+	}
+
 	if (EXT4_I(inode)->i_state & EXT4_STATE_JDATA) {
 		/*
 		 * This is a REALLY heavyweight approach, but the use of
-- 
1.5.6.rc2.15.g457bb.dirty

