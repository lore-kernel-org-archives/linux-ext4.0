From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH] Fix race in ext4_mb_add_n_trim()
Date: Mon, 07 Jan 2013 14:09:34 +0800
Message-ID: <50EA669E.1030008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, yawei.niu@intel.com,
	Alex Zhuravlev <bzzz@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33525 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3AGGJm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jan 2013 01:09:42 -0500
Received: by mail-pa0-f49.google.com with SMTP id bi1so10531544pad.36
        for <linux-ext4@vger.kernel.org>; Sun, 06 Jan 2013 22:09:41 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From 020243735e97f327ecba729ec05d4e3facdddc78 Mon Sep 17 00:00:00 2001
From: Niu Yawei <niu@whamcloud.com>
Date: Mon, 7 Jan 2013 01:03:26 -0500
Subject: [PATCH] Fix race in ext4_mb_add_n_trim()

In ext4_mb_add_n_trim(), lg_prealloc_lock should be taken when
changing the lg_prealloc_list.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
---
 fs/ext4/mballoc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1bf6fe7..45d3527 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4136,7 +4136,7 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
                /* The max size of hash table is PREALLOC_TB_SIZE */
                order = PREALLOC_TB_SIZE - 1;
        /* Add the prealloc space to lg */
-       rcu_read_lock();
+       spin_lock(&lg->lg_prealloc_lock);
        list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
                                                pa_inode_list) {
                spin_lock(&tmp_pa->pa_lock);
@@ -4160,7 +4160,7 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
        if (!added)
                list_add_tail_rcu(&pa->pa_inode_list,
                                        &lg->lg_prealloc_list[order]);
-       rcu_read_unlock();
+       spin_unlock(&lg->lg_prealloc_lock);

        /* Now trim the list to be not more than 8 elements */
        if (lg_prealloc_count > 8) {
--
1.7.1

