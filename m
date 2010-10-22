From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: fix lazyinit thread prevent from sleep
Date: Fri, 22 Oct 2010 20:57:45 +0200
Message-ID: <1287773865-31168-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759437Ab0JVS5u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In my test lazyinit threat (in linux-next tree) consumes too much CPU
(90%). The reason is that there is a bug preventing the threat to sleep
and hence it keeps walking the li_request_list until the time for next
scheduled request comes.

It is because the next_wakeup is originally set to jiffies - 1 so the
thread is assuming that there is no reason to sleep, because the time
for next scheduled event is already came, however that is not true.

I have fixed that by setting next_wakeup to MAX_JIFFY_OFFSET initially
and than setting value of the next scheduled request (the one with the
smallest lr_next_sched value). It has been tested and now the CPU
utilization of lazyinit thread is under 1% (with one request in the list).

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 82ceb8b..f0b424a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2710,7 +2710,7 @@ static int ext4_lazyinit_thread(void *arg)
 
 cont_thread:
 	while (true) {
-		next_wakeup = jiffies-1;
+		next_wakeup = MAX_JIFFY_OFFSET;
 
 		mutex_lock(&eli->li_list_mtx);
 		if (list_empty(&eli->li_request_list)) {
@@ -2722,10 +2722,11 @@ cont_thread:
 			elr = list_entry(pos, struct ext4_li_request,
 					 lr_request);
 
-			if (time_before_eq(jiffies, elr->lr_next_sched))
-				continue;
+			if (time_after_eq(jiffies, elr->lr_next_sched))
+				ret = ext4_run_li_request(elr);
 
-			if ((ret = ext4_run_li_request(elr)) != 0) {
+			if (ret) {
+				ret = 0;
 				ext4_remove_li_request(elr);
 				continue;
 			}
-- 
1.7.2.3

