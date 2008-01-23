From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: ext4-online-defrag-free-space-fragmentation.patch uses do_fsync()
Date: Wed, 23 Jan 2008 08:55:17 -0500
Message-ID: <E1JHg4T-0007lQ-8f@closure.thunk.org>
Cc: Mingming Cao <cmm@us.ibm.com>, Takashi Sato <t-sato@yk.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49587 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbYAWNzY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 08:55:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I was trying to build ext4 as a module, and ran into problems because
the online defrag patch is calling do_fsync() which is *not* an exported
symbol, and so can not be called from a module.

Looking at what the routine is doing, there's no reason to call
do_fsync(), and in fact depending on the journaling mode in use, it may
not force a journal commit, which seems to be the goal of the code.

Hence, I plan to merge the following fix into the the
defrag-free-space-fragmentation patch, unless there are any objections
from Takashi-San or Akira-San.

Regards,

						- Ted

diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index 4ef3dc0..19d2cfd 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -632,8 +632,9 @@ static int ext4_ext_defrag_victim(struct file *target_filp,
 		}
 
 		/* Sync journal blocks before reservation */
-		if (do_fsync(target_filp, 0)) {
-			printk(KERN_ERR "defrag: failed do_fsync\n");
+		ret = ext4_force_commit(sb);
+		if (ret) {
+			printk(KERN_ERR "defrag: failed do_fsync (%d)\n", ret);
 			goto ERR;
 		}
 	}
