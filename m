From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: lock i_mutex when truncating orphan inodes
Date: Thu, 27 Dec 2012 01:43:14 -0500
Message-ID: <1356590595-23144-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit c278531d39f3 added a warning when ext4_flush_unwritten_io() is
called without i_mutex being taken.  It had previously not been taken
during orphan cleanup since races weren't possible at that point in
the mount process, but as a result of this commit, we will now see a
kernel WARN_ON in this case.  Take the i_mutex in
ext4_orphan_cleanup() to suppress this warning.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 183ae34..3d4fb81 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2220,7 +2220,9 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 				__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
+			mutex_lock(&inode->i_mutex);
 			ext4_truncate(inode);
+			mutex_unlock(&inode->i_mutex);
 			nr_truncates++;
 		} else {
 			ext4_msg(sb, KERN_DEBUG,
-- 
1.7.12.rc0.22.gcdd159b
