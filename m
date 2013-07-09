From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] large-fs: fix large_fs space detection
Date: Tue,  9 Jul 2013 15:05:15 +0400
Message-ID: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dchinner@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:38246 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab3GILFk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jul 2013 07:05:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currenly large_fs check compare $SCRATCH_DEV_EMPTY_SPACE and $fs_size
which is not correct because total empty size required is $SCRATCH_DEV_EMPTY_SPACE + 50Gb
This path fix space detection, so check becomes valid for all situations.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common/rc |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/common/rc b/common/rc
index fe6bbfc..c44acea 100644
--- a/common/rc
+++ b/common/rc
@@ -306,16 +306,17 @@ _setup_large_xfs_fs()
 {
 	fs_size=$1
 	local tmp_dir=/tmp/
+	# Default free space in the FS is 50GB, but you can specify more via
+	# SCRATCH_DEV_EMPTY_SPACE
+	fs_empty_space=$((50*1024*1024*1024))
 
 	[ "$LARGE_SCRATCH_DEV" != yes ] && return 0
-	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
-	[ $SCRATCH_DEV_EMPTY_SPACE -ge $fs_size ] && return 0
+	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0	
+	fs_empty_space=$((fs_empty_space + $SCRATCH_DEV_EMPTY_SPACE))
+	[ $fs_empty_space -ge $fs_size ] && return 0
 
 	# calculate the size of the file we need to allocate.
-	# Default free space in the FS is 50GB, but you can specify more via
-	# SCRATCH_DEV_EMPTY_SPACE
-	file_size=$(($fs_size - 50*1024*1024*1024))
-	file_size=$(($file_size - $SCRATCH_DEV_EMPTY_SPACE))
+	file_size=$(($fs_size - $fs_empty_space))
 
 	# mount the filesystem, create the file, unmount it
 	_scratch_mount 2>&1 >$tmp_dir/mnt.err
@@ -434,15 +435,17 @@ _setup_large_ext4_fs()
 {
 	fs_size=$1
 	local tmp_dir=/tmp/
-
-	[ "$LARGE_SCRATCH_DEV" != yes ] && return 0
-	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
-	[ $SCRATCH_DEV_EMPTY_SPACE -ge $fs_size ] && return 0
