From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Remove ac_repeats from ext4_allocation_context.
Date: Sun, 17 Jul 2011 23:11:23 +0800
Message-ID: <1310915483-2906-3-git-send-email-tm@tao.ma>
References: <1310915483-2906-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:56415 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755027Ab1GQPNf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 11:13:35 -0400
In-Reply-To: <1310915483-2906-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

ac_repeats isn't referenced in the mballoc code. So remove it.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 20b5e7b..9d4a636 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -187,7 +187,6 @@ struct ext4_allocation_context {
 	__u16 ac_flags;		/* allocation hints */
 	__u8 ac_status;
 	__u8 ac_criteria;
-	__u8 ac_repeats;
 	__u8 ac_2order;		/* if request is to allocate 2^N blocks and
 				 * N > 0, the field stores N, otherwise 0 */
 	__u8 ac_op;		/* operation, for history only */
-- 
1.7.4

