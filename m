From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH][1/28] e2fsprogs-specdotin.patch
Date: Sat, 02 Feb 2008 01:14:02 -0700
Message-ID: <20080202081402.GA31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49478 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646AbYBBIOQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:14:16 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128EFwg021242
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:14:15 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00M01QSZER00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:14:15 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the distro type to the RPM release number, so that it is
possible release multiple distro packages without having conflicting
RPM package names.

Allow the RPM built from upstream to replace the split packages provided
by the distros.  At some point in the future it may be desirable to also
split the RPM built by this spec file, but this is complicated by the
fact that SLES and RHEL have different splits.

Signed-off-by: Girish Shilamkar <girish.shilamkar@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: e2fsprogs-1.40.5/e2fsprogs.spec.in
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsprogs.spec.in
+++ e2fsprogs-1.40.5/e2fsprogs.spec.in
@@ -6,13 +6,22 @@
 Summary: Utilities for managing the second extended (ext2) filesystem.
 Name: e2fsprogs
 Version: @E2FSPROGS_PKGVER@
-Release: 0
+Release: 0%{_vendor}
 License: GPLv2
 Group: System Environment/Base
 Source:  ftp://download.sourceforge.net/pub/sourceforge/e2fsprogs/e2fsprogs-%{version}.tar.gz
 Url: http://e2fsprogs.sourceforge.net/
 Prereq: /sbin/ldconfig
 BuildRoot: %{_tmppath}/%{name}-root
+%if %{_vendor} == "suse"
+Group: System/Filesystems
+Provides: e2fsbn ext2fs libcom_err = %{version}
+Obsoletes: ext2fs libcom_err < %{version}
+%else
+Group: System Environment/Base
+Obsoletes: e2fsprogs-libs < %{version}
+Provides: e2fsprogs-libs = %{version}
+%endif
 
 %description
 The e2fsprogs package contains a number of utilities for creating,

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
