From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4
Date: Wed, 14 Jul 2010 12:33:00 +0400
Message-ID: <87tyo2a2f7.fsf@dmon-lap.sw.ru>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
	<1278489212-12110-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: eshishki@redhat.com, jmoyer@redhat.com, rwheeler@redhat.com,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38443 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0GNIdK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Jul 2010 04:33:10 -0400
Received: by eya25 with SMTP id 25so942991eya.19
        for <linux-ext4@vger.kernel.org>; Wed, 14 Jul 2010 01:33:08 -0700 (PDT)
In-Reply-To: <1278489212-12110-3-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Wed, 7 Jul 2010 09:53:32 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Lukas Czerner <lczerner@redhat.com> writes:

> Walk through each allocation group and trim all free extents. It can be
> invoked through TRIM ioctl on the file system. The main idea is to
> provide a way to trim the whole file system if needed, since some SSD's
> may suffer from performance loss after the whole device was filled (it
> does not mean that fs is full!).
>
> It search fro free extents in each allocation group. When the free
> extent is found, blocks are marked as used and then trimmed. Afterwards
> these blocks are marked as free in per-group bitmap.
Looks ok, except two small notes:
1) trim_fs is a time consuming operation and we have to add
   condresced, and signal_pending checks to allow user to interrupt
   cmd if necessery. See patch attached.
2) IMHO runtime trim support is useful sometimes, for example when
   user really care about data security i.e. unlinked file should be
   trimmed ASAP. I think we have to provide 'secdel' mount option
   similar to secdeletion flag for inode, but this is another story
   not directly connected with the patch.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-ext4-Add-interrupt-points-to-batched-discard.patch

>From 54ca2add544f88ac9ca8c647ae7b093be9ac2872 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 14 Jul 2010 12:16:50 +0400
Subject: [PATCH] ext4: Add interrupt points to batched discard

Since fstrim is a long operation it will be good to have an
ability to interrupt it by a signal.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/mballoc.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 48abd3d..0948408 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3959,7 +3959,7 @@ static void ext4_trim_extent(struct super_block *sb, int start, int count,
 			(unsigned long long)discard_block,
 			count);
 	sb_issue_discard(sb, discard_block, count);
-
+	cond_resched();
 	ext4_lock_group(sb, group);
 	mb_free_blocks(NULL, e4b, start, ex.fe_len);
 }
@@ -3995,7 +3995,10 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 				next - start, group, e4b);
 		}
 		start = next + 1;
-
+		if (signal_pending(current)) {
+			count = -ERESTARTSYS;
+			break;
+		}
 		if ((e4b->bd_info->bb_free - count) < minblocks)
 			break;
 	}
@@ -4013,7 +4016,8 @@ int ext4_trim_fs(unsigned int minlen, struct super_block *sb)
 	struct ext4_buddy e4b;
 	ext4_group_t group;
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
-	ext4_grpblk_t minblocks;
+	ext4_grpblk_t minblocks, cnt;
+	int ret = 0;
 
 	if (!test_opt(sb, DISCARD))
 		return 0;
@@ -4023,22 +4027,25 @@ int ext4_trim_fs(unsigned int minlen, struct super_block *sb)
 		return -EINVAL;
 
 	for (group = 0; group < ngroups; group++) {
-		int err;
-
-		err = ext4_mb_load_buddy(sb, group, &e4b);
-		if (err) {
+		ret = ext4_mb_load_buddy(sb, group, &e4b);
+		if (ret) {
 			ext4_error(sb, "Error in loading buddy "
 					"information for %u", group);
-			continue;
+			break;
 		}
 
 		if (e4b.bd_info->bb_free >= minblocks) {
-			ext4_trim_all_free(sb, &e4b, minblocks);
+			cnt = ext4_trim_all_free(sb, &e4b, minblocks);
+			if (cnt < 0) {
+				ret = cnt;
+				ext4_mb_unload_buddy(&e4b);
+				break;
+			}
 		}
 		ext4_mb_unload_buddy(&e4b);
 	}
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.6.6.1


--=-=-=--
