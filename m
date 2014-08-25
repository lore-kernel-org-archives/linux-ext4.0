From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] dumpe2fs: complain if extra arguments are given on the command line
Date: Sun, 24 Aug 2014 23:59:48 -0400
Message-ID: <1408939192-22656-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47272 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbaHYD75 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 23:59:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Debian-Bug: #758074

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/dumpe2fs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index cc18ad8..1eae5a3 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -575,8 +575,10 @@ int main (int argc, char ** argv)
 			usage();
 		}
 	}
-	if (optind > argc - 1)
+	if (argc - 1 > optind) {
 		usage();
+		exit(1);
+	}
 	device_name = argv[optind++];
 	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
 	if (force)
-- 
2.1.0

