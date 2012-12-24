From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] configure.in: require at least autoconf 2.54
Date: Mon, 24 Dec 2012 11:07:14 -0500
Message-ID: <1356365234-4862-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40151 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2LXQHP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Dec 2012 11:07:15 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

AC_PROG_EGREP requires autoconf 2.54, so bump up the AC_PREREQ
accordingly.

Reported-by: g.esp@free.fr
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 configure.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.in b/configure.in
index 1099309..cf96e43 100644
--- a/configure.in
+++ b/configure.in
@@ -1,5 +1,5 @@
 AC_INIT(version.h)
-AC_PREREQ(2.50)
+AC_PREREQ(2.54)
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_HEADERS([lib/config.h])
 AH_BOTTOM([#include "dirpaths.h"])
-- 
1.7.12.rc0.22.gcdd159b

