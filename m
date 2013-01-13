From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/3] mke2fs: document bigalloc and cluster-size
Date: Sun, 13 Jan 2013 17:08:15 +0800
Message-ID: <1358068095-9034-3-git-send-email-wenqing.lz@taobao.com>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:40061 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3AMIy4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2013 03:54:56 -0500
Received: by mail-da0-f45.google.com with SMTP id w4so1382444dam.32
        for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2013 00:54:56 -0800 (PST)
In-Reply-To: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Bigalloc feature has been used for a long time, but the documentation in mke2fs
is still missing.  So add it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.8.in | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index d4fbe00..ca3083d 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -187,6 +187,11 @@ Check the device for bad blocks before creating the file system.  If
 this option is specified twice, then a slower read-write
 test is used instead of a fast read-only test.
 .TP
+.B \-C " cluster-size"
+Specify the size of cluster in bytes.  Valid cluster-size values are from
+2048 to 256M bytes per cluster.  If omiited, cluster-size is 64KB by
+default.
+.TP
 .B \-D
 Use direct I/O when writing to the disk.  This avoids mke2fs dirtying a
 lot of buffer cache memory, which may impact other applications running
@@ -516,6 +521,12 @@ prefix the feature name with a  caret ('^') character.  The
 pseudo-filesystem feature "none" will clear all filesystem features.
 .RS 1.2i
 .TP
+.B bigalloc
+Allow to allocate block-size beyond the 4096 bytes.  That can decrease the time
+spent on doing block allocation and brings smaller fragmentation, especially
+for large files.  The size can be specified using the
+.B \-C option.
+.TP
 .B dir_index
 Use hashed b-trees to speed up lookups in large directories.
 .TP
-- 
1.7.12.rc2.18.g61b472e

