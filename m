From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] blkid: fix ZFS device detection
Date: Thu, 18 Feb 2016 13:05:57 -0700
Message-ID: <1455825957-42143-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.139]:53671 "EHLO
	smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1426363AbcBRUOI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Feb 2016 15:14:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While the main blkid functionality is in util-linux, there is still
some use for blkid on non-Linux platforms.

Fix the ZFS device detection by looking at multiple uberblocks to
see if any are present, rather than looking for the ZFS boot block
which is not always present.

There are slots for up to 128 uberblocks, but the first 4 are not
written to disk on a newly-formatted filesystem so check several
of them at different offsets within the uberblock array.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 lib/blkid/probe.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 4b797ab..161f4f1 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -1440,10 +1440,19 @@ static struct blkid_magic type_array[] = {
   { "iso9660",	32,	 1,  5, "CD001",		probe_iso9660 },
   { "iso9660",	32,	 9,  5, "CDROM",		probe_iso9660 },
   { "jfs",	32,	 0,  4, "JFS1",			probe_jfs },
-  { "zfs",       8,	 0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", probe_zfs },
-  { "zfs",       8,	 0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", probe_zfs },
-  { "zfs",     264,	 0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", probe_zfs },
-  { "zfs",     264,	 0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", probe_zfs },
+  /* ZFS has 128 root blocks (#4 is the first used), check only 6 of them */
+  { "zfs",     128,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     128,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     132,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     132,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     136,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     136,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     384,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     384,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     388,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     388,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     392,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     392,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
   { "hfsplus",	 1,	 0,  2, "BD",			probe_hfsplus },
   { "hfsplus",	 1,	 0,  2, "H+",			probe_hfsplus },
   { "hfsplus",	 1,	 0,  2, "HX",			probe_hfsplus },
-- 
1.8.0

