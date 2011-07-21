From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH XFSPROGS 1/3] configure.in: Declare a requirement for at least autoconf 2.50
Date: Thu, 21 Jul 2011 19:50:35 -0400
Message-ID: <1311292237-4155-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49490 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1GUXul (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jul 2011 19:50:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Debian/Ubuntu systems, if autoconf version 2.13 is installed,
autoconf will try to automatically figure out whether autoconf 2.13 or
something more modern is required (since the autoconf maintainers,
curses be upon them, didn't bother to maintain compatibility between
autoconf 2.13 and 2.50).  Unfortunately, the hueristics aren't
perfect, and although the configure.in file looks superficially like
it will be compatible with autoconf 2.13, it isn't.  You will end up
with a number of very subtle compilation failures if you use autoconf
2.13.

So declare a requirement for autoconf 2.50 using AC_PREREQ(2.50).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 configure.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index 10c4c61..664c0e9 100644
--- a/configure.in
+++ b/configure.in
@@ -1,4 +1,5 @@
 AC_INIT(include/libxfs.h)
+AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER(include/platform_defs.h)
-- 
1.7.4.1.22.gec8e1.dirty

