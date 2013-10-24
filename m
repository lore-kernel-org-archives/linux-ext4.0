From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Fix optional static code analysis using sparse
Date: Wed, 23 Oct 2013 20:11:47 -0400
Message-ID: <1382573507-26313-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49904 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab3JXALt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 20:11:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 832cb612: "e2fsprogs: add (optional) sparse checking to the
build" breaks systems that are not using GNU make.  In addition, it
breaks if the developer tries to build in a subdirectory (i.e., if he
or she tries running "make" in the misc or e2fsck or lib/ext2fs
directory), since CHECK_CMD is not set.

Fix this by moving the sparse setup to MCONFIG.

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 MCONFIG.in  | 14 ++++++++++++++
 Makefile.in | 13 -------------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/MCONFIG.in b/MCONFIG.in
index fa2b03e..557b37a 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -50,6 +50,20 @@ datadir = @datadir@
 @ifNotGNUmake@ ES = @ES@
 @ifNotGNUmake@ Q = @Q@
 
+@ifGNUmake@ CHECK=sparse
+@ifGNUmake@ CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef -Wno-non-pointer-null
+@ifGNUmake@ ifeq ("$(C)", "2")
+@ifGNUmake@   CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__
+@ifGNUmake@ else
+@ifGNUmake@   ifeq ("$(C)", "1")
+@ifGNUmake@     CHECK_CMD=$(CHECK) $(CHECK_OPTS)
+@ifGNUmake@    else
+@ifGNUmake@     CHECK_CMD=@true
+@ifGNUmake@   endif
+@ifGNUmake@ endif
+
+@ifNotGNUmake@ CHECK_CMD=@true
+
 CC = @CC@
 BUILD_CC = @BUILD_CC@
 CFLAGS = @CFLAGS@
diff --git a/Makefile.in b/Makefile.in
index ef79482..f327d19 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -5,19 +5,6 @@ top_builddir = .
 my_dir = .
 INSTALL = @INSTALL@
 
-CHECK=sparse
-CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef -Wno-non-pointer-null
-ifeq ("$(C)", "2")
-  CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__
-else
-  ifeq ("$(C)", "1")
-    CHECK_CMD=$(CHECK) $(CHECK_OPTS)
-   else
-    CHECK_CMD=@true
-  endif
-endif
-export CHECK_CMD
