From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 1040/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 20:10:57 +0800
Message-ID: <20160802121057.19447-1-baolex.ni@intel.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com, mhalcrow@google.com,
	kirill.shutemov@linux.intel.com, oneukum@suse.com
To: tytso@mit.edu, adilger.kernel@dilger.ca, david.vrabel@citrix.com,
	tomi.valkeinen@ti.com, m.chehab@samsung.com,
	gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:16336 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965457AbcHBMwL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2016 08:52:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 fs/ext4/sysfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 1420a3c..251e6c5 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -162,12 +162,12 @@ static struct ext4_attr ext4_attr_##_name = {			\
 
 #define ATTR_LIST(name) &ext4_attr_##name.attr
 
-EXT4_ATTR_FUNC(delayed_allocation_blocks, 0444);
-EXT4_ATTR_FUNC(session_write_kbytes, 0444);
-EXT4_ATTR_FUNC(lifetime_write_kbytes, 0444);
-EXT4_ATTR_FUNC(reserved_clusters, 0644);
+EXT4_ATTR_FUNC(delayed_allocation_blocks, S_IRUSR | S_IRGRP | S_IROTH);
+EXT4_ATTR_FUNC(session_write_kbytes, S_IRUSR | S_IRGRP | S_IROTH);
+EXT4_ATTR_FUNC(lifetime_write_kbytes, S_IRUSR | S_IRGRP | S_IROTH);
+EXT4_ATTR_FUNC(reserved_clusters, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
-EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, inode_readahead,
+EXT4_ATTR_OFFSET(inode_readahead_blks, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH, inode_readahead,
 		 ext4_sb_info, s_inode_readahead_blks);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
 EXT4_RW_ATTR_SBI_UI(mb_stats, s_mb_stats);
@@ -177,7 +177,7 @@ EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
 EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
 EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
 EXT4_RW_ATTR_SBI_UI(extent_max_zeroout_kb, s_extent_max_zeroout_kb);
-EXT4_ATTR(trigger_fs_error, 0200, trigger_test_error);
+EXT4_ATTR(trigger_fs_error, S_IWUSR, trigger_test_error);
 EXT4_RW_ATTR_SBI_UI(err_ratelimit_interval_ms, s_err_ratelimit_state.interval);
 EXT4_RW_ATTR_SBI_UI(err_ratelimit_burst, s_err_ratelimit_state.burst);
 EXT4_RW_ATTR_SBI_UI(warning_ratelimit_interval_ms, s_warning_ratelimit_state.interval);
@@ -189,7 +189,7 @@ EXT4_RO_ATTR_ES_UI(first_error_time, s_first_error_time);
 EXT4_RO_ATTR_ES_UI(last_error_time, s_last_error_time);
 
 static unsigned int old_bump_val = 128;
-EXT4_ATTR_PTR(max_writeback_mb_bump, 0444, pointer_ui, &old_bump_val);
+EXT4_ATTR_PTR(max_writeback_mb_bump, S_IRUSR | S_IRGRP | S_IROTH, pointer_ui, &old_bump_val);
 
 static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(delayed_allocation_blocks),
-- 
2.9.2

