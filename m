From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH XFSTESTS 2/3] Build without enabling DEBUG by default
Date: Thu, 21 Jul 2011 19:52:03 -0400
Message-ID: <1311292324-4348-2-git-send-email-tytso@mit.edu>
References: <1311292324-4348-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49501 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab1GUXwG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jul 2011 19:52:06 -0400
In-Reply-To: <1311292324-4348-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 m4/package_globals.m4 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/m4/package_globals.m4 b/m4/package_globals.m4
index 72fbbb7..f468f50 100644
--- a/m4/package_globals.m4
+++ b/m4/package_globals.m4
@@ -15,7 +15,7 @@ AC_DEFUN([AC_PACKAGE_GLOBALS],
     test -z "$BUILD_VERSION" || pkg_release="$BUILD_VERSION"
     AC_SUBST(pkg_release)
 
-    DEBUG=${DEBUG:-'-DDEBUG'}		dnl  -DNDEBUG
+    DEBUG=${DEBUG:-'-DNDEBUG'}		dnl  -DNDEBUG
     debug_build="$DEBUG"
     AC_SUBST(debug_build)
 
-- 
1.7.4.1.22.gec8e1.dirty

