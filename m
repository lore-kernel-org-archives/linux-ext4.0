From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch 3/13] Rpm check.
Date: Tue, 24 Jul 2007 16:34:44 +0530
Message-ID: <1185275084.3789.68.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40553 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765638AbXGXLD5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 07:03:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Rpm check.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: e2fsprogs-1.40.1/e2fsprogs.spec.in
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsprogs.spec.in
+++ e2fsprogs-1.40.1/e2fsprogs.spec.in
@@ -52,6 +52,7 @@ also want to install e2fsprogs.
 %build
 %configure --enable-elf-shlibs --enable-nls
 make
+make check
 
 %install
 rm -rf $RPM_BUILD_ROOT
