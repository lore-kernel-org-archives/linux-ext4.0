From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] ext4: Move fs/ext4/namei.h into ext4.h
Date: Fri,  1 May 2009 14:59:28 -0400
Message-ID: <1241204369-2333-3-git-send-email-tytso@mit.edu>
References: <1241204369-2333-1-git-send-email-tytso@mit.edu>
 <1241204369-2333-2-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57343 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZEAS7c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2009 14:59:32 -0400
In-Reply-To: <1241204369-2333-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The fs/ext4/namei.h header file had only a single function
declaration, and should have never been a standalone file.  Move it
into ext4.h, where should have been from the beginning.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/namei.c |    1 -
 fs/ext4/namei.h |    8 --------
 fs/ext4/super.c |    1 -
 4 files changed, 1 insertions(+), 10 deletions(-)
 delete mode 100644 fs/ext4/namei.h

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3b7223d..13238dc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1595,6 +1595,7 @@ extern const struct file_operations ext4_file_operations;
 /* namei.c */
 extern const struct inode_operations ext4_dir_inode_operations;
 extern const struct inode_operations ext4_special_inode_operations;
+extern struct dentry *ext4_get_parent(struct dentry *child);
 
 /* symlink.c */
 extern const struct inode_operations ext4_symlink_inode_operations;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8018e49..c9690b2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -37,7 +37,6 @@
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
-#include "namei.h"
 #include "xattr.h"
 #include "acl.h"
 
diff --git a/fs/ext4/namei.h b/fs/ext4/namei.h
deleted file mode 100644
index 5e4dfff..0000000
--- a/fs/ext4/namei.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/*  linux/fs/ext4/namei.h
- *
- * Copyright (C) 2005 Simtec Electronics
- *	Ben Dooks <ben@simtec.co.uk>
- *
-*/
