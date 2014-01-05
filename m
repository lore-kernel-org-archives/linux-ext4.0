From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] test_extents: fix a possible memory leak
Date: Sun,  5 Jan 2014 01:26:42 -0500
Message-ID: <1388903203-5067-3-git-send-email-tytso@mit.edu>
References: <1388903203-5067-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@google.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46013 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaAEG0q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jan 2014 01:26:46 -0500
In-Reply-To: <1388903203-5067-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Ts'o <tytso@google.com>

Addresses-Coverity-Bug: #1049185

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/test_extent.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/resize/test_extent.c b/resize/test_extent.c
index fa3f505..60aa08f 100644
--- a/resize/test_extent.c
+++ b/resize/test_extent.c
@@ -109,6 +109,8 @@ void do_test(FILE *in, FILE *out)
 		} else
 			fputs("# Syntax error\n", out);
 	}
+	if (extent)
+		ext2fs_free_extent_table(extent);
 }
 
 #ifdef __GNUC__
-- 
1.8.5.rc3.362.gdf10213

