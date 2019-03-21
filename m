Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCCBC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 325D9218A2
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfCUCCb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 22:02:31 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57810 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727660AbfCUCC3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 22:02:29 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2L22N78029515
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Mar 2019 22:02:23 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D8FB0420AAA; Wed, 20 Mar 2019 22:02:22 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     darrick.wong@oracle.com, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 3/9] Fix "make install-strip"
Date:   Wed, 20 Mar 2019 22:02:12 -0400
Message-Id: <20190321020218.5154-3-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190321020218.5154-1-tytso@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/Makefile.bsd-lib     | 2 +-
 lib/Makefile.darwin-lib  | 2 +-
 lib/Makefile.elf-lib     | 2 +-
 lib/Makefile.library     | 2 ++
 lib/Makefile.solaris-lib | 2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/Makefile.bsd-lib b/lib/Makefile.bsd-lib
index db0947f9a..2792ba3df 100644
--- a/lib/Makefile.bsd-lib
+++ b/lib/Makefile.bsd-lib
@@ -36,7 +36,7 @@ install-shlibs install:: $(BSD_LIB)
 
 install-strip: install
 
-install-shlibs-strip: install-shlibs
+install-shlibs-strip:: install-shlibs
 
 uninstall-shlibs uninstall::
 	$(RM) -f $(DESTDIR)$(BSDLIB_INSTALL_DIR)/$(BSD_LIB)
diff --git a/lib/Makefile.darwin-lib b/lib/Makefile.darwin-lib
index c94a5e721..95cdd4b49 100644
--- a/lib/Makefile.darwin-lib
+++ b/lib/Makefile.darwin-lib
@@ -39,7 +39,7 @@ install-shlibs install:: $(BSD_LIB)
 
 install-strip: install
 
-install-shlibs-strip: install-shlibs
+install-shlibs-strip:: install-shlibs
 
 uninstall-shlibs uninstall::
 	$(RM) -f $(DESTDIR)$(BSDLIB_INSTALL_DIR)/$(BSD_LIB)
diff --git a/lib/Makefile.elf-lib b/lib/Makefile.elf-lib
index bd7b2b3c4..f850f3ddb 100644
--- a/lib/Makefile.elf-lib
+++ b/lib/Makefile.elf-lib
@@ -58,7 +58,7 @@ install-strip: install
 	$(Q) $(STRIP) --strip-unneeded --remove-section=.comment \
 		--remove-section=.note $(DESTDIR)$(ELF_INSTALL_DIR)/$(ELF_LIB)
 
-install-shlibs-strip: install-shlibs
+install-shlibs-strip:: install-shlibs
 	$(E) "	STRIP-LIB $(ELF_INSTALL_DIR)/$(ELF_LIB)"
 	$(Q) $(STRIP) --strip-unneeded --remove-section=.comment \
 		--remove-section=.note $(DESTDIR)$(ELF_INSTALL_DIR)/$(ELF_LIB)
diff --git a/lib/Makefile.library b/lib/Makefile.library
index 1b86b0235..f78467aa7 100644
--- a/lib/Makefile.library
+++ b/lib/Makefile.library
@@ -1,5 +1,7 @@
 all:: subdirs $(LIBRARY).a
 
+install-shlibs-strip::
+
 install-shlibs::
 
 uninstall-shlibs::
diff --git a/lib/Makefile.solaris-lib b/lib/Makefile.solaris-lib
index 304df7d40..1e636368f 100644
--- a/lib/Makefile.solaris-lib
+++ b/lib/Makefile.solaris-lib
@@ -50,7 +50,7 @@ install-shlibs install:: $(ELF_LIB) installdirs-elf-lib
 install-strip: install
 	$(STRIP) -x $(DESTDIR)$(ELF_INSTALL_DIR)/$(ELF_LIB)
 
-install-shlibs-strip: install-shlibs
+install-shlibs-strip:: install-shlibs
 	$(STRIP) -x $(DESTDIR)$(ELF_INSTALL_DIR)/$(ELF_LIB)
 
 uninstall-shlibs uninstall::
-- 
2.19.1

