From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: improve ext4lazyinit scalability
Date: Tue, 19 Jul 2016 16:30:32 +0400
Message-ID: <1468931432-1568-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:5635 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbcGSNKS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jul 2016 09:10:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4lazyinit is global thread. This thread performs itable initalization under

It basically does followes:
ext4_lazyinit_thread
  ->mutex_lock(&eli->li_list_mtx);
  ->ext4_run_li_request(elr)
    ->ext4_init_inode_table-> Do a lot of IO if list is large

And when new mounts/umount arrives they have to block on ->li_list_mtx
because  lazy_thread holds it during full walk procedure.
ext4_fill_super
 ->ext4_register_li_request
   ->mutex_lock(&ext4_li_info->li_list_mtx);
   ->list_add(&elr->lr_request, &ext4_li_info >li_request_list);
In my case mount takes 40minutes on server with 36 * 4Tb HDD.
Convenient user may face this in case of very slow dev ( /dev/mmcblkXXX)
Even more. I one of filesystem was frozen lazyinit_thread will simply blocks
on sb_start_write() so other mount/umounts will suck forever.

This patch changes logic like follows:
- grap ->s_umount read sem before process new li_request after that it is safe
  to drop list_mtx because all callers of li_remove_requers are holds ->s_umount
  for write.
- li_thread skip frozen SB's

Locking:
Locking order is asserted by umout path like follows: s_umount ->li_list_mtx
so the only way to to grab ->s_mount inside li_thread is via down_read_trylock

xfstests:ext4/022 message-id:1468931005-774-1-git-send-email-dmonakhov@openvz.org
#PSBM-49658

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c | 53 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3822a5a..0ee193f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2635,7 +2635,6 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 	sb = elr->lr_super;
 	ngroups = EXT4_SB(sb)->s_groups_count;
 
-	sb_start_write(sb);
 	for (group = elr->lr_next_group; group < ngroups; group++) {
 		gdp = ext4_get_group_desc(sb, group, NULL);
 		if (!gdp) {
@@ -2662,8 +2661,6 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 		elr->lr_next_sched = jiffies + elr->lr_timeout;
 		elr->lr_next_group = group + 1;
 	}
-	sb_end_write(sb);
-
 	return ret;
 }
 
@@ -2713,9 +2710,9 @@ static struct task_struct *ext4_lazyinit_task;
 static int ext4_lazyinit_thread(void *arg)
 {
 	struct ext4_lazy_init *eli = (struct ext4_lazy_init *)arg;
-	struct list_head *pos, *n;
 	struct ext4_li_request *elr;
 	unsigned long next_wakeup, cur;
+	LIST_HEAD(request_list);
 
 	BUG_ON(NULL == eli);
 
@@ -2728,21 +2725,43 @@ cont_thread:
 			mutex_unlock(&eli->li_list_mtx);
 			goto exit_thread;
 		}
-
-		list_for_each_safe(pos, n, &eli->li_request_list) {
-			elr = list_entry(pos, struct ext4_li_request,
-					 lr_request);
-
-			if (time_after_eq(jiffies, elr->lr_next_sched)) {
-				if (ext4_run_li_request(elr) != 0) {
-					/* error, remove the lazy_init job */
-					ext4_remove_li_request(elr);
-					continue;
+		list_splice_init(&eli->li_request_list, &request_list);
+		while (!list_empty(&request_list)) {
+			int err = 0;
+			int progress = 0;
+
+			elr = list_entry(request_list.next,
+					 struct ext4_li_request, lr_request);
+			list_move(request_list.next, &eli->li_request_list);
+			if (time_before(jiffies, elr->lr_next_sched)) {
+				if (time_before(elr->lr_next_sched, next_wakeup))
+					next_wakeup = elr->lr_next_sched;
+				continue;
+			}
+			if (down_read_trylock(&elr->lr_super->s_umount)) {
+				if (sb_start_write_trylock(elr->lr_super)) {
+					progress = 1;
+					/* We holds sb->s_umount, sb can not
+					 * be removed from the list, it is
+					 * now safe to drop li_list_mtx
+					 */
+					mutex_unlock(&eli->li_list_mtx);
+					err = ext4_run_li_request(elr);
+					sb_end_write(elr->lr_super);
+					mutex_lock(&eli->li_list_mtx);
 				}
+				up_read((&elr->lr_super->s_umount));
+			}
+			/* error, remove the lazy_init job */
+			if (err) {
+				ext4_remove_li_request(elr);
+				continue;
+			}
+			if (!progress) {
+				elr->lr_next_sched = jiffies +
+					(prandom_u32()
+					 % (EXT4_DEF_LI_MAX_START_DELAY * HZ));
 			}
