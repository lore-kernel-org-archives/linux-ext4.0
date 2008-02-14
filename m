From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] building e2fsprogs-interim
Date: Thu, 14 Feb 2008 12:26:12 -0600
Message-ID: <47B487C4.8010602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbYBNS0O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 13:26:14 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1EIQDhS030226
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 13:26:13 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1EIQD6w003776
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 13:26:13 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m1EIQDqs012145
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 13:26:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I needed this patch to build e2fsprogs-interim, to fix a parallel make problem

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.40.6/lib/ext2fs/Makefile.in
===================================================================
--- e2fsprogs-1.40.6.orig/lib/ext2fs/Makefile.in
+++ e2fsprogs-1.40.6/lib/ext2fs/Makefile.in
@@ -518,7 +518,7 @@ mkdir.o: $(srcdir)/mkdir.c $(srcdir)/ext
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
-mmp.o: $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h
+mmp.o: $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h $(top_builddir)/lib/ext2fs/ext2_err.h
 mkjournal.o: $(srcdir)/mkjournal.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/e2p/e2p.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h $(srcdir)/ext3_extents.h \
