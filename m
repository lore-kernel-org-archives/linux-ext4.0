From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] mke2fs.static: change library ordering to avoid a link error
Date: Wed, 14 Sep 2011 13:18:03 -0400
Message-ID: <1316020683-19141-2-git-send-email-tytso@mit.edu>
References: <1316020683-19141-1-git-send-email-tytso@mit.edu>
Cc: adityakali@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33820 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab1INRSK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 13:18:10 -0400
In-Reply-To: <1316020683-19141-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/Makefile.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index a23adcd..d7c4a5e 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -230,8 +230,8 @@ mke2fs.static: $(MKE2FS_OBJS) $(STATIC_DEPLIBS) $(STATIC_LIBE2P) $(DEPSTATIC_LIB
 		$(DEPSTATIC_LIBQUOTA) $(DEPSTATIC_LIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -static -o mke2fs.static $(MKE2FS_OBJS) \
-		$(STATIC_LIBS) $(STATIC_LIBE2P) $(STATIC_LIBBLKID) \
-		$(STATIC_LIBUUID) $(STATIC_LIBQUOTA) $(LIBINTL)
+		$(STATIC_LIBQUOTA) $(STATIC_LIBS) $(STATIC_LIBE2P) \
+		$(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL)
 
 mke2fs.profiled: $(PROFILED_MKE2FS_OBJS) $(PROFILED_DEPLIBS) \
 	$(PROFILED_LIBE2P) $(PROFILED_DEPLIBBLKID) $(PROFILED_DEPLIBUUID) \
-- 
1.7.4.1.22.gec8e1.dirty

