From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix libext2fs info page name
Date: Thu, 29 Jan 2009 17:52:13 -0500
Message-ID: <4982331D.9070707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jerry James <loganjerry@gmail.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40054 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbZA2WwR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2009 17:52:17 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In Red Hat bug #481620 Jerry reported that the libext2fs info page
is not accesable via "info libext2fs" but is via "info libext2fs.info"
and suggested that the following change should fix it.

Additional info from Jerry:
The problem is that makeinfo 4.12 interprets the dot in "libext2fs.info"
to be the end of the description portion of the info entry, even though 
it hasn't seen the closing parenthesis yet.  Making the reference be to 
just "libext2fs" works.

Reported-by: Jerry James <loganjerry@gmail.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/doc/libext2fs.texinfo
===================================================================
--- e2fsprogs.orig/doc/libext2fs.texinfo	2009-01-29 16:37:48.819575689 -0600
+++ e2fsprogs/doc/libext2fs.texinfo	2009-01-29 16:48:07.821574818 -0600
@@ -8,7 +8,7 @@
 @ifinfo
 @dircategory Development
 @direntry
-* libext2fs: (libext2fs.info).                  The EXT2FS library.
+* libext2fs: (libext2fs).                  The EXT2FS library.
 @end direntry
 @end ifinfo
 

