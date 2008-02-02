From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][28/28] e2fsprogs-lts-make_rpms.patch
Date: Sat, 02 Feb 2008 01:57:34 -0700
Message-ID: <20080202085734.GC31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49980 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734AbYBBI5h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:57:37 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128vaRi021771
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:57:36 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00D01SL36C00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:57:36 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Allow "make rpm" to take some extra configure options from the build
environment without having to patch the code.

Build the tarball in a temporary directory instead of the e2fsprogs
source directory.

Signed-off-by: Michael MacDonald <Michael.Macdonald@Sun.COM>
Signed-off-by: Andreas Dilger <adilger@sun.com>

diff -Naur e2fsprogs-1.40.2/contrib/build-rpm e2fsprogs-1.40.2.new/contrib/build-rpm
--- e2fsprogs-1.40.2/contrib/build-rpm	2007-06-30 08:58:34.000000000 -0400
+++ e2fsprogs-1.40.2.new/contrib/build-rpm	2007-12-21 12:49:43.000000000 -0500
@@ -1,5 +1,10 @@
 #!/bin/sh
 
+# enable xtrace output if requested
+if [ -n ${ENABLE_XTRACE:-''} ]; then
+    set -x
+fi
+
 # Build an e2fsprogs RPM from cvs
 
 pwd=`pwd`
@@ -8,8 +13,11 @@
 pkgvers=`grep Version: e2fsprogs.spec | awk '{print $2;}'`
 builddir=${pkgname}-${pkgvers}
 
+# ensure that $TMP is set to something
+TMP=${TMP:-'/tmp'}
+
 cd ..
-tmpdir=`mktemp -d rpmtmp.XXXXXX`
+tmpdir=`mktemp -d ${RPM_TMPDIR:-$TMP}/rpmtmp.XXXXXX`
 
 # We need to build a tarball for the SRPM using $builddir as the 
 # directory name (since that's what RPM will expect it to unpack
@@ -25,10 +33,13 @@
 (cd $tmpdir && tar czfh ${builddir}.tar.gz $EXCLUDE $builddir)
 
 [ "`rpmbuild --version 2> /dev/null`" ] && RPM=rpmbuild || RPM=rpm
-$RPM --define "_sourcedir `pwd`/$tmpdir" -ba $currdir/e2fsprogs.spec
-
-ret=$?
-rm -rf $tmpdir
-exit $?
 
+$RPM --define "_sourcedir $tmpdir" \
+     --define "_topdir ${RPM_TOPDIR:-$(rpm -E %_topdir)}" \
+     --define "_tmpdir ${RPM_TMPDIR:-$TMP}" \
+     --define "extra_config_flags ${EXTRA_CONFIG_FLAGS:-''}" \
+     -ba $currdir/e2fsprogs.spec
 
+rpm_exit=$?
+rm -rf $tmpdir
+exit $rpm_exit
diff -Naur e2fsprogs-1.40.2/e2fsprogs.spec.in e2fsprogs-1.40.2.new/e2fsprogs.spec.in
--- e2fsprogs-1.40.2/e2fsprogs.spec.in	2007-12-12 22:48:29.000000000 -0500
+++ e2fsprogs-1.40.2.new/e2fsprogs.spec.in	2007-12-21 12:39:11.000000000 -0500
@@ -50,7 +50,8 @@
 %setup
 
 %build
-%configure --enable-elf-shlibs --enable-nls
+%configure --enable-elf-shlibs --enable-nls \
+	%{?extra_config_flags:%extra_config_flags}
 make
 
 %install

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
