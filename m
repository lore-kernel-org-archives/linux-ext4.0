From: Coly Li <i@coly.li>
Subject: [PATCH 2/5] mballoc: remove unncessary mb_find_buddy()
Date: Sun, 06 Feb 2011 12:53:53 +0800
Message-ID: <4D4E2961.6020007@coly.li>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, Theodore Tso <tytso@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:46110 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752377Ab1BFE11 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 23:27:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In __mb_check_buddy(), look at the bellowed code,

  591         fstart = -1;
  592         buddy = mb_find_buddy(e4b, 0, &max);
  593         for (i = 0; i < max; i++) {
  594                 if (!mb_test_bit(i, buddy)) {
  595                         MB_CHECK_ASSERT(i >= e4b->bd_info->bb_first_free);
  596                         if (fstart == -1) {
  597                                 fragments++;
  598                                 fstart = i;
  599                         }
  600                         continue;
  601                 }
  602                 fstart = -1;
  603                 /* check used bits only */
  604                 for (j = 0; j < e4b->bd_blkbits + 1; j++) {
  605                         buddy2 = mb_find_buddy(e4b, j, &max2);
  606                         k = i >> j;
  607                         MB_CHECK_ASSERT(k < max2);
  608                         MB_CHECK_ASSERT(mb_test_bit(k, buddy2));
  609                 }
  610         }
  611         MB_CHECK_ASSERT(!EXT4_MB_GRP_NEED_INIT(e4b->bd_info));
  612         MB_CHECK_ASSERT(e4b->bd_info->bb_fragments == fragments);
  613
  614         grp = ext4_get_group_info(sb, e4b->bd_group);
  615         buddy = mb_find_buddy(e4b, 0, &max);

On line 592, buddy is fetched by mb_find_buddy() with order 0, between
line 593 to line 615, buddy is not changed, therefore there is
no need to fetch buddy again from mb_find_buddy() with order 0 again.

We can safely remove the second mb_find_buddy() on line 615.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Alex Tomas <alex@clusterfs.com>
Cc: Theodore Tso <tytso@google.com>
---
  fs/ext4/mballoc.c |    1 -
  1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d5b372c..458dce0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -612,7 +612,6 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
  	MB_CHECK_ASSERT(e4b->bd_info->bb_fragments == fragments);

  	grp = ext4_get_group_info(sb, e4b->bd_group);
-	buddy = mb_find_buddy(e4b, 0, &max);
  	list_for_each(cur, &grp->bb_prealloc_list) {
  		ext4_group_t groupnr;
  		struct ext4_prealloc_space *pa;
-- 
1.7.3.4
