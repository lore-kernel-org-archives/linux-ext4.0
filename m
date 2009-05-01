From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 4/6] [64-bit] enable dumpe2fs 64-bitness and fix printf formats.
Date: Fri, 01 May 2009 04:47:07 -0400
Message-ID: <15579.1241167627@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Theodore Ts'o <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:55713
	"EHLO QMTA14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbZEAIqy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 04:46:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add  EXT2_FLAG_NEW_BITMAPS to the ext2fs_open() flags.

Change signature of print_range(): both arguments of the range
are now unsigned long long, with the concomitant change to the
printf formats.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 misc/dumpe2fs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 8a746ee..4d5c90e 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -63,12 +63,12 @@ static void print_number(unsigned long num)
 		printf("%lu", num);
 }
 
-static void print_range(unsigned long a, unsigned long b)
+static void print_range(unsigned long long a, unsigned long long b)
 {
 	if (hex_format)
-		printf("0x%04lx-0x%04lx", a, b);
+		printf("0x%llx-0x%llx", a, b);
 	else
-		printf("%lu-%lu", a, b);
+		printf("%llu-%llu", a, b);
 }
 
 static void print_free (unsigned long group, char * bitmap,
@@ -481,7 +481,7 @@ int main (int argc, char ** argv)
 	if (optind > argc - 1)
 		usage();
 	device_name = argv[optind++];
-	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES;
+	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_NEW_BITMAPS;
 	if (force)
 		flags |= EXT2_FLAG_FORCE;
 	if (image_dump)
-- 
1.6.0.6

