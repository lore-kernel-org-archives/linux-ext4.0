From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] check: build all dependencies before "make check"
Date: Tue, 14 Jun 2011 16:23:08 -0600
Message-ID: <1308090188-16136-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:43860 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab1FNWXL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 18:23:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If "make check" is run on a clean repository, it fails due to missing
dependencies for building the test programs.  Have "make check" build
all dependencies before starting the tests to ensure that it can finish
without error.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 Makefile.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 5708efd..d336c57 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -140,5 +140,5 @@ distclean-local: clean-local
 realclean-local: distclean-local
 	$(RM) -f configure
 
-check::	subs check-recursive
+check::	all check-recursive
 
-- 
1.7.3.4

