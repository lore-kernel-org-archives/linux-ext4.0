From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH] ext2: do not register write_super within VFS
Date: Tue,  3 Apr 2012 12:49:18 +0300
Message-ID: <1333446558-28171-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49936 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab2DCJss (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Apr 2012 05:48:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Jan Kara removed 'sb->s_dirt' VFS flag references, so we do not need to
register the ext2 'ext2_write_super()' method in the VFS superblock operations,
because 'sb->s_dirt' won't be ever set to 1 and VFS won't ever call
'->write_super()' anyway. Thus, remove the method.

Tested using xfstests.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext2/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index a43f9ad..e0e8f45 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -302,7 +302,6 @@ static const struct super_operations ext2_sops = {
 	.write_inode	= ext2_write_inode,
 	.evict_inode	= ext2_evict_inode,
 	.put_super	= ext2_put_super,
-	.write_super	= ext2_write_super,
 	.sync_fs	= ext2_sync_fs,
 	.statfs		= ext2_statfs,
 	.remount_fs	= ext2_remount,
-- 
1.7.7.6

