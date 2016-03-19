From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] jbd2: remove excess descriptions for handle_s
Date: Sat, 19 Mar 2016 17:06:03 +0000
Message-ID: <1458407163-10849-1-git-send-email-luisbg@osg.samsung.com>
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit bf6993276f74 ("jbd2: Use tracepoints for history file")
removed the members j_history, j_history_max and j_history_cur from struct
handle_s but the descriptions stayed lingering. Removing them.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
Hi,

Noticed this issue when running make htmldocs.

It gives the following warnings:
.//include/linux/jbd2.h:1033: warning: Excess struct/union/enum/typedef member 'j_history' description in 'journal_s'
.//include/linux/jbd2.h:1033: warning: Excess struct/union/enum/typedef member 'j_history_max' description in 'journal_s'
.//include/linux/jbd2.h:1033: warning: Excess struct/union/enum/typedef member 'j_history_cur' description in 'journal_s'

Thanks,
Luis

 include/linux/jbd2.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index fd1083c..401792d 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -781,9 +781,6 @@ jbd2_time_diff(unsigned long start, unsigned long end)
  * @j_wbufsize: maximum number of buffer_heads allowed in j_wbuf, the
  *	number that will fit in j_blocksize
  * @j_last_sync_writer: most recent pid which did a synchronous write
- * @j_history: Buffer storing the transactions statistics history
- * @j_history_max: Maximum number of transactions in the statistics history
- * @j_history_cur: Current number of transactions in the statistics history
  * @j_history_lock: Protect the transactions statistics history
  * @j_proc_entry: procfs entry for the jbd statistics directory
  * @j_stats: Overall statistics
-- 
2.5.1
