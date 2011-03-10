From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: man page typo fixes
Date: Thu, 10 Mar 2011 10:09:35 -0600
Message-ID: <4D78F7BF.6030603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Branislav_N=E1ter?= <bnater@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab1CJQJh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Mar 2011 11:09:37 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2AG9bxt016804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Mar 2011 11:09:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46ix a few typos in manpages.

Reported-by: Branislav N=E1ter <bnater@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 44d4640..41c73fd 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -214,7 +214,7 @@ to only display the leaf nodes in the extent tree.
 .IP
 (Please note that the length and range of blocks for the last extent i=
n
 an interior node is an estimate by the extents library functions, and =
is
-not stored in file esystem data structures.   Hence, the values displa=
yed
+not stored in filesystem data structures.   Hence, the values displaye=
d
 may not necessarily by accurate and does not indicate a problem or=20
 corruption in the file system.)
 .TP
diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index e09cd6d..2a600d0 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -112,14 +112,14 @@ boolean value of false.  This setting defaults to=
 true.
 .I broken_system_clock
 The
 .BR e2fsck (8)
-program has some hueristics that assume that the system clock is
+program has some heuristics that assume that the system clock is
 correct.  In addition, many system programs make similar assumptions.
 For example, the UUID library depends on time not going backwards in
 order for it to be able to make its guarantees about issuing universal=
ly
 unique ID's.  Systems with broken system clocks, are well, broken.
 However, broken system clocks, particularly in embedded systems, do
-exist.  E2fsck will attempt to use hueristics to determine if the time
-can no tbe trusted; and to skip time-based checks if this is true.  If
+exist.  E2fsck will attempt to use heuristics to determine if the time
+can not be trusted; and to skip time-based checks if this is true.  If
 this boolean is set to true, then e2fsck will always assume that the
 system clock can not be trusted.
 .TP
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index 2e8b585..1834654 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -363,10 +363,10 @@ and
 .IR tea .
 .TP
 .I flex_bg_size
-This relation specifies the number of block goups that will be packed
+This relation specifies the number of block groups that will be packed
 together to create one large virtual block group on an ext4 filesystem=
=2E
 This improves meta-data locality and performance on meta-data heavy
-workloads.  The number of goups must be a power of 2 and may only be
+workloads.  The number of groups must be a power of 2 and may only be
 specified if the flex_bg filesystem feature is enabled.
 .I options
 This relation specifies additional extended options which should be
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
