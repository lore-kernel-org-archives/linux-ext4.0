From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/34] debugfs: add LIBINTL to debugfs link command
Date: Sat, 13 Sep 2014 15:11:52 -0700
Message-ID: <20140913221152.13646.7986.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24248 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaIMWL4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:11:56 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since debugfs now links in the journal code (which in turn depends on
internationalization libraries) we must add a linker option to pull
that in on Mac OSX.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/Makefile.in |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 0837151..6220943 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -35,13 +35,13 @@ SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/../e2fsck/recovery.c $(srcdir)/do_journal.c
 
 LIBS= $(LIBQUOTA) $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(LIBBLKID) \
-	$(LIBUUID) $(SYSLIBS)
+	$(LIBUUID) $(SYSLIBS) $(LIBINTL)
 DEPLIBS= $(DEPLIBQUOTA) $(LIBEXT2FS) $(LIBE2P) $(DEPLIBSS) $(DEPLIBCOM_ERR) \
 	$(DEPLIBBLKID) $(DEPLIBUUID)
 
 STATIC_LIBS= $(STATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) $(STATIC_LIBSS) \
 	$(STATIC_LIBCOM_ERR) $(STATIC_LIBBLKID) $(STATIC_LIBUUID) \
-	$(STATIC_LIBE2P) $(SYSLIBS)
+	$(STATIC_LIBE2P) $(SYSLIBS) $(LIBINTL)
 STATIC_DEPLIBS= $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBSS) \
 		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBUUID) \
 		$(DEPSTATIC_LIBE2P)

