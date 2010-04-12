From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 3/5] ext2: Remove duplicate code from ext2_sync_fs()
Date: Mon, 12 Apr 2010 22:41:43 +0200
Message-ID: <1271104905-8804-4-git-send-email-jblunck@suse.de>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38970 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab0DLUmE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 16:42:04 -0400
In-Reply-To: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Depending in the state (valid or unchecked) of the filesystem either
ext2_sync_super() or ext2_commit_super() is called. If the filesystem is
currently valid (it is checked), we first mark it unchecked and afterwards
duplicate the work that ext2_sync_super() is doing later. Therefore this
patch removes the duplicate code and calls ext2_sync_super() directly after
marking the filesystem unchecked.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext2/super.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 4a17ca3..40fc8d5 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1164,16 +1164,9 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
 
 	lock_kernel();
-	ext2_clear_super_error(sb);
