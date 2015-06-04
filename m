From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [RFC/PATCH 8/8] fs/ext4/super.c: Use strreplace in ext4_fill_super
Date: Thu,  4 Jun 2015 11:37:15 +0200
Message-ID: <1433410636-26812-9-git-send-email-linux@rasmusvillemoes.dk>
References: <1433410636-26812-1-git-send-email-linux@rasmusvillemoes.dk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:33479 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbbFDJhf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2015 05:37:35 -0400
Received: by labpy14 with SMTP id py14so27669112lab.0
        for <linux-ext4@vger.kernel.org>; Thu, 04 Jun 2015 02:37:34 -0700 (PDT)
In-Reply-To: <1433410636-26812-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This makes a very large function a little smaller.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/ext4/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ca9d4a2fed41..5f3c43a66937 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3420,7 +3420,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long journal_devnum = 0;
 	unsigned long def_mount_opts;
 	struct inode *root;
-	char *cp;
 	const char *descr;
 	int ret = -ENOMEM;
 	int blocksize, clustersize;
@@ -3456,8 +3455,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #endif
 
 	/* Cleanup superblock name */
-	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
-		*cp = '!';
+	strreplace(sb->s_id, '/', '!');
 
 	/* -EINVAL is default */
 	ret = -EINVAL;
-- 
2.1.3

