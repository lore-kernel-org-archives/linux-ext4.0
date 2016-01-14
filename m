From: Kamal Mostafa <kamal@canonical.com>
Subject: [4.2.y-ckt stable] Patch "ext2, ext4: warn when mounting with dax enabled" has been added to staging queue
Date: Thu, 14 Jan 2016 14:27:22 -0800
Message-ID: <1452810442-18951-1-git-send-email-kamal@canonical.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>,
	Kamal Mostafa <kamal@canonical.com>,
	kernel-team@lists.ubuntu.com
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48329 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbcANW1a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2016 17:27:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a note to let you know that I have just added a patch titled

    ext2, ext4: warn when mounting with dax enabled

to the linux-4.2.y-queue branch of the 4.2.y-ckt extended stable tree 
which can be found at:

    http://kernel.ubuntu.com/git/ubuntu/linux.git/log/?h=linux-4.2.y-queue

This patch is scheduled to be released in version 4.2.8-ckt2.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 4.2.y-ckt tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

---8<------------------------------------------------------------

>From 02435ed4921871c0fa6dd804ec16b82091d4ffc4 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Sep 2015 15:48:11 -0400
Subject: ext2, ext4: warn when mounting with dax enabled

commit ef83b6e8f40bb24b92ad73b5889732346e54a793 upstream.

Similar to XFS warn when mounting DAX while it is still considered under
development.  Also, aspects of the DAX implementation, for example
synchronization against multiple faults and faults causing block
allocation, depend on the correct implementation in the filesystem.  The
maturity of a given DAX implementation is filesystem specific.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ext4@vger.kernel.org
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Acked-by: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext2/super.c | 2 ++
 fs/ext4/super.c | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 900e19c..2597b06 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -566,6 +566,8 @@ static int parse_options(char *options, struct super_block *sb)
 			/* Fall through */
 		case Opt_dax:
 #ifdef CONFIG_FS_DAX
+			ext2_msg(sb, KERN_WARNING,
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 			set_opt(sbi->s_mount_opt, DAX);
 #else
 			ext2_msg(sb, KERN_INFO, "dax option not supported");
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bc24d1b..b22d844 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1667,8 +1667,12 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		}
 		sbi->s_jquota_fmt = m->mount_opt;
 #endif
-#ifndef CONFIG_FS_DAX
 	} else if (token == Opt_dax) {
+#ifdef CONFIG_FS_DAX
+		ext4_msg(sb, KERN_WARNING,
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
+			sbi->s_mount_opt |= m->mount_opt;
+#else
 		ext4_msg(sb, KERN_INFO, "dax option not supported");
 		return -1;
 #endif
--
1.9.1

