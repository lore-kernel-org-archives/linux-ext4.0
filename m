From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 7/10] jfs: Fix error handling in write_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 19:57:42 +0900
Message-ID: <20080922195742t-sato__16446.0714477629$1222081182$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redh
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49987 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYIVK57 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 06:57:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've changed write_super_lockfs/unlockfs so that they always return
0 (success) to keep a current behavior.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-gfs2/Documentation/dontdiff linux-2.6.27-rc7-lockfs-gfs2/fs/jfs/super.c linux-2.6.
27-rc7-lockfs-jfs/fs/jfs/super.c
--- linux-2.6.27-rc7-lockfs-gfs2/fs/jfs/super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-jfs/fs/jfs/super.c	2008-09-22 11:02:34.000000000 +0900
@@ -543,7 +543,7 @@ out_kfree:
 	return ret;
 }
 
-static void jfs_write_super_lockfs(struct super_block *sb)
+static int jfs_write_super_lockfs(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
@@ -553,9 +553,10 @@ static void jfs_write_super_lockfs(struc
 		lmLogShutdown(log);
 		updateSuper(sb, FM_CLEAN);
 	}
+	return 0;
 }
 
-static void jfs_unlockfs(struct super_block *sb)
+static int jfs_unlockfs(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
@@ -568,6 +569,7 @@ static void jfs_unlockfs(struct super_bl
 		else
 			txResume(sb);
 	}
+	return 0;
 }
 
 static int jfs_get_sb(struct file_system_type *fs_type,
