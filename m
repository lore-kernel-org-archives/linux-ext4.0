From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 3/3] ext4: Return error code from ext4_mb_good_group()
Date: Tue,  2 Jun 2015 14:24:50 +0200
Message-ID: <1433247890-15570-3-git-send-email-lczerner@redhat.com>
References: <1433247890-15570-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbbFBMY4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2015 08:24:56 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id E6D3B2B64BB
	for <linux-ext4@vger.kernel.org>; Tue,  2 Jun 2015 12:24:55 +0000 (UTC)
In-Reply-To: <1433247890-15570-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently ext4_mb_good_group() only returns 0 or 1 depending on whether
the allocation group is suitable for use or not. However we might get
various errors and fail while initializing new group including -EIO
which would never get propagated up the call chain. This might lead to
an endless loop at writeback when we're trying to find a good group to
allocate from and we fail to initialize new group (read error for
example).

Fix this by returning proper error code from ext4_mb_good_group() and
using it in ext4_mb_regular_allocator(). In ext4_mb_regular_allocator()
we will always return only the first occurred error from
ext4_mb_good_group() and we only propagate it back  to the caller if we
do not get any other errors and we fail to allocate any blocks.

Note that with other modes than errors=continue, we will fail
immediately in ext4_mb_good_group() in case of error, however with
errors=continue we should try to continue using the file system, that's
why we're not going to fail immediately when we see an error from
ext4_mb_good_group(), but rather when we fail to find a suitable block
group to allocate from due to an problem in group initialization.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: nothing changed

 fs/ext4/mballoc.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index df02951..e0e77a7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2034,7 +2034,7 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
 		int ret = ext4_mb_init_group(ac->ac_sb, group);
 		if (ret)
-			return 0;
+			return ret;
 	}
 
 	fragments = grp->bb_fragments;
@@ -2081,7 +2081,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
 	ext4_group_t ngroups, group, i;
 	int cr;
-	int err = 0;
+	int err = 0, first_err = 0;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	struct ext4_buddy e4b;
@@ -2148,6 +2148,7 @@ repeat:
 		group = ac->ac_g_ex.fe_group;
 
 		for (i = 0; i < ngroups; group++, i++) {
+			int ret = 0;
 			cond_resched();
 			/*
 			 * Artificially restricted ngroups for non-extent
@@ -2157,8 +2158,12 @@ repeat:
 				group = 0;
 
 			/* This now checks without needing the buddy page */
-			if (!ext4_mb_good_group(ac, group, cr))
+			ret = ext4_mb_good_group(ac, group, cr);
+			if (ret <= 0) {
+				if (!first_err)
+					first_err = ret;
 				continue;
+			}
 
 			err = ext4_mb_load_buddy(sb, group, &e4b);
 			if (err)
@@ -2170,9 +2175,12 @@ repeat:
 			 * We need to check again after locking the
 			 * block group
 			 */
-			if (!ext4_mb_good_group(ac, group, cr)) {
+			ret = ext4_mb_good_group(ac, group, cr);
+			if (ret <= 0) {
 				ext4_unlock_group(sb, group);
 				ext4_mb_unload_buddy(&e4b);
+				if (!first_err)
+					first_err = ret;
 				continue;
 			}
 
@@ -2219,6 +2227,8 @@ repeat:
 		}
 	}
 out:
+	if (!err && ac->ac_status != AC_STATUS_FOUND && first_err)
+		err = first_err;
 	return err;
 }
 
-- 
1.8.3.1

