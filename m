From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 07/19] ext3: replace inode uid,gid,mode init with helper v2
Date: Thu, 18 Feb 2010 10:02:48 +0300
Message-ID: <87ocjn9gbr.fsf_-_@openvz.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
	<1266432013-9241-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1266432013-9241-2-git-send-email-dmonakhov@openvz.org> (Dmitry
	Monakhov's message of "Wed, 17 Feb 2010 21:40:12 +0300")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=

changes from v1:
 update code style according to Andreas comments


--=-=-=
Content-Disposition: inline;
 filename=0007-ext3-replace-inode-uid-gid-mode-init-with-helper-v2.patch

>From bd7bd775d7c1f939797ddb5df61aa3c4f50ba7b0 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Thu, 18 Feb 2010 09:44:32 +0300
Subject: [PATCH 07/19] ext3: replace inode uid,gid,mode init with helper v2


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/ialloc.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index b399912..1a48294 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -538,16 +538,13 @@ got:
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
 
-	inode->i_uid = current_fsuid();
-	if (test_opt (sb, GRPID))
-		inode->i_gid = dir->i_gid;
-	else if (dir->i_mode & S_ISGID) {
+
+	if (test_opt(sb, GRPID)) {
+		inode->i_mode = mode;
+		inode->i_uid = current_fsuid();
 		inode->i_gid = dir->i_gid;
-		if (S_ISDIR(mode))
-			mode |= S_ISGID;
 	} else
-		inode->i_gid = current_fsgid();
-	inode->i_mode = mode;
+		inode_init_owner(inode, dir, mode);
 
 	inode->i_ino = ino;
 	/* This is the optimal IO size (for stat), not the fs block size */
-- 
1.6.6


--=-=-=--
