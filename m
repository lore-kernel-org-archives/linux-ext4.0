From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix mount messages when quota disabled
Date: Tue, 15 Apr 2008 15:52:01 +0200
Message-ID: <120826752278-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52944 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759580AbYDONwE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2008 09:52:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When quota is disabled, we should not print 'journaled quota not supported'
when user tried to mount non-journaled quota. Also fix typo in the message.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 77e9702..58a3d96 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1096,6 +1096,9 @@ clear_qf_name:
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
+			printk(KERN_ERR
+				"EXT3-fs: quota options not supported.\n");
+			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
 		case Opt_offusrjquota:
@@ -1103,7 +1106,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
 			printk(KERN_ERR
-				"EXT3-fs: journalled quota options not "
+				"EXT3-fs: journaled quota options not "
 				"supported.\n");
 			break;
 		case Opt_noquota:
-- 
1.5.2.4

