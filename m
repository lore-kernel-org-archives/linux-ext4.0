From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 10/13][e2fsprogs] Update uninit block group documetation for some of the utilities.
Date: Thu, 11 Oct 2007 14:17:00 -0500
Message-ID: <20071011191700.4599.52842.stgit@gara>
References: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:33846 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbXJKTQs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 15:16:48 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJGlwe031108
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:47 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJGloP378600
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:47 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJGlle024843
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:47 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJGkpt024820
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:46 -0600
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJGkwi037930
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:16:46 -0500
In-Reply-To: <20071011191559.4599.69332.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Update uninit block group documetation for some of the utilities.

Upadates documentation man pages for mke2fs(8) and tune2fs(8)

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 misc/mke2fs.8.in  |    9 ++++++++-
 misc/tune2fs.8.in |   12 ++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index a3dc4a1..171df5b 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -210,7 +210,7 @@ for the filesystem.  (For administrators who are creating
 filesystems on RAID arrays, it is preferable to use the
 .I stride
 RAID parameter as part of the
-.B \-R
+.B \-E
 option rather than manipulating the number of blocks per group.)  
 This option is generally used by developers who
 are developing test cases.  
@@ -406,6 +406,13 @@ Store file type information in directory entries.
 .TP
 .B has_journal
 Create an ext3 journal (as if using the
+.TP
+.B uninit_groups
+Create a filesystem without initializing all of the groups.  This speeds
+up filesystem creation time noticably, and can also reduce
+.BR e2fsck time
+dramatically.  This feature causes the filesystem to be read-only in
+older kernels is not supported in most Linux kernels, use with caution.
 .B \-j
 option).
 @JDEV@.TP
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 2e617db..5ab1bd0 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -392,10 +392,16 @@ option.
 .TP
 .B sparse_super
 Limit the number of backup superblocks to save space on large filesystems.
+.TP
+.B uninit_groups
+Allow the kernel to initialize bitmaps and inode tables and keep a high
+watermark for the unused inodes in a filesystem, to reduce
+.BR e2fsck (8)
+time.
 .RE
 .IP
 After setting or clearing 
-.B sparse_super
+.BR sparse_super , " uninit_groups" ,
 and 
 .B filetype 
 filesystem features,
@@ -414,7 +420,9 @@ can be run to convert existing directories to the hashed B-tree format.
 Linux kernels before 2.0.39 and many 2.1 series kernels do not support
 the filesystems that use any of these features.
 Enabling certain filesystem features may prevent the filesystem from
-being mounted by kernels which do not support those features.
+being mounted by kernels which do not support those features.  The
+.B uninit_groups
+feature is not yet supported by any released kernel.
 .TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
