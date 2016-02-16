From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4: Prevent panic for destroyed devices
Date: Tue, 16 Feb 2016 14:36:04 +0400
Message-ID: <1455618965-26699-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:41553 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbcBPKgW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2016 05:36:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some devices(nbd) can becomes unoperatable via kill_bdev
so its pagecache will be invalidated and all buffers becomes unmapped.
In that situation we will trigger BUGON on submit_bh.

#Testcase
mkdir  -p a/mnt
cd a
truncate -s 1G img
mkfs.ext4 -F img
qemu-nbd -c /dev/nbd0 img
mount /dev/nbd0 /mnt
cp -r /bin/ /mnt&
# Disconnect nbd while cp is active
qemu-nbd -d /dev/nbd0
sync

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ed01ec..617d8b4a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4320,7 +4320,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
 	int error = 0;
 
-	if (!sbh || block_device_ejected(sb))
+	if (!sbh || !buffer_mapped(sbh) || block_device_ejected(sb))
 		return error;
 	if (buffer_write_io_error(sbh)) {
 		/*
@@ -4368,8 +4368,26 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	ext4_superblock_csum_set(sb);
 	mark_buffer_dirty(sbh);
 	if (sync) {
-		error = __sync_dirty_buffer(sbh,
-			test_opt(sb, BARRIER) ? WRITE_FUA : WRITE_SYNC);
+		lock_buffer(sbh);
+		/* superblock bh may be invalidated due to drive failure */
+		if (!buffer_mapped(sbh)) {
+			unlock_buffer(sbh);
+			ext4_msg(sb, KERN_ERR, "Can not write superblock "
+				 "because disk cache was invalidated");
+			return -EIO;
+		}
+		if (test_clear_buffer_dirty(sbh)) {
+			get_bh(sbh);
+			sbh->b_end_io = end_buffer_write_sync;
+			error = submit_bh(test_opt(sb, BARRIER) ?
+					  WRITE_FUA : WRITE_SYNC, sbh);
+			wait_on_buffer(sbh);
+			if (!error && !buffer_uptodate(sbh))
+				error = -EIO;
+		} else {
+			unlock_buffer(sbh);
+		}
+
 		if (error)
 			return error;
 
-- 
1.8.3.1

