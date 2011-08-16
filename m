From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Resolve the hang of direct i/o read in handling EXT4_IO_END_UNWRITTEN.
Date: Tue, 16 Aug 2011 14:37:53 +0800
Message-ID: <1313476673-4866-1-git-send-email-tm@tao.ma>
Cc: sandeen@redhat.com, mjt@tls.msk.ru, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:59945 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751282Ab1HPGk2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Aug 2011 02:40:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

EXT4_IO_END_UNWRITTEN flag set and the increase of i_aiodio_unwritten should
be done simultaneously since ext4_end_io_nolock always clear the flag and
decrease the counter in the same time.

We don't increase i_aiodio_unwritten when setting EXT4_IO_END_UNWRITTEN so
it will go nagative and causes some process to wait forever.

Part of the patch came from Eric in his e-mail, but it doesn't fix the problem
met by Michael actually.
http://marc.info/?l=linux-ext4&m=131316851417460&w=2

Reported-and-Tested-by: Michael Tokarev<mjt@tls.msk.ru>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
Eric talked about creating a helper for this and I feel that it looks
like a new functionality not a bug fix and decided to leave it to the
next merge window.

 fs/ext4/inode.c   |    9 ++++++++-
 fs/ext4/page-io.c |    6 ++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d47264c..40c0b10 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2668,8 +2668,15 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
 		goto out;
 	}
 
-	io_end->flag = EXT4_IO_END_UNWRITTEN;
+	/*
+	 * It may be over-defensive here to check EXT4_IO_END_UNWRITTEN now,
+	 * but being more careful is always safe for the future change.
+	 */
 	inode = io_end->inode;
+	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+		io_end->flag |= EXT4_IO_END_UNWRITTEN;
+		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+	}
 
 	/* Add the io_end to per-inode completed io list*/
 	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 430c401..78839af 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -334,8 +334,10 @@ submit_and_retry:
 	if ((io_end->num_io_pages >= MAX_IO_PAGES) &&
 	    (io_end->pages[io_end->num_io_pages-1] != io_page))
 		goto submit_and_retry;
-	if (buffer_uninit(bh))
-		io->io_end->flag |= EXT4_IO_END_UNWRITTEN;
+	if (buffer_uninit(bh) && !(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+		io_end->flag |= EXT4_IO_END_UNWRITTEN;
+		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+	}
 	io->io_end->size += bh->b_size;
 	io->io_next_block++;
 	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
-- 
1.7.0.4

