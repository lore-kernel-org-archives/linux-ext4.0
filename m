From: Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] ext4: do not reference pa_inode from group_pa
Date: Wed, 8 Feb 2012 11:39:50 +0800
Message-ID: <20120208033950.GA20491@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: "stable@kernel.org" <stable@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:58836 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab2BHDt4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Feb 2012 22:49:56 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit 60e07cf515e541ea3e13b888d273c9b19a2ad9dd upstream.

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

pa_inode in group_pa is set NULL in ext4_mb_new_group_pa, so
pa_inode should be not referenced.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c           |    2 +-
 include/trace/events/ext4.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..cb990b2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3671,7 +3671,7 @@ ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 	ext4_group_t group;
 	ext4_grpblk_t bit;
 
-	trace_ext4_mb_release_group_pa(pa);
+	trace_ext4_mb_release_group_pa(sb, pa);
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 748ff7c..319538b 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -573,9 +573,9 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 );
 
 TRACE_EVENT(ext4_mb_release_group_pa,
-	TP_PROTO(struct ext4_prealloc_space *pa),
+	TP_PROTO(struct super_block *sb, struct ext4_prealloc_space *pa),
 
-	TP_ARGS(pa),
+	TP_ARGS(sb, pa),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
@@ -585,7 +585,7 @@ TRACE_EVENT(ext4_mb_release_group_pa,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= pa->pa_inode->i_sb->s_dev;
+		__entry->dev		= sb->s_dev;
 		__entry->pa_pstart	= pa->pa_pstart;
 		__entry->pa_len		= pa->pa_len;
 	),
-- 
1.7.7.3

