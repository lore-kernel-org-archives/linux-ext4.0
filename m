From: Xiong Zhou <jencce.kernel@gmail.com>
Subject: [PATCH] include/jbd: add missing ifdef CONFIG_BLOCK
Date: Tue, 30 Jul 2013 08:31:46 +0800 (CST)
Message-ID: <alpine.DEB.2.02.1307300830370.2625@M2420>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59651 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3G3AcH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 20:32:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Xiong Zhou <jencce.kernel@gmail.com>

In jbd{2}.h, BH_PrivateStart is used in the define of enum jbd_state_bits,
which is defined in buffer_head.h under ifdef CONFIG_BLOCK. In these
two headers, BUFFER_FNS and TAS_BUFFER_FNS and jbd_common.h refer to
enum jbd_state_bits, so they should under ifdef CONFIG_BLOCK.

Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
 include/linux/jbd.h  |    2 ++
 include/linux/jbd2.h |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 8685d1b..e9dcf47 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -244,6 +244,7 @@ typedef struct journal_superblock_s
 #include <linux/fs.h>
 #include <linux/sched.h>
 
+#ifdef CONFIG_BLOCK
 enum jbd_state_bits {
 	BH_JBD			/* Has an attached ext3 journal_head */
 	  = BH_PrivateStart,
@@ -269,6 +270,7 @@ TAS_BUFFER_FNS(RevokeValid, revokevalid)
 BUFFER_FNS(Freed, freed)
 
 #include <linux/jbd_common.h>
+#endif
 
 #define J_ASSERT(assert)	BUG_ON(!(assert))
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index d5b50a1..6214b80 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -298,6 +298,7 @@ typedef struct journal_superblock_s
 #include <linux/fs.h>
 #include <linux/sched.h>
 
+#ifdef CONFIG_BLOCK
 enum jbd_state_bits {
 	BH_JBD			/* Has an attached ext3 journal_head */
 	  = BH_PrivateStart,
@@ -326,6 +327,7 @@ BUFFER_FNS(Shadow, shadow)
 BUFFER_FNS(Verified, verified)
 
 #include <linux/jbd_common.h>
+#endif
 
 #define J_ASSERT(assert)	BUG_ON(!(assert))
 
