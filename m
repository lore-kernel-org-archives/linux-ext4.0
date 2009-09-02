From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 2/4]ext4: Remove unneeded BUG_ON() in ext4_move_extents()
Date: Wed, 02 Sep 2009 12:17:57 +0900
Message-ID: <4A9DE3E5.8080104@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39112 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbZIBDSm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 23:18:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Remove unneeded BUG_ON() in ext4_move_extents()

From: Akira Fujita <a-fujita@rs.jp.nec.com>

ext4_move_extents() checks with BUG_ON() whether
the exchanged blocks count accords with request blocks count.
But, if the target range (orig_start + len) includes sparse block(s),
'moved_len' (exchanged blocks count) does not accord with
'len' (request blocks count),
since sparse block is not counted in 'moved_len'.
Therefore we hit BUG_ON(), though it succeeded.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/move_extent.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 60ed567..643156a 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1323,8 +1323,5 @@ out2:
 	if (ret)
 		return ret;

-	/* All of the specified blocks must be exchanged in succeed */
-	BUG_ON(*moved_len != len);
