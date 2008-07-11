From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] e2fsprogs : Fix memory leak in ext2fs_initialize.
Date: Fri, 11 Jul 2008 16:02:06 +0530
Message-ID: <ea11fea30807110332n459593eay3ce43cca67d5c676@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:20805 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYGKKcH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 06:32:07 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3563195wfd.4
        for <linux-ext4@vger.kernel.org>; Fri, 11 Jul 2008 03:32:07 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In function ext2fs_initialize(), if we fail doing
ext2fs_allocate_block_bitmap() or ext2fs_allocate_inode_bitmap() we
directly goto cleanup and
don't free the memory allocated to buf. Below patch fixes it.

===========================================================

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 lib/ext2fs/initialize.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 011656f..a8375d9 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -105,7 +105,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	int		rsv_gdt;
 	int		csum_flag;
 	int		io_flags;
-	char		*buf;
+	char		*buf = 0;
 	char		c;

 	if (!param || !param->s_blocks_count)
@@ -429,6 +429,9 @@ ipg_retry:
 	*ret_fs = fs;
 	return 0;
 cleanup:
+	if (buf) {
+	 ext2fs_free_mem(&buf);
+	}
 	ext2fs_free(fs);
 	return retval;
 }
-- 
1.5.4.3


===========================================================

-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
