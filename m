From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: create com_err.h symlink in includedir
Date: Wed, 16 Feb 2011 12:01:39 -0600
Message-ID: <4D5C1103.8060403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mitchb@mit.edu
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab1BPSBm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 13:01:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After debian bug #192277, debian/rules started making a symlink
to com_err.h in /usr/include.  Now I have Fedora bug #550889
for the same issue, and perhaps it's time to make this symlink
by default, rather than fixing it up in packaging steps?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debian/rules b/debian/rules
index 9fe59e6..41fca24 100755
--- a/debian/rules
+++ b/debian/rules
@@ -326,8 +326,6 @@ install-std: build
 	${INSTALL_PROGRAM} $(E2FSCK_STATIC) ${tmpdir}/sbin
 	cp ${mandir}/man8/e2fsck.8 ${mandir}/man8/e2fsck.static.8
 
-	ln -s et/com_err.h ${tmpdir}/usr/include
