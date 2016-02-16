From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] jbd2: Prevent panic for destroyed devices
Date: Tue, 16 Feb 2016 14:36:05 +0400
Message-ID: <1455618965-26699-2-git-send-email-dmonakhov@openvz.org>
References: <1455618965-26699-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:31969 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbcBPKg0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2016 05:36:26 -0500
In-Reply-To: <1455618965-26699-1-git-send-email-dmonakhov@openvz.org>
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

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/jbd2/journal.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 81e6226..f2760c8 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1333,6 +1333,18 @@ static int jbd2_write_superblock(journal_t *journal, int write_op)
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_op &= ~(REQ_FUA | REQ_FLUSH);
 	lock_buffer(bh);
+	/*
+	 * Some disk drives may invalidate its page cache on failure
+	 * so sbh becomes unmapped.
+	 */
+	if (!buffer_mapped(bh)) {
+		/* Disk dissapeared under us, there is nothing we can
+		   do but complain */
+		printk(KERN_ERR "JBD2: journal superblock was invalidated "
+		       "for %s.\n", journal->j_devname);
+		return -EIO;
+	}
+
 	if (buffer_write_io_error(bh)) {
 		/*
 		 * Oh, dear.  A previous attempt to write the journal
-- 
1.8.3.1

