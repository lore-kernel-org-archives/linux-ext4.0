From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH V4 11/11] mke2fs.8.in: update the manual for the -d option
Date: Sat, 1 Mar 2014 03:06:15 -0500
Message-ID: <1393661175-459-12-git-send-email-liezhi.yang@windriver.com>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:61682 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaCAIGm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Mar 2014 03:06:42 -0500
In-Reply-To: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update the manual for the -d option

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
---
 misc/mke2fs.8.in |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 9c38e20..bf17eae 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -52,6 +52,10 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 .I number-of-inodes
 ]
 [
+.B \-d
+.I root-directory
+]
+[
 .B \-n
 ]
 [
@@ -529,6 +533,9 @@ the
 ratio).  This allows the user to specify the number
 of desired inodes directly.
 .TP
+.BI \-d " root-directory"
+Add the files from the root-directory to the filesystem.
+.TP
 .BI \-o " creator-os"
 Overrides the default value of the "creator operating system" field of the
 filesystem.  The creator field is set by default to the name of the OS the
-- 
1.7.10.4

