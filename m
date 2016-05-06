From: Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH e2fsprogs] Apply LDFLAGS when building tests in lib/e2p
Date: Fri,  6 May 2016 16:40:03 -0700
Message-ID: <1462578003-25315-1-git-send-email-filbranden@google.com>
Cc: linux-ext4@vger.kernel.org, Eric Christopher <echristo@google.com>,
	Michael Forney <forney@google.com>,
	Filipe Brandenburger <filbranden@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35648 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbcEFXkK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 May 2016 19:40:10 -0400
Received: by mail-pa0-f49.google.com with SMTP id iv1so51911942pac.2
        for <linux-ext4@vger.kernel.org>; Fri, 06 May 2016 16:40:10 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was previously addressed by Michael Forney on commit 53904ae543591a
but it seems the test cases from lib/e2p (tst_ostype and tst_feature)
were missed.

Fix them by adding the same $(ALL_LDFLAGS) to those two targets.

Tested by building it on a system that depends on LDFLAGS to produce
working binaries and confirming that `make check` succeeds.

Reported-by: Eric Christopher <echristo@google.com>
Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 lib/e2p/Makefile.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index 83f04ff5c04e..d109bf190051 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -68,12 +68,12 @@ e2p.pc: $(srcdir)/e2p.pc.in $(top_builddir)/config.status
 tst_ostype: $(srcdir)/ostype.c
 	$(E) "	LD $@"
 	$(Q) $(CC) -DTEST_PROGRAM -I$(top_srcdir)/lib -o tst_ostype \
-		$(srcdir)/ostype.c $(ALL_CFLAGS)
+		$(srcdir)/ostype.c $(ALL_CFLAGS) $(ALL_LDFLAGS)
 
 tst_feature: $(srcdir)/feature.c
 	$(E) "	LD $@"
 	$(Q) $(CC) -DTEST_PROGRAM -I$(top_srcdir)/lib -o tst_feature \
-		$(srcdir)/feature.c $(ALL_CFLAGS)
+		$(srcdir)/feature.c $(ALL_CFLAGS) $(ALL_LDFLAGS)
 
 check::	tst_ostype tst_feature
 	./tst_ostype
-- 
2.8.0.rc3.226.g39d4020

