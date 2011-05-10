From: Tao Ma <tm@tao.ma>
Subject: [PATCH] jbd2: Fix the wrong calculation of t_max_wait in update_t_max_wait.
Date: Tue, 10 May 2011 18:48:19 +0800
Message-ID: <1305024499-8826-1-git-send-email-tm@tao.ma>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:42383 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754585Ab1EJKsm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 06:48:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

t_max_wait is added in commit 8e85fb3f to indicate how long we
were waiting for new transaction to start. In commit 6d0bf005,
it is moved to another function named update_t_max_wait to
avoid a build warning. But the wrong thing is that the original
'ts' is initialized in the start of function start_this_handle
and we can calculate t_max_wait in the right way. while with
this change, ts is initialized within the function and t_max_wait
can never be calculated right.

This patch moves the initialization of ts to the original beginning
of start_this_handle and pass it to function update_t_max_wait so
that it can be calculated right and the build warning is avoided also.

Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/jbd2/transaction.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..85a055e 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -82,7 +82,7 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
  */
 
 /*
- * Update transiaction's maximum wait time, if debugging is enabled.
+ * Update transaction's maximum wait time, if debugging is enabled.
  *
  * In order for t_max_wait to be reliable, it must be protected by a
  * lock.  But doing so will mean that start_this_handle() can not be
@@ -91,11 +91,10 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
  * means that maximum wait time reported by the jbd2_run_stats
  * tracepoint will always be zero.
  */
-static inline void update_t_max_wait(transaction_t *transaction)
+static inline void update_t_max_wait(transaction_t *transaction,
+				     unsigned long ts)
 {
 #ifdef CONFIG_JBD2_DEBUG
-	unsigned long ts = jiffies;
