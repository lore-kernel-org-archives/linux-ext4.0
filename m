From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 6/10] gfs2: Fix error handling in write_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 19:57:18 +0900
Message-ID: <20080922195718t-sato__9899.80168310485$1222081235$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redh
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37791 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYIVK6n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 06:58:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've changed write_super_lockfs/unlockfs so that they always return
0 (success) to keep a current behavior.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 ops_super.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-ext4/Documentation/dontdiff linux-2.6.27-rc7-lockfs-ext4/fs/gfs2/ops_super.c linux
-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c
--- linux-2.6.27-rc7-lockfs-ext4/fs/gfs2/ops_super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c	2008-09-22 10:52:16.000000000 +0900
@@ -166,13 +166,13 @@ static int gfs2_sync_fs(struct super_blo
  *
  */
 
-static void gfs2_write_super_lockfs(struct super_block *sb)
+static int gfs2_write_super_lockfs(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
 
 	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-		return;
+		return 0;
 
 	for (;;) {
 		error = gfs2_freeze_fs(sdp);
@@ -192,6 +192,7 @@ static void gfs2_write_super_lockfs(stru
 		fs_err(sdp, "retrying...\n");
 		msleep(1000);
 	}
+	return 0;
 }
 
 /**
@@ -200,9 +201,10 @@ static void gfs2_write_super_lockfs(stru
  *
  */
 
-static void gfs2_unlockfs(struct super_block *sb)
+static int gfs2_unlockfs(struct super_block *sb)
 {
 	gfs2_unfreeze_fs(sb->s_fs_info);
+	return 0;
 }
 
 /**
