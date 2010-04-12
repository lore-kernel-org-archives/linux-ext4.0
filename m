From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 2/5] ext2: Set the write time in ext2_sync_fs()
Date: Mon, 12 Apr 2010 22:41:42 +0200
Message-ID: <1271104905-8804-3-git-send-email-jblunck@suse.de>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0DLUmE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 16:42:04 -0400
In-Reply-To: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is probably a typo since the write time should actually be updated by
ext2_sync_fs() instead of the mount time.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext2/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index dbebbf0..4a17ca3 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1173,7 +1173,7 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 			cpu_to_le32(ext2_count_free_blocks(sb));
 		es->s_free_inodes_count =
 			cpu_to_le32(ext2_count_free_inodes(sb));
-		es->s_mtime = cpu_to_le32(get_seconds());
+		es->s_wtime = cpu_to_le32(get_seconds());
 		ext2_sync_super(sb, es);
 	} else {
 		ext2_commit_super(sb, es);
-- 
1.6.4.2

