From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] mke2fs: don't display bigalloc/quota fs feature warnings in quiet mode
Date: Sun, 31 Mar 2013 20:44:01 -0400
Message-ID: <1364777043-20610-3-git-send-email-tytso@mit.edu>
References: <CAN=xW0bhw41-NNqWnDfqk0SbM6xymrhuL9WONQKefC=PsHg5GQ@mail.gmail.com>
 <1364777043-20610-1-git-send-email-tytso@mit.edu>
Cc: john.jolly@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57589 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab3DAAoP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Mar 2013 20:44:15 -0400
In-Reply-To: <1364777043-20610-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index fe5ce7d..7448255 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1942,13 +1942,15 @@ profile_error:
 		exit(1);
 	}
 
-	if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+	if (!quiet &&
+	    (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC))
 		fprintf(stderr, _("\nWarning: the bigalloc feature is still "
 				  "under development\n"
 				  "See https://ext4.wiki.kernel.org/"
 				  "index.php/Bigalloc for more information\n\n"));
 
-	if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA)
+	if (!quiet &&
+	    (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
 		fprintf(stderr, _("\nWarning: the quota feature is still "
 				  "under development\n"
 				  "See https://ext4.wiki.kernel.org/"
-- 
1.7.12.rc0.22.gcdd159b

