From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 4/6] jbd/jbd2: relocate bit_spinlock header to jbd_common
Date: Tue, 11 Jun 2013 18:44:28 -0400
Message-ID: <1370990670-49249-5-git-send-email-paul.gortmaker@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:47998 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3FKWpO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Jun 2013 18:45:14 -0400
In-Reply-To: <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The bit_spinlock functions are only used for the jbd_lock_bh_state
functions (and friends) in jbd_common.h and are not directly used
by either of jbd.h or jbd2.h content.

The jbd_common file is new as of commit 446066724c36 ("jdb/jbd2: factor
out common functions from the jbd[2] header files") but common
(and isolated) headers were not considered for factoring at that time.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/jbd.h        | 1 -
 include/linux/jbd2.h       | 1 -
 include/linux/jbd_common.h | 2 ++
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 7e0b622..6e5524f 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -27,7 +27,6 @@
 #include <linux/buffer_head.h>
 #include <linux/journal-head.h>
 #include <linux/stddef.h>
-#include <linux/bit_spinlock.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/lockdep.h>
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 6e051f4..9986ab8 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -26,7 +26,6 @@
 #include <linux/buffer_head.h>
 #include <linux/journal-head.h>
 #include <linux/stddef.h>
-#include <linux/bit_spinlock.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
diff --git a/include/linux/jbd_common.h b/include/linux/jbd_common.h
index 6133679..949b5dd 100644
--- a/include/linux/jbd_common.h
+++ b/include/linux/jbd_common.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_JBD_STATE_H
 #define _LINUX_JBD_STATE_H
 
+#include <linux/bit_spinlock.h>
+
 enum jbd_state_bits {
 	BH_JBD			/* Has an attached ext3 journal_head */
 	  = BH_PrivateStart,
-- 
1.8.1.2

