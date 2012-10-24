From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH, RFC] Ext4: Mount partition as read only if during orphan cleanup truncate fails to obtain journal handle.
Date: Wed, 24 Oct 2012 16:10:40 +0530
Message-ID: <1351075240-2725-1-git-send-email-ashish.sangwan2@gmail.com>
Cc: linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:33800 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2JXKlZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 06:41:25 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so195266dak.19
        for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2012 03:41:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During orphan cleanup while doing truncate, if we fail to obtain journal
handle, the inode for which truncate was called would not be removed from
both the on-disk and in-memory orphan lists as the call to ext4_orphan_del
would not be executed.

This would have following consequences:
a) As the inode is not removed from the on-disk list, truncate would be 
called again for the same inode. Each call would add the inode to the
in-memory list. This operation would continue endlessly or until truncate
is succeed.

b) If somehow, after some iterations, truncate is succeed, ext4_orphan_del
will only remove the inode from in-memory list just 1 time. This will trigger
j_assert during put super.

This patch handles both the problems. If truncate fails, first in-memory
list is cleared and than the partition is mounted as read only.
Failure to obtain journal handle during mount may suggest that journal
device is corrupted.

Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com> 
---
 fs/ext4/super.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e2aacb..859eccb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2201,7 +2201,21 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
 			ext4_truncate(inode);
-			nr_truncates++;
+			if (list_empty(&EXT4_I(inode)->i_orphan)) {
+				nr_truncates++;
+			} else {
+				/* Remove inode from in-memory orphan list */
+				list_del_init(&EXT4_I(inode)->i_orphan);
+				ext4_msg(sb, KERN_ERR, "Truncate failed for "
+					 "orphan  inode = %lu. Running e2fsck"
+					 " is recommended", inode->i_ino);
+				if (!(s_flags & MS_RDONLY)) {
+					ext4_msg(sb, KERN_INFO, "FS would be"
+						" mounted as readonly");
+					s_flags |= MS_RDONLY;
+				}
+				break;
+			}
 		} else {
 			ext4_msg(sb, KERN_DEBUG,
 				"%s: deleting unreferenced inode %lu",
-- 
1.7.11.4

