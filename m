From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext2: include fs.h in ext2_fs.h
Date: Fri, 03 Dec 2010 10:26:26 -0600
Message-ID: <4CF91A32.6080706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Cezary Sliwa <sliwa@blue.cft.edu.pl>
To: ext4 development <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab0LCQ0h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Dec 2010 11:26:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As reported by Cezary Sliwa in
https://bugzilla.kernel.org/show_bug.cgi?id=24282
ext2_fs.h references FS_DIRSYNC_FL etc, but does not
include <linux/fs.h> to define them.  This seems ok
for kernelspace builds, but breaks userspace applications
which include ext2_fs.h.

Reported-by: Cezary Sliwa <sliwa@blue.cft.edu.pl>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 2dfa707..91f90e4 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -16,6 +16,7 @@
 #ifndef _LINUX_EXT2_FS_H
 #define _LINUX_EXT2_FS_H
 
+#include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/magic.h>
