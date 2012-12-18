From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [RFC PATCH] ext3, ext4, ocfs2: remove unused macro NAMEI_RA_INDEX
Date: Tue, 18 Dec 2012 16:56:39 +0800
Message-ID: <1355820999-27972-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
	Mark Fasheh <mfasheh@suse.com>, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55641 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2LRI4u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Dec 2012 03:56:50 -0500
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Tue, 18 Dec 2012 18:53:33 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 22B552CE804F
	for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2012 19:56:45 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qBI8jfYu4391076
	for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2012 19:45:41 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qBI8ugXe024344
	for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2012 19:56:44 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This macro, initially introduced by ext2 in v0.99.15, does not
have any users from the beginning. It has been removed in later
ext2 version but still remains in the code of ext3, ext4, ocfs2.
Remove this macro there.

Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: linux-ext4@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext3/namei.c |    1 -
 fs/ext4/namei.c |    1 -
 fs/ocfs2/dir.c  |    1 -
 3 files changed, 3 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 890b894..88f64eb 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -36,7 +36,6 @@
 #define NAMEI_RA_CHUNKS  2
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
-#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
 static struct buffer_head *ext3_append(handle_t *handle,
 					struct inode *inode,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cac4482..3f8c3d4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -47,7 +47,6 @@
 #define NAMEI_RA_CHUNKS  2
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
-#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8fe4e28..fc12135 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -67,7 +67,6 @@
 #define NAMEI_RA_CHUNKS  2
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
-#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
 static unsigned char ocfs2_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
-- 
1.7.9.5

