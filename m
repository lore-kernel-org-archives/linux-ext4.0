From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] ext3: Return proper error code on ext3_fill_super()
Date: Mon, 11 Oct 2010 19:08:06 +0900
Message-ID: <1286791686-2973-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46567 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab0JKKIQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Oct 2010 06:08:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 421fad7..75bbf77 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1871,6 +1871,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	if (sbi->s_group_desc == NULL) {
 		ext3_msg(sb, KERN_ERR,
 			"error: not enough memory");
+		ret = -ENOMEM;
 		goto failed_mount;
 	}
 
@@ -1958,6 +1959,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	}
 	if (err) {
 		ext3_msg(sb, KERN_ERR, "error: insufficient memory");
+		ret = err;
 		goto failed_mount3;
 	}
 
-- 
1.7.0.4

