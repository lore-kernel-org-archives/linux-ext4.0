From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] Fix parallel builds for lib/ext2fs/extent.o
Date: Mon, 24 Mar 2008 16:54:20 -0500
Message-ID: <47E8230C.2030305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbYCXVyX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 17:54:23 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m2OLsLNU007500
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 17:54:21 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2OLsLif008182
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 17:54:21 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2OLsK1i028584
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 17:54:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/Makefile.in |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 1de037d..b2a8a23 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -477,6 +477,11 @@ ext_attr.o: $(srcdir)/ext_attr.c $(srcdir)/ext2_fs.h \
  $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+extent.o: $(srcdir)/extent.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2_ext_attr.h \
+ $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
 fileio.o: $(srcdir)/fileio.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
-- 1.5.4.1

