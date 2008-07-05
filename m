From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 51/52] ext4: Don't allow nonextenst mount option for large filesystem
Date: Sat,  5 Jul 2008 13:36:17 -0400
Message-ID: <1215279378-30504-52-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
 <1215279378-30504-30-git-send-email-tytso@mit.edu>
 <1215279378-30504-31-git-send-email-tytso@mit.edu>
 <1215279378-30504-32-git-send-email-tytso@mit.edu>
 <1215279378-30504-33-git-send-email-tytso@mit.edu>
 <1215279378-30504-34-git-send-email-tytso@mit.edu>
 <1215279378-30504-35-git-send-email-tytso@mit.edu>
 <1215279378-30504-36-git-send-email-tytso@mit.edu>
 <1215279378-30504-37-git-send-email-tytso@mit.edu>
 <1215279378-30504-38-git-send-email-tytso@mit.edu>
 <1215279378-30504-39-git-send-email-tytso@mit.edu>
 <1215279378-30504-40-git-send-email-tytso@mit.edu>
 <1215279378-30504-41-git-send-email-tytso@mit.edu>
 <1215279378-30504-42-git-send-email-tytso@mit.edu>
 <1215279378-30504-43-git-send-email-tytso@mit.edu>
 <1215279378-30504-44-git-send-email-tytso@mit.edu>
 <1215279378-30504-45-git-send-email-tytso@mit.edu>
 <1215279378-30504-46-git-send-email-tytso@mit.edu>
 <1215279378-30504-47-git-send-email-tytso@mit.edu>
 <1215279378-30504-48-git-send-email-tytso@mit.edu>
 <1215279378-30504-49-git-send-email-tytso@mit.edu>
 <1215279378-30504-50-git-send-email-tytso@mit.edu>
 <1215279378-30504-51-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33071 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755696AbYGERgb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:31 -0400
In-Reply-To: <1215279378-30504-51-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The block mapped inode format can address only blocks within 2**32. This
causes a number of issues, the biggest of which is that the block
allocator needs to be taught that certain inodes can not utilize block
numbers > 2**32.  So until this is fixed, it is simplest to fail
mounting of file systems with more than 2**32 blocks if the -o noextents
option is given.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e104dd..2bf9cdd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1004,6 +1004,7 @@ static int parse_options (char *options, struct super_block *sb,
 	int qtype, qfmt;
 	char *qname;
 #endif
+	ext4_fsblk_t last_block;
 
 	if (!options)
 		return 1;
@@ -1326,6 +1327,20 @@ set_qf_format:
 			set_opt (sbi->s_mount_opt, EXTENTS);
 			break;
 		case Opt_noextents:
+			/*
+			 * When e2fsprogs support resizing an already existing
+			 * ext3 file system to greater than 2**32 we need to
+			 * add support to block allocator to handle growing
+			 * already existing block  mapped inode so that blocks
+			 * allocated for them fall within 2**32
+			 */
+			last_block = ext4_blocks_count(sbi->s_es) - 1;
+			if (last_block  > 0xffffffffULL) {
+				printk(KERN_ERR "EXT4-fs: Filesystem too "
+						"large to mount with "
+						"-o noextents options\n");
+				return 0;
+			}
 			clear_opt (sbi->s_mount_opt, EXTENTS);
 			break;
 		case Opt_i_version:
-- 
1.5.6.rc3.1.g36b7.dirty

