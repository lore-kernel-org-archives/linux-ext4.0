From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 5/5] Makefile.in: allow make install e4defrag
Date: Mon, 20 Jul 2009 01:48:34 +0800
Message-ID: <1248025714-25954-1-git-send-email-bergwolf@gmail.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f193.google.com ([209.85.216.193]:41086 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbZGSRsq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jul 2009 13:48:46 -0400
Received: by pxi31 with SMTP id 31so55235pxi.33
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jul 2009 10:48:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current Makefile does not install e4defrag nor e4defrag.8.
Change misc/Makefile.in to make the e4defrag available for use.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 misc/Makefile.in |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index 5f5dab5..4cfeb69 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -28,10 +28,11 @@ SPROGS=		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
 USPROGS=	mklost+found filefrag $(UUIDD_PROG)
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
 			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
-			logsave.8 filefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@
+			logsave.8 filefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@ \
+			e4defrag.8
 FMANPAGES=	mke2fs.conf.5
 
-UPROGS=		chattr lsattr @UUID_CMT@ uuidgen
+UPROGS=		chattr lsattr @UUID_CMT@ uuidgen e4defrag
 UMANPAGES=	chattr.1 lsattr.1 @UUID_CMT@ uuidgen.1
 
 LPROGS=		@E2INITRD_PROG@
@@ -99,7 +100,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
-	$(FMANPAGES) $(LPROGS) e4defrag
+	$(FMANPAGES) $(LPROGS)
 
 @PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.profiled \
 	e2undo.profiled mke2fs.profiled dumpe2fs.profiled fsck.profiled \
-- 
1.6.2.GIT

