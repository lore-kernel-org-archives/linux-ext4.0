From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: improve ext4lazyinit scalability V2
Date: Mon, 5 Sep 2016 23:39:54 -0400
Message-ID: <20160906033954.k22xaasbn26s4wo4@thunk.org>
References: <1471263815-26022-1-git-send-email-dmonakhov@openvz.org>
 <20160815150520.GA22082@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46706 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753180AbcIFDkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Sep 2016 23:40:25 -0400
Content-Disposition: inline
In-Reply-To: <20160815150520.GA22082@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry, thanks for the patch, and Jan, thanks for the review.

This is what I've added to the ext4 tree, which should reflect all of
the comments which Jan made.

				- Ted

commit 933ef679501f124bc5eb762f6068d099a0579937
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Mon Sep 5 23:38:36 2016 -0400

    ext4: improve ext4lazyinit scalability
    
    ext4lazyinit is a global thread. This thread performs itable
    initalization under li_list_mtx mutex.
    
    It basically does the following:
    ext4_lazyinit_thread
      ->mutex_lock(&eli->li_list_mtx);
      ->ext4_run_li_request(elr)
        ->ext4_init_inode_table-> Do a lot of IO if the list is large
    
    And when new mount/umount arrive they have to block on ->li_list_mtx
    because  lazy_thread holds it during full walk procedure.
    ext4_fill_super
     ->ext4_register_li_request
       ->mutex_lock(&ext4_li_info->li_list_mtx);
       ->list_add(&elr->lr_request, &ext4_li_info >li_request_list);
    In my case mount takes 40minutes on server with 36 * 4Tb HDD.
    Common user may face this in case of very slow dev ( /dev/mmcblkXXX)
    Even more. If one of filesystems was frozen lazyinit_thread will simply
    block on sb_start_write() so other mount/umount will be stuck forever.
    
    This patch changes logic like follows:
    - grab ->s_umount read sem before processing new li_request.
      After that it is safe to drop li_list_mtx because all callers of
      li_remove_request are holding ->s_umount for write.
    - li_thread skips frozen SB's
    
    Locking order:
    Mh KOrder is asserted by umount path like follows: s_umount ->li_list_mtx so
    the only way to to grab ->s_mount inside li_thread is via down_read_trylock
    
    xfstests:ext4/023
    #PSBM-49658
    
    Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5819b0e..ebeebf5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2749,7 +2749,6 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 	sb = elr->lr_super;
 	ngroups = EXT4_SB(sb)->s_groups_count;
 
-	sb_start_write(sb);
 	for (group = elr->lr_next_group; group < ngroups; group++) {
 		gdp = ext4_get_group_desc(sb, group, NULL);
 		if (!gdp) {
@@ -2776,8 +2775,6 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 		elr->lr_next_sched = jiffies + elr->lr_timeout;
 		elr->lr_next_group = group + 1;
 	}
-	sb_end_write(sb);
-
 	return ret;
 }
 
@@ -2842,21 +2839,46 @@ cont_thread:
 			mutex_unlock(&eli->li_list_mtx);
 			goto exit_thread;
 		}
-
 		list_for_each_safe(pos, n, &eli->li_request_list) {
+			int err = 0;
+			int progress = 0;
 			elr = list_entry(pos, struct ext4_li_request,
 					 lr_request);
 
-			if (time_after_eq(jiffies, elr->lr_next_sched)) {
-				if (ext4_run_li_request(elr) != 0) {
-					/* error, remove the lazy_init job */
-					ext4_remove_li_request(elr);
-					continue;
+			if (time_before(jiffies, elr->lr_next_sched)) {
+				if (time_before(elr->lr_next_sched, next_wakeup))
+					next_wakeup = elr->lr_next_sched;
+				continue;
+			}
+			if (down_read_trylock(&elr->lr_super->s_umount)) {
+				if (sb_start_write_trylock(elr->lr_super)) {
+					progress = 1;
+					/*
+					 * We hold sb->s_umount, sb can not
+					 * be removed from the list, it is
+					 * now safe to drop li_list_mtx
+					 */
+					mutex_unlock(&eli->li_list_mtx);
+					err = ext4_run_li_request(elr);
+					sb_end_write(elr->lr_super);
+					mutex_lock(&eli->li_list_mtx);
+					n = pos->next;
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
+				if (time_before(elr->lr_next_sched,
+						next_wakeup))
+					next_wakeup = elr->lr_next_sched;
 			}
