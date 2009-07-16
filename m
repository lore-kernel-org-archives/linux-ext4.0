From: Scott James Remnant <scott@ubuntu.com>
Subject: [PATCH] Remove Ubuntu-specific e2fsck.conf file
Date: Thu, 16 Jul 2009 19:27:29 +0100
Message-ID: <E1MRWBp-0000yI-55@zelda.netsplit.com>
Cc: Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:60102 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054AbZGPTBJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jul 2009 15:01:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The problems with a hardware clock in localtime that plagued older
Ubuntu releases have been resolved, and current releases now
correctly set the system clock to UTC even when the hardware clock
is in localtime.

Therefore the config file is unnecessary, and may in fact be masking
other problems.

Signed-off-by: Scott James Remnant <scott@ubuntu.com>
---
 debian/rules              |    6 ------
 e2fsck/e2fsck.conf.ubuntu |    2 --
 2 files changed, 0 insertions(+), 8 deletions(-)
 delete mode 100644 e2fsck/e2fsck.conf.ubuntu

diff --git a/debian/rules b/debian/rules
index 9520b02..f71749e 100755
--- a/debian/rules
+++ b/debian/rules
@@ -406,12 +406,6 @@ binary-arch: install install-udeb
 	$(INSTALL) -p -m 0644 debugfs/debug_cmds.ct \
 		${debdir}/ss-dev/usr/share/doc/libss${SS_SOVERSION}/examples
 
-	if test -f /etc/lsb-release && \
-		grep -q DISTRIB_ID=Ubuntu /etc/lsb-release; then \
-	$(INSTALL) -p -m 0644 e2fsck/e2fsck.conf.ubuntu \
-		${debdir}/e2fsprogs/etc/e2fsck.conf; \
-	fi
