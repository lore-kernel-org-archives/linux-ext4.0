From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext4: remove comments about extent mount option in ext4_new_inode()
Date: Sun, 30 Oct 2011 10:55:12 +0800
Message-ID: <1319943312-5534-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40055 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352Ab1J3Czo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Oct 2011 22:55:44 -0400
Received: by qabj40 with SMTP id j40so4436091qab.19
        for <linux-ext4@vger.kernel.org>; Sat, 29 Oct 2011 19:55:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove comments about 'extent' mount option in ext4_new_inode(),
it's no longer existed.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext4/ialloc.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9c63f27..c25b9e5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1005,11 +1005,7 @@ got:
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
 
-	/*
-	 * Don't inherit extent flag from directory, amongst others. We set
-	 * extent flag on newly created directory and file only if -o extent
-	 * mount option is specified
-	 */
+	/* Don't inherit extent flag from directory, amongst others. */
 	ei->i_flags =
 		ext4_mask_flags(mode, EXT4_I(dir)->i_flags & EXT4_FL_INHERITED);
 	ei->i_file_acl = 0;
-- 
1.7.7.1

