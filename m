From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 2/2] e2fsprogs: add the description to mke2fs manual
Date: Thu, 22 Dec 2011 17:30:42 +0900
Message-ID: <4EF2EAB2.2030100@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42823 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1LVIbv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Dec 2011 03:31:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds the description that the -S option
and the uninti_bg feature are not set simultaneously 
to mke2fs manual.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 misc/mke2fs.8.in |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 8e78249..26d731b 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -601,6 +601,15 @@ program should be run immediately after this option is used, and there
 is no guarantee that any data will be salvageable.  It is critical to
 specify the correct filesystem blocksize when using this option,
 or there is no chance of recovery.
+
+Note that the -S option and the uninit_bg feature
+can not be set simultaneously. If we run the -S option to ext4,
+unset the uninit_bg feature explicitly.
+After that, we must set the uninit_bg feature with
+.B tune2fs
+and run
+.B e2fsck
+to enable it.
 .\" .TP
 .\" .BI \-t " test"
 .\" Check the device for bad blocks before creating the file system
