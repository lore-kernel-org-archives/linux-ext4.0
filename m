From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext3: Fix false EIO errors
Date: Tue, 17 Mar 2009 18:33:52 +0100
Message-ID: <1237311235-13623-2-git-send-email-jack@suse.cz>
References: <n>
 <1237311235-13623-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:34710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025AbZCQSuI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 14:50:08 -0400
In-Reply-To: <1237311235-13623-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When machine is under heavy memory pressure, it can happen that the page
we want to copy data from is paged out from memory before we copy data
from it and thus we are called with copied == 0. Generally, we should
not file buffers into journal lists if the don't really contain uptodate
data. So fix the range of buffers we file to journal list to contain
only buffers with copied data.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5fa453b..62005c0 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1261,7 +1261,7 @@ static int ext3_ordered_write_end(struct file *file,
 	int ret = 0, ret2;
 
 	from = pos & (PAGE_CACHE_SIZE - 1);
-	to = from + len;
+	to = from + copied;
 
 	ret = walk_page_buffers(handle, page_buffers(page),
 		from, to, NULL, ext3_journal_dirty_data);
-- 
1.6.0.2

