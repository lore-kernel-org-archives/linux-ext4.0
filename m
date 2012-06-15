From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] E2fsprogs/chattr: update manual of chattr for No_COW
Date: Fri, 15 Jun 2012 10:03:36 +0800
Message-ID: <1339725816-8423-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3888 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab2FOB4D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jun 2012 21:56:03 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5F1u07g005603
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2012 09:56:00 +0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The manpage of chattr is lack of an update for No_COW.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 misc/chattr.1.in |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 2500561..64aab7b 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -19,17 +19,18 @@ chattr \- change file attributes on a Linux file system
 .B chattr
 changes the file attributes on a Linux file system.
 .PP
-The format of a symbolic mode is +-=[acdeijstuADST].
+The format of a symbolic mode is +-=[acdeijstuACDST].
 .PP
 The operator `+' causes the selected attributes to be added to the
 existing attributes of the files; `-' causes them to be removed; and
 `=' causes them to be the only attributes that the files have.
 .PP
-The letters `acdeijstuADST' select the new attributes for the files:
+The letters `acdeijstuACDST' select the new attributes for the files:
 append only (a), compressed (c), no dump (d), extent format (e), immutable (i),
 data journalling (j), secure deletion (s), no tail-merging (t),
-undeletable (u), no atime updates (A), synchronous directory updates (D),
-synchronous updates (S), and top of directory hierarchy (T).
+undeletable (u), no atime updates (A), no copy on write (C),
+synchronous directory updates (D), synchronous updates (S),
+and top of directory hierarchy (T).
 .PP
 The following attributes are read-only, and may be listed by
 .BR lsattr (1)
-- 
1.6.5.2

