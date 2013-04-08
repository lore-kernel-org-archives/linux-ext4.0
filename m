From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix data corruption with direct IO read in dioread_nolock mode
Date: Mon,  8 Apr 2013 18:27:43 +0200
Message-ID: <1365438463-23025-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759492Ab3DHQ1t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 12:27:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4 is mounted in dioread_nolock mode, it calls
__blockdev_direct_IO() without DIO_LOCKING flag which also means mapping
is not synced before direct IO starts. As a result consistency between
buffered writes and following direct IO reads is broken. More
importantly, if the file is truncated, and extented back, zeroing of the
tail page is not visible to the following direct IO read which will return
stale data.

Fix the problem by flushing dirty pages before issuing direct IO read.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/indirect.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index b505a14..c18bf1c 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -809,6 +809,10 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 
 retry:
 	if (rw == READ && ext4_should_dioread_nolock(inode)) {
+		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
+						   offset + count - 1);
+		if (ret)
+			goto out;
 		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
 			mutex_lock(&inode->i_mutex);
 			ext4_flush_unwritten_io(inode);
-- 
1.7.1

