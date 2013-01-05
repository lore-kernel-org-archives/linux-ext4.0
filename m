From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ext4: report error if things go wrong when do checksum
Date: Sat,  5 Jan 2013 15:42:59 +0800
Message-ID: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35794 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3AEHnP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2013 02:43:15 -0500
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Sat, 5 Jan 2013 13:12:18 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id C633FE004E
	for <linux-ext4@vger.kernel.org>; Sat,  5 Jan 2013 13:13:14 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r057h3hp57016426
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jan 2013 13:13:04 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r057h4jV001761
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jan 2013 07:43:04 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_dx_csum_verify(), if we detect corrupted data,
we do not compare checksum because checksum itself may
be wrong, but we should report error in this case.

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cac4482..843e29f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -370,14 +370,14 @@ static int ext4_dx_csum_verify(struct inode *inode,
 	c = get_dx_countlimit(inode, dirent, &count_offset);
 	if (!c) {
 		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
-		return 1;
+		return 0;
 	}
 	limit = le16_to_cpu(c->limit);
 	count = le16_to_cpu(c->count);
 	if (count_offset + (limit * sizeof(struct dx_entry)) >
 	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
 		warn_no_space_for_csum(inode);
-		return 1;
+		return 0;
 	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
-- 
1.7.9.5

