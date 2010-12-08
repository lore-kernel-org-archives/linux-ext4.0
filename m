From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] ext4: ext4_ext_migrate should use NULL not 0
Date: Wed, 08 Dec 2010 14:16:10 -0500
Message-ID: <20101208191610.12168.28421.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, eparis@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab0LHTQg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Dec 2010 14:16:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_migrate() calls ext4_new_inode() and passes 0 instead of a pointer
to a struct qstr.  This patch uses NULL, to make it obvious to the caller
that this was a pointer.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/ext4/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 25f3a97..b0a126f 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -496,7 +496,7 @@ int ext4_ext_migrate(struct inode *inode)
 	goal = (((inode->i_ino - 1) / EXT4_INODES_PER_GROUP(inode->i_sb)) *
 		EXT4_INODES_PER_GROUP(inode->i_sb)) + 1;
 	tmp_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
-				   S_IFREG, 0, goal);
+				   S_IFREG, NULL, goal);
 	if (IS_ERR(tmp_inode)) {
 		retval = -ENOMEM;
 		ext4_journal_stop(handle);

