From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] mke2fs: clarify inode ratio in man page
Date: Fri, 25 Jan 2013 10:53:43 -0500
Message-ID: <1359129223-7366-1-git-send-email-psusi@ubuntu.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:40946 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab3AYPxo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jan 2013 10:53:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The man page still said it was not possible to change the number
of inodes on a filesystem after creating it.  You actually can
by resizing the fs, so clarify this language a bit.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 misc/mke2fs.8.in |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 023ba49..5e5e889 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -340,9 +340,9 @@ bytes of space on the disk.  The larger the
 ratio, the fewer inodes will be created.  This value generally shouldn't
 be smaller than the blocksize of the filesystem, since in that case more
 inodes would be made than can ever be used.  Be warned that it is not
-possible to expand the number
-of inodes on a filesystem after it is created, so be careful deciding the
-correct value for this parameter.
+possible to change this ratio on a filesystem after it is created, so be
+careful deciding the correct value for this parameter.  Note that resizing
+a filesystem changes the numer of inodes to maintain this ratio.
 .TP
 .BI \-I " inode-size"
 Specify the size of each inode in bytes.
-- 
1.7.9.5

