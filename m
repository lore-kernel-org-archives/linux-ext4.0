From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 3/4]ext4: Return exchanged blocks count to user space in failure
Date: Wed, 02 Sep 2009 12:18:02 +0900
Message-ID: <4A9DE3EA.1080602@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39150 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbZIBDS4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 23:18:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Return exchanged blocks count to user space in failure

From: Akira Fujita <a-fujita@rs.jp.nec.com>

Return exchanged blocks count (moved_len) to user space,
if ext4_move_extents() failed on the way.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/ioctl.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index b0b434b..efd11c8 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -255,10 +255,9 @@ setversion_out:
 					me.donor_start, me.len, &me.moved_len);
 		fput(donor_filp);

-		if (!err)
-			if (copy_to_user((struct move_extent *)arg,
-				&me, sizeof(me)))
-				return -EFAULT;
+		if (copy_to_user((struct move_extent *)arg, &me, sizeof(me)))
+			return -EFAULT;
+
 		return err;
 	}
