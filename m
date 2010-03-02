From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 10/28] ext4: add missing error checking to ext4_expand_extra_isize_ea()
Date: Tue,  2 Mar 2010 13:18:27 -0500
Message-ID: <1267553925-6308-11-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Roel Kluin <roel.kluin@gmail.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43090 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab0CBSS7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:59 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ext4/xattr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 627c98a..efc16a4 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1300,6 +1300,8 @@ retry:
 
 		/* Remove the chosen entry from the inode */
 		error = ext4_xattr_ibody_set(handle, inode, &i, is);
+		if (error)
+			goto cleanup;
 
 		entry = IFIRST(header);
 		if (entry_size + EXT4_XATTR_SIZE(size) >= new_extra_isize)
-- 
1.6.6.1.1.g974db.dirty

