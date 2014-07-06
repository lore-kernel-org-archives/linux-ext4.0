From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] fix cross-compilation support
Date: Sat,  5 Jul 2014 20:38:32 -0400
Message-ID: <1404607112-26902-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Helmut Grohne <helmut@subdivi.de>,
	Gustavo Zacarias <gustavo@zacarias.com.ar>,
	753375@bugs.debian.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47108 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaGFAit (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 20:38:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 2500ebfc89 (util: fix make dependencies for subst) broke cross
compilation because it unconditionally used config.h without setting a
includes path so that the config.h file could be found.

The proposed fix of adding the include path (such as was proposed at
http://patchwork.ozlabs.org/patch/355662/ or in Debian Bug #753375)
aren't really the right fix, since the information in config.h is for
the target environment, and not the build environment.  So using
config.h when building helper programs used as part of the build can
potentially cause more problems than it solves.

In general, build helpers must be written to be as portable as
possible, and to not require any autoconf defined #ifdef's whenever
possible.  The subst program broke this rule to (1) address a Coverity
security complaint by using futimes if is present, and (2) to preserve
the nanosecond portion of the file timestamp.

Oh, well.  We won't be able to do the latter when cross compiling, and
as to the former, if an attacker has write access to your build tree
while you are building programs that will be run as root, you've got
bigger problems.  :-)

Fix the problem that commit 2500ebfc89 was trying to address by
explicitly adding @DEFS@ to CFLAGS, so that -DHAVE_CONFIG_H is passed
to make depend.  This fixes up the make depend without forcing the use
of config.h when cross-compiling.

Addresses-Debian-Bug: #753375
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Helmut Grohne <helmut@subdivi.de>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
Cc: 753375@bugs.debian.org
---
 MCONFIG.in   | 2 +-
 util/subst.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/MCONFIG.in b/MCONFIG.in
index 3c1a4cb..7393379 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -67,7 +67,7 @@ pkgconfigdir = $(libdir)/pkgconfig
 
 CC = @CC@
 BUILD_CC = @BUILD_CC@
-CFLAGS = @CFLAGS@
+CFLAGS = @CFLAGS@ @DEFS@
 CPPFLAGS = @INCLUDES@
 ALL_CFLAGS = $(CPPFLAGS) $(CFLAGS)
 LDFLAGS = @LDFLAGS@
diff --git a/util/subst.c b/util/subst.c
index 6a5eab1..6244831 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -5,7 +5,9 @@
  *
  */
 
+#ifdef HAVE_CONFIG_H
 #include "config.h"
+#endif
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
-- 
2.0.0

