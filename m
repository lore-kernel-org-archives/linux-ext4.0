From: Andreas Dilger <adilger@clusterfs.com>
Subject: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Wed, 19 Sep 2007 00:14:04 -0600
Message-ID: <20070919061404.GA1628@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:57044 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXISGNl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2007 02:13:41 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It isn't possible to build an e2fsprogs via "make rpm" on SuSE and have it
install cleanly, because they split out some of the libraries into separate
packages.

We've got the current patch to the .spec file, but I'm open to discussion
if it is more desirable to change the .spec to continue to build separate
RPMs (though that is more of a distribution hassle and might need major
changes in the .spec file).


Index: e2fsprogs-1.40.2/e2fsprogs.spec.in
===================================================================
--- e2fsprogs-1.40.2.orig/e2fsprogs.spec.in
+++ e2fsprogs-1.40.2/e2fsprogs.spec.in
@@ -13,6 +13,10 @@
 Url: http://e2fsprogs.sourceforge.net/
 Prereq: /sbin/ldconfig
 BuildRoot: %{_tmppath}/%{name}-root
+%if %{_vendor} == "suse"
+Obsoletes: libcom_err < %{version}
+Provides: libcom_err = %{version}
+%endif
 
 %description
 The e2fsprogs package contains a number of utilities for creating,

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
