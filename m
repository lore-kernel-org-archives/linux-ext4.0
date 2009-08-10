From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/6] Add V=1 support when linking e2freefrag in misc/Makefile.in
Date: Sun,  9 Aug 2009 23:31:57 -0400
Message-ID: <1249875118-26291-6-git-send-email-tytso@mit.edu>
References: <20090727183636.GN4231@webber.adilger.int>
Cc: Andreas Dilger <adilger@sun.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46046 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbZHJDcC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Aug 2009 23:32:02 -0400
In-Reply-To: <20090727183636.GN4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/Makefile.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index 3076f67..a5ed0c0 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -289,8 +289,8 @@ logsave.profiled: profiled/logsave.o
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o logsave.profiled profiled/logsave.o
 
 e2freefrag: $(E2FREEFRAG_OBJS)
-	@echo "	LD $@"
-	@$(CC) $(ALL_LDFLAGS) -o e2freefrag $(E2FREEFRAG_OBJS) $(LIBS)
+	$(E) "	LD $@"
+	$(Q) $(CC) $(ALL_LDFLAGS) -o e2freefrag $(E2FREEFRAG_OBJS) $(LIBS)
 
 filefrag: $(FILEFRAG_OBJS)
 	$(E) "	LD $@"
-- 
1.6.3.2.1.gb9f7d.dirty

