From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] mke2fs: clarify inline data inode size error message
Date: Sat, 27 Sep 2014 11:55:15 -0400
Message-ID: <20140927155515.GA2322@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:41944 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaI0PzS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Sep 2014 11:55:18 -0400
Received: by mail-qc0-f178.google.com with SMTP id x13so7920679qcv.23
        for <linux-ext4@vger.kernel.org>; Sat, 27 Sep 2014 08:55:18 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The existing error message can be made more helpful by more clearly
implying the attempt to make a file system with undersized inodes is
failing and suggesting a corrective action.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 misc/mke2fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 2bc435b..00bb00d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2358,7 +2358,8 @@ profile_error:
 	     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
 	    fs_param.s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
 		com_err(program_name, 0,
-			_("inode size is %d, inline data is useless"),
+			_("%d byte inodes are too small for inline data; "
+			  "specify larger size"),
 			fs_param.s_inode_size);
 		exit(1);
 	}
-- 
1.9.1

