From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 3/4]ext4: Fix possible recursive locking warning in EXT4_IOC_MOVE_EXT
Date: Fri, 30 Oct 2009 16:42:01 +0900
Message-ID: <4AEA98C9.8030707@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41365 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbZJ3HoC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 03:44:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix possible recursive locking warning in EXT4_IOC_MOVE_EXT

From: Akira Fujita <a-fujita@rs.jp.nec.com>

If kernel configuration related to lock debugging is enabled,
we get possible recursive locking warning.
Therefore, use down_write_nested() to guarantee
the lock order explicitly.

This problem has been reported by Brian Rogers before.
http://marc.info/?l=linux-ext4&m=125115356928011&w=1

Reported-by: Brian Rogers <brian@xyzw.org>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/move_extent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index a7410b3..2ca6aa3 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -189,7 +189,7 @@ double_down_write_data_sem(struct inode *orig_inode, struct inode *donor_inode)
 	}

 	down_write(&EXT4_I(first)->i_data_sem);
-	down_write(&EXT4_I(second)->i_data_sem);
+	down_write_nested(&EXT4_I(second)->i_data_sem, SINGLE_DEPTH_NESTING);
 }

 /**


