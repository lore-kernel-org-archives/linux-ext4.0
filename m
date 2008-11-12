From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 08/17] Turn on new bitmaps in e2fsck and mke2fs
Date: Tue, 11 Nov 2008 19:43:01 -0800
Message-ID: <1226461390-5502-9-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42467 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYKLDn4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:56 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hu2P007441
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:56 -0500
In-Reply-To: <1226461390-5502-8-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 e2fsck/unix.c |    2 +-
 misc/mke2fs.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 07549b9..bb379f3 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -956,7 +956,7 @@ restart:
 #else
 	io_ptr = unix_io_manager;
 #endif
-	flags = EXT2_FLAG_NOFREE_ON_ERROR;
+	flags = EXT2_FLAG_NOFREE_ON_ERROR | EXT2_FLAG_NEW_BITMAPS;
 	if ((ctx->options & E2F_OPT_READONLY) == 0)
 		flags |= EXT2_FLAG_RW;
 	if ((ctx->mount_flags & EXT2_MF_MOUNTED) == 0)
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7c35317..4509c1a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1868,8 +1868,9 @@ int main (int argc, char *argv[])
 	/*
 	 * Initialize the superblock....
 	 */
-	retval = ext2fs_initialize(device_name, EXT2_FLAG_EXCLUSIVE, &fs_param,
-				   io_ptr, &fs);
+	retval = ext2fs_initialize(device_name,
+				   EXT2_FLAG_EXCLUSIVE | EXT2_FLAG_NEW_BITMAPS,
+				   &fs_param, io_ptr, &fs);
 	if (retval) {
 		com_err(device_name, retval, _("while setting up superblock"));
 		exit(1);
-- 
1.5.6.5

