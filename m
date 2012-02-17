From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] e2image: attempt to use ftruncate64 to set i_size for raw images
Date: Fri, 17 Feb 2012 09:32:43 -0500
Message-ID: <1329489163-21918-2-git-send-email-tytso@mit.edu>
References: <20120217143026.GA19606@thunk.org>
 <1329489163-21918-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55879 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab2BQOcq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 09:32:46 -0500
In-Reply-To: <1329489163-21918-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ftruncate64() exists, try to use it to set i_size.  This isn't
guaranteed to work, per SuSv3, but if it doesn't work, it's guaranteed
to return an error.  So for file systems and/or operating systems that
don't support extending i_size via ftruncate64(), then fall back to
writing the trailing null.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2image.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index 3cb92fe..90d69ec 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -510,6 +510,16 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 			}
 		}
 	}
+#ifdef HAVE_FTRUNCATE64
+	if (sparse) {
+		ext2_loff_t offset = ext2fs_llseek(fd, sparse, SEEK_CUR);
+
+		if (offset > 0 &&
+		    ftruncate64(fd, offset) < 0)
+			write_block(fd, zero_buf, -1, 1, -1);
+		sparse = 0;
+	}
+#endif
 	if (sparse)
 		write_block(fd, zero_buf, sparse-1, 1, -1);
 	ext2fs_free_mem(&zero_buf);
-- 
1.7.9.107.g97f9a

