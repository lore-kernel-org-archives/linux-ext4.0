From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] fs: Avoid data corruption with blocksize < pagesize
Date: Tue, 17 Mar 2009 18:33:54 +0100
Message-ID: <1237311235-13623-4-git-send-email-jack@suse.cz>
References: <n>
 <1237311235-13623-1-git-send-email-jack@suse.cz>
 <1237311235-13623-2-git-send-email-jack@suse.cz>
 <1237311235-13623-3-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Nick Piggin <npiggin@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:33797 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbZCQSlh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 14:41:37 -0400
In-Reply-To: <1237311235-13623-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Assume the following situation:
Filesystem with blocksize < pagesize - suppose blocksize = 1024,
pagesize = 4096. File 'f' has first four blocks already allocated.
(line with "state:" contains the state of buffers in the page - m = mapped,
u = uptodate, d = dirty)

  process 1:                       process 2:

write to 'f' bytes 0 - 1024
  state: |mud,-,-,-|, page dirty
                                   write to 'f' bytes 1024 - 4096:
                                     __block_prepare_write() maps blocks
                                       state: |mud,m,m,m|, page dirty
                                     we fail to copy data -> copied = 0
                                     block_write_end() does nothing
                                     page gets unlocked
writepage() is called on the page
  block_write_full_page() writes buffers with garbage

This patch fixes the problem by skipping !uptodate buffers in
block_write_full_page().

CC: Nick Piggin <npiggin@suse.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9f69741..22c0144 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1774,7 +1774,12 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	} while (bh != head);
 
 	do {
-		if (!buffer_mapped(bh))
+		/*
+		 * Parallel write could have already mapped the buffers but
+		 * it then had to restart before copying in new data. We
+		 * must avoid writing garbage so just skip the buffer.
+		 */
+		if (!buffer_mapped(bh) || !buffer_uptodate(bh))
 			continue;
 		/*
 		 * If it's a fully non-blocking write attempt and we cannot
-- 
1.6.0.2

