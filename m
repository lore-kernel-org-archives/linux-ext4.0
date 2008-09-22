From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 4/10] xfs: Fix error handling in write_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 19:56:37 +0900
Message-ID: <20080922195637t-sato__35319.9835437865$1222081193$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redh
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50100 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYIVK6L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 06:58:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've changed write_super_lockfs/unlockfs so that they always return
0 (success) to keep a current behavior.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 xfs_super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -uprN -X linux-2.6.27-rc7-lockfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs/fs/xfs/linux-2.6/xfs_super.c linux-
2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c
--- linux-2.6.27-rc7-lockfs/fs/xfs/linux-2.6/xfs_super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-09-22 10:13:39.000000000 +0900
@@ -1351,7 +1351,7 @@ xfs_fs_remount(
  * need to take care of themetadata. Once that's done write a dummy
  * record to dirty the log in case of a crash while frozen.
  */
-STATIC void
+STATIC int
 xfs_fs_lockfs(
 	struct super_block	*sb)
 {
@@ -1359,6 +1359,7 @@ xfs_fs_lockfs(
 
 	xfs_attr_quiesce(mp);
 	xfs_fs_log_dummy(mp);
+	return 0;
 }
 
 STATIC int
