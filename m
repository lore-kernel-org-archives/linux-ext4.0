From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Fixup kerndoc annotation of mpage_map_and_submit_extent()
Date: Tue, 15 Oct 2013 15:32:29 +0200
Message-ID: <1381843949-31805-2-git-send-email-jack@suse.cz>
References: <1381843949-31805-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab3JONcl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Oct 2013 09:32:41 -0400
In-Reply-To: <1381843949-31805-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Document give_up_on_write argument of mpage_map_and_submit_extent().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e274e9c1171f..e7e5b3d8f002 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2178,6 +2178,9 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
  *
  * @handle - handle for journal operations
  * @mpd - extent to map
+ * @give_up_on_write - we set this to true iff there is a fatal error and there
+ *                     is no hope of writing the data. The caller should discard
+ *                     dirty pages to avoid infinite loops.
  *
  * The function maps extent starting at mpd->lblk of length mpd->len. If it is
  * delayed, blocks are allocated, if it is unwritten, we may need to convert
-- 
1.8.1.4

