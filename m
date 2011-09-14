From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libquota: fix "make install" so it works in with a VPATH build directory
Date: Wed, 14 Sep 2011 13:18:02 -0400
Message-ID: <1316020683-19141-1-git-send-email-tytso@mit.edu>
Cc: adityakali@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33818 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab1INRSF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 13:18:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also fix up the name of the header file which we are installing so it
is correct.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/Makefile.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
index 0005ac0..1f57441 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -82,8 +82,8 @@ install:: all installdirs
 	$(Q) $(INSTALL_DATA) libquota.a $(DESTDIR)$(libdir)/libquota.a
 	-$(Q) $(RANLIB) $(DESTDIR)$(libdir)/libquota.a
 	$(Q) $(CHMOD) $(LIBMODE) $(DESTDIR)$(libdir)/libquota.a
-	$(E) "	INSTALL_DATA $(includedir)/quota/quota.h"
-	$(Q) $(INSTALL_DATA) mkquota.h $(DESTDIR)$(includedir)/quota/mkquota.h
+	$(E) "	INSTALL_DATA $(includedir)/quota/mkquota.h"
+	$(Q) $(INSTALL_DATA) $(srcdir)/mkquota.h $(DESTDIR)$(includedir)/quota/mkquota.h
 	$(Q) for i in $(SMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man3dir)/$$i.gz; \
 		echo "	INSTALL_DATA $(man3dir)/$$i"; \
-- 
1.7.4.1.22.gec8e1.dirty

