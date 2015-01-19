From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH] ext4/30[23]: ignore EBUSY error
Date: Mon, 19 Jan 2015 15:02:35 +0800
Message-ID: <1421650955-29350-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <dmonakhov@openvz.org>, <tytso@mit.edu>, <david@fromorbit.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <fstests@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63415 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728AbbASHIA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2015 02:08:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

xfstests ext4/302, ext4/303 are ext4 defragmentation stress test,
which will ioctl(EXT4_IOC_MOVE_EXT), so EBUSY is expected to happen,
for example, when page's corresponding buffer_head's state is BH_Dirty.

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 tests/ext4/302 | 2 ++
 tests/ext4/303 | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tests/ext4/302 b/tests/ext4/302
index 1e90016..c604c8f 100755
--- a/tests/ext4/302
+++ b/tests/ext4/302
@@ -60,6 +60,8 @@ filesize=${FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
+continue_on_error=write
+ignore_error=,EBUSY
 
 ##########################################
 # Test2
diff --git a/tests/ext4/303 b/tests/ext4/303
index 9573872..2d01f0f 100755
--- a/tests/ext4/303
+++ b/tests/ext4/303
@@ -60,6 +60,8 @@ filesize=${FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
+continue_on_error=write
+ignore_error=,EBUSY
 
 #################################
 # Test3
-- 
1.8.3.1

