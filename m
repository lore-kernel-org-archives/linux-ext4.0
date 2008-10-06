From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH][1/15] e2fsprogs-specdotin.patch
Date: Mon, 06 Oct 2008 16:01:00 +0530
Message-ID: <1223289060.4007.81.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_+AnHuhzbgdBorP52RQCwZA)"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:59560 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYJFKa5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 06:30:57 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m96AUsEW027181
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 10:30:55 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8B00501BQOJ300@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 06 Oct 2008 18:30:54 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_+AnHuhzbgdBorP52RQCwZA)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Add the distro version to the RPM release number, so that it the
RPM names do not conflict.

Allow the RPM built from upstream to replace the split packages provided
by the distros.  At some point in the future it may be desirable to also
split the RPM built by this spec file, but this is complicated by the
fact that SLES and RHEL have different splits.

Signed-off-by: Girish Shilamkar <girish.shilamkar@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>

--Boundary_(ID_+AnHuhzbgdBorP52RQCwZA)
Content-type: text/x-patch; charset=UTF-8; name=e2fsprogs-specdotin.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-specdotin.patch

Add the distro version to the RPM release number, so that it the
RPM names do not conflict.

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

--Boundary_(ID_+AnHuhzbgdBorP52RQCwZA)--
