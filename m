From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix mount messages when quota disabled
Date: Tue, 15 Apr 2008 15:52:02 +0200
Message-ID: <12082675223669-git-send-email-jack@suse.cz>
References: <120826752278-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52946 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759707AbYDONwE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2008 09:52:04 -0400
In-Reply-To: <120826752278-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When quota is disabled, we should not print 'journaled quota not supported'
when user tried to mount non-journaled quota. Also fix typo in the message.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 286acec..a30305a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1241,6 +1241,9 @@ clear_qf_name:
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
+			printk(KERN_ERR
+				"EXT4-fs: quota options not supported.\n");
+			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
 		case Opt_offusrjquota:
@@ -1248,7 +1251,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
 			printk(KERN_ERR
-				"EXT4-fs: journalled quota options not "
+				"EXT4-fs: journaled quota options not "
 				"supported.\n");
 			break;
 		case Opt_noquota:
-- 
1.5.2.4

