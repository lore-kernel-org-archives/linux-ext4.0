From: Junho Ryu <jayr@google.com>
Subject: [PATCH] ext4: fix use-after-free in ext4_mb_new_blocks
Date: Wed, 20 Nov 2013 15:55:35 -0800
Message-ID: <1384991735-18118-1-git-send-email-jayr@google.com>
Cc: Junho Ryu <jayr@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:34268 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3KUACp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Nov 2013 19:02:45 -0500
Received: by mail-pd0-f202.google.com with SMTP id g10so688052pdj.5
        for <linux-ext4@vger.kernel.org>; Wed, 20 Nov 2013 16:02:44 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_mb_put_pa should hold pa->pa_lock before accessing pa->pa_count.
While ext4_mb_use_preallocated checks pa->pa_deleted first and then
increments pa->count later, ext4_mb_put_pa decrements pa->pa_count
before holding pa->pa_lock and then sets pa->pa_deleted.

* Free sequence
ext4_mb_put_pa (1):		atomic_dec_and_test pa->pa_count
ext4_mb_put_pa (2):		lock pa->pa_lock
ext4_mb_put_pa (3):			check pa->pa_deleted
ext4_mb_put_pa (4):			set pa->pa_deleted=1
ext4_mb_put_pa (5):		unlock pa->pa_lock
ext4_mb_put_pa (6):		remove pa from a list
ext4_mb_pa_callback:		free pa

* Use sequence
ext4_mb_use_preallocated (1):	iterate over preallocation
ext4_mb_use_preallocated (2):	lock pa->pa_lock
ext4_mb_use_preallocated (3):		check pa->pa_deleted
ext4_mb_use_preallocated (4):		increase pa->pa_count
ext4_mb_use_preallocated (5):	unlock pa->pa_lock
ext4_mb_release_context:	access pa

* Use-after-free sequence
[initial status]		<pa->pa_deleted = 0, pa_count = 1>
ext4_mb_use_preallocated (1):	iterate over preallocation
ext4_mb_use_preallocated (2):	lock pa->pa_lock
ext4_mb_use_preallocated (3):		check pa->pa_deleted
ext4_mb_put_pa (1):		atomic_dec_and_test pa->pa_count
[pa_count decremented]		<pa->pa_deleted = 0, pa_count = 0>
ext4_mb_use_preallocated (4):		increase pa->pa_count
[pa_count incremented]		<pa->pa_deleted = 0, pa_count = 1>
ext4_mb_use_preallocated (5):	unlock pa->pa_lock
ext4_mb_put_pa (2):		lock pa->pa_lock
ext4_mb_put_pa (3):			check pa->pa_deleted
ext4_mb_put_pa (4):			set pa->pa_deleted=1
[race condition!]		<pa->pa_deleted = 1, pa_count = 1>
ext4_mb_put_pa (5):		unlock pa->pa_lock
ext4_mb_put_pa (6):		remove pa from a list
ext4_mb_pa_callback:		free pa
ext4_mb_release_context:	access pa

AddressSanitizer has detected use-after-free in ext4_mb_new_blocks
Bug report: http://goo.gl/rG1On3

Signed-off-by: Junho Ryu <jayr@google.com>
---
 fs/ext4/mballoc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a41e3ba..83403dd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3442,6 +3442,9 @@ static void ext4_mb_pa_callback(struct rcu_head *head)
 {
 	struct ext4_prealloc_space *pa;
 	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
+
+	BUG_ON(atomic_read(&pa->pa_count));
+	BUG_ON(pa->pa_deleted == 0);
 	kmem_cache_free(ext4_pspace_cachep, pa);
 }
 
@@ -3455,11 +3458,13 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 	ext4_group_t grp;
 	ext4_fsblk_t grp_blk;
 
-	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
-		return;
