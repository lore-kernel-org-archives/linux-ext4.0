From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] chattr: improve the description for 'j' option in manpage
Date: Thu, 30 Jan 2014 11:46:16 +0800
Message-ID: <1391053576-31308-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62477 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaA3Dll (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jan 2014 22:41:41 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so2599685pbb.31
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jan 2014 19:41:41 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Ext4 file system also supports to set/clear 'j' attribute, but it just
say that this option is only useful for ext3 in manpage.  This commit
fixes it.

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/chattr.1.in |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 932ef4b..2a3640c 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -112,8 +112,8 @@ to the file.  Only the superuser or a process possessing the
 CAP_LINUX_IMMUTABLE capability can set or clear this attribute.
 .PP
 A file with the `j' attribute has all of its data written to the ext3
-journal before being written to the file itself, if the filesystem is
-mounted with the "data=ordered" or "data=writeback" options.  When the
+or ext4 journal before being written to the file itself, if the filesystem
+is mounted with the "data=ordered" or "data=writeback" options.  When the
 filesystem is mounted with the "data=journal" option all file data
 is already journalled and this attribute has no effect.  Only
 the superuser or a process possessing the CAP_SYS_RESOURCE
@@ -171,7 +171,7 @@ The `c', 's',  and `u' attributes are not honored
 by the ext2, ext3, and ext4 filesystems as implemented in the current
 mainline Linux kernels.
 .PP
-The `j' option is only useful if the filesystem is mounted as ext3.
+The `j' option is only useful if the filesystem is mounted as ext3 or ext4.
 .PP
 The `D' option is only useful on Linux kernel 2.5.19 and later.
 .SH AVAILABILITY
-- 
1.7.9.7

