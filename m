From: Jan Kara <jack@suse.cz>
Subject: [PATCH] libext2fs: Fix fsync(2) detection
Date: Wed,  7 Jun 2017 15:31:14 +0200
Message-ID: <20170607133114.27799-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50831 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751470AbdFGNbW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Jun 2017 09:31:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For some reason lib/config.h.in was missing a definition of HAVE_FSYNC
and as a result lib/config.h never had HAVE_FSYNC defined. As a result
we never called fsync(2) for example from
lib/ext2fs/unix_io.c:unix_flush() when we finished creating filesystem
and could miss IO errors happening during creating of the filesystem.
Test generic/405 exposes this problem.

Fix the problem by defining HAVE_FSYNC in lib/config.h.in.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/config.h.in | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/config.h.in b/lib/config.h.in
index 37d0c461338a..91e869e7d3d7 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -470,6 +470,9 @@
 /* Define to 1 if you have the `sync_file_range' function. */
 #undef HAVE_SYNC_FILE_RANGE
 
+/* Define to 1 if you have the 'fsync' function. */
+#undef HAVE_FSYNC
+
 /* Define to 1 if you have the `sysconf' function. */
 #undef HAVE_SYSCONF
 
-- 
2.12.3
