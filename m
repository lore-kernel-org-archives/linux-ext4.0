From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 4/4] jbd/jbd2: relocate bit_spinlock header to jbd_common
Date: Mon, 10 Jun 2013 15:32:03 -0400
Message-ID: <1370892723-30860-5-git-send-email-paul.gortmaker@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-rt-users@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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

