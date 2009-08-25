From: Pavel Machek <pavel@ucw.cz>
Subject: [patch] document that ext2 can't handle barriers
Date: Wed, 26 Aug 2009 00:27:23 +0200
Message-ID: <20090825222723.GC4300__10521.465217653$1251239283$gmane$org@elf.ucw.cz>
References: <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40569 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbZHYW1c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 18:27:32 -0400
Content-Disposition: inline
In-Reply-To: <20090825161110.GP17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Document things ext2 expects from storage filesystems, and the fact
that it can not handle barriers. Also remove jounaling description, as
that's really ext3 material.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
index 67639f9..e300ca8 100644
--- a/Documentation/filesystems/ext2.txt
+++ b/Documentation/filesystems/ext2.txt
@@ -338,27 +339,17 @@ enough 4-character names to make up unique directory entries, so they
 have to be 8 character filenames, even then we are fairly close to
 running out of unique filenames.
 
+Requirements
+============
+
+Ext2 expects disk/storage subsystem not to return write errors.
+
+It also needs write caching to be disabled for reliable fsync
+operation; ext2 does not know how to issue barriers as of
+2.6.31. hdparm -W0 disables it on SATA disks.
+
 Journaling
-----------
-
-A journaling extension to the ext2 code has been developed by Stephen
-Tweedie.  It avoids the risks of metadata corruption and the need to
-wait for e2fsck to complete after a crash, without requiring a change
-to the on-disk ext2 layout.  In a nutshell, the journal is a regular
-file which stores whole metadata (and optionally data) blocks that have
-been modified, prior to writing them into the filesystem.  This means
-it is possible to add a journal to an existing ext2 filesystem without
-the need for data conversion.
