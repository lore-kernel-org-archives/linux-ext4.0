From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] MCONFIG: allow developers to override CFLAGS
Date: Sun, 21 Sep 2014 15:37:39 -0400
Message-ID: <1411328260-8665-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39832 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbaIUThs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 15:37:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move other C compiler flags to ALL_CFLAGS so that CFLAGS only controls
the debugging and optimization flags.  This allows a developer to
build with "make CFLAGS=-g" in order to compile w/o optimization.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 MCONFIG.in | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/MCONFIG.in b/MCONFIG.in
index 4751176..29505da 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -73,9 +73,9 @@ pkgconfigdir = $(libdir)/pkgconfig
 
 CC = @CC@
 BUILD_CC = @BUILD_CC@
-CFLAGS = @CFLAGS@ @DEFS@ $(LOCAL_CFLAGS)
+CFLAGS = @CFLAGS@
 CPPFLAGS = @INCLUDES@
-ALL_CFLAGS = $(CPPFLAGS) $(CFLAGS)
+ALL_CFLAGS = $(CPPFLAGS) $(CFLAGS) @DEFS@ $(LOCAL_CFLAGS)
 LDFLAGS = @LDFLAGS@
 ALL_LDFLAGS = $(LDFLAGS) @LDFLAG_DYNAMIC@
 LDFLAGS_STATIC = $(LDFLAGS) @LDFLAG_STATIC@
@@ -197,14 +197,14 @@ WFLAGS=		-std=gnu99 -D_XOPEN_SOURCE=600 -D_GNU_SOURCE \
 			-UENABLE_NLS
 
 gcc-wall-new:
-	($(MAKE) CFLAGS="@CFLAGS@ $(WFLAGS)" > /dev/null) 2>&1 | sed -f $(top_srcdir)/util/gcc-wall-cleanup
+	($(MAKE) CFLAGS="$(ALL_CFLAGS) $(WFLAGS)" > /dev/null) 2>&1 | sed -f $(top_srcdir)/util/gcc-wall-cleanup
 
 gcc-wall:
 	$(MAKE) clean > /dev/null
 	$(MAKE) gcc-wall-new
 
 static-check:
-	($(MAKE) C=1 V=1 CFLAGS="@CFLAGS@ $(WFLAGS)") 2>&1 | sed -f $(top_srcdir)/util/static-analysis-cleanup
+	($(MAKE) C=1 V=1 CFLAGS="$(ALL_CFLAGS) $(WFLAGS)") 2>&1 | sed -f $(top_srcdir)/util/static-analysis-cleanup
 
 static-check-all:
 	$(MAKE) clean > /dev/null
-- 
2.1.0

