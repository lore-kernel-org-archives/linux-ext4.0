From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH, RFC] Ext3: Mount partition as read only if during orphan cleanup truncate fails to obtain journal handle.
Date: Wed, 24 Oct 2012 16:12:44 +0530
Message-ID: <1351075364-2886-1-git-send-email-ashish.sangwan2@gmail.com>
Cc: linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48775 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2JXKnP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 06:43:15 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so1129369pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2012 03:43:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During orphan cleanup while doing truncate, if we fail to obtain journal
handle, the inode for which truncate was called would not be removed from
both the on-disk and in-memory orphan lists as the call to ext3_orphan_del
would not be executed.

This would have following consequences:
a) As the inode is not removed from the on-disk list, truncate would be
called again for the same inode. Each call would add the inode to the
in-memory list. This operation would continue endlessly or until truncate
is succeed.

b) If somehow, after some iterations, truncate is succeed, ext3_orphan_del
will only remove the inode from in-memory list just 1 time. This will trigger
j_assert during put super.

This patch handles both the problems. If truncate fails, first in-memory
list is cleared and than the partition is mounted as read only.
Failure to obtain journal handle during mount may suggest that journal
device is corrupted.

Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/ext3/super.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index bd60e08..798cd6f 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1540,7 +1540,22 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 			jbd_debug(2, "truncating inode %lu to %Ld bytes\n",
 				  inode->i_ino, inode->i_size);
 			ext3_truncate(inode);
-			nr_truncates++;
+			if (list_empty(&EXT3_I(inode)->i_orphan)) {
+				nr_truncates++;
+			} else {
+				/* Remove inode from in-memory orphan list */
+				list_del_init(&EXT3_I(inode)->i_orphan);
+				ext3_msg(sb, KERN_ERR, "Truncate failed for "
+                                        "orphan  inode = %lu. Running e2fsck"
+                                        " is recommended", inode->i_ino);
+				if (!(s_flags & MS_RDONLY)) {
+					ext3_msg(sb, KERN_INFO, "FS would be"
+						" mounted as readonly");
+					s_flags |= MS_RDONLY;
+				}
+				break;
+			}
+
 		} else {
 			printk(KERN_DEBUG
 				"%s: deleting unreferenced inode %lu\n",
-- 
1.7.11.4

