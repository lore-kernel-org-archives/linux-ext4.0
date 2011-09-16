From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 15/25] filefrag: Fix uninitialized "expected" value
Date: Fri, 16 Sep 2011 15:49:30 -0500
Message-ID: <1316206180-6375-16-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46732 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab1IPUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:46 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The "count" variable is only ever set if FIBMAP is used,
due to the -B switch, or a fiemap failure.  However,
we use it unconditionally to calculate "expected" for
extN files, so we can end up printing garbage.

Initialize count to 0, and unless we go through the FIBMAP
path, expected will be 0 as well, and in that case do not
print the message.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/filefrag.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 2795e15..b055c2b 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -272,7 +272,7 @@ static void frag_report(const char *filename)
 #endif
 	int		bs;
 	long		fd;
-	unsigned long	block, last_block = 0, numblocks, i, count;
+	unsigned long	block, last_block = 0, numblocks, i, count = 0;
 	long		bpib;	/* Blocks per indirect block */
 	long		cylgroups;
 	int		num_extents = 0, expected;
@@ -373,8 +373,9 @@ static void frag_report(const char *filename)
 		printf("%s: 1 extent found", filename);
 	else
 		printf("%s: %d extents found", filename, num_extents);
+	/* count, and thus expected, only set for indirect FIBMAP'd files */
 	expected = (count/((bs*8)-(fsinfo.f_files/8/cylgroups)-3))+1;
-	if (is_ext2 && expected < num_extents)
+	if (is_ext2 && expected && expected < num_extents)
 		printf(", perfection would be %d extent%s\n", expected,
 			(expected>1) ? "s" : "");
 	else
-- 
1.7.4.1

