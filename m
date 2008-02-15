From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] UPDATED: building e2fsprogs-interim
Date: Fri, 15 Feb 2008 13:01:28 -0600
Message-ID: <47B5E188.6080502@redhat.com>
References: <47B487C4.8010602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbYBOTBf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Feb 2008 14:01:35 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1FJ1ZrG019589
	for <linux-ext4@vger.kernel.org>; Fri, 15 Feb 2008 14:01:35 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FJ1ZFi025317
	for <linux-ext4@vger.kernel.org>; Fri, 15 Feb 2008 14:01:35 -0500
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FJ1XPg020557
	for <linux-ext4@vger.kernel.org>; Fri, 15 Feb 2008 14:01:33 -0500
In-Reply-To: <47B487C4.8010602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> I needed this patch to build e2fsprogs-interim, to fix a parallel make problem
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
>
>   
An update; running through the whole fedora build turned up another
one (csum.o).  Out of curiosity do things like ext2_fs.h (which are not
generated) really need to be listed as dependencies?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: e2fsprogs-git/e2fsprogs/lib/ext2fs/Makefile.in
===================================================================
--- e2fsprogs-git.orig/e2fsprogs/lib/ext2fs/Makefile.in
+++ e2fsprogs-git/e2fsprogs/lib/ext2fs/Makefile.in
@@ -390,8 +390,8 @@ crc16.o: $(srcdir)/crc16.c $(srcdir)/ext
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h
 crc32.o: $(srcdir)/crc32.c $(srcdir)/ext2_fs.h $(srcdir)/crc16.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h
-csum.o: $(srcdir)/csum.c $(srcdir)/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h
+csum.o: $(srcdir)/csum.c $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(top_builddir)/lib/ext2fs/ext2_err.h
 dblist.o: $(srcdir)/dblist.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
  $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h \
@@ -518,7 +518,8 @@ mkdir.o: $(srcdir)/mkdir.c $(srcdir)/ext
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
-mmp.o: $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h
+mmp.o: $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h
 mkjournal.o: $(srcdir)/mkjournal.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/e2p/e2p.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h $(srcdir)/ext3_extents.h \
