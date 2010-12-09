From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] ext4: Take advantage of kmem_cache_zalloc() in
 ext4_init_io_end()
Date: Thu, 9 Dec 2010 23:17:34 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1012092257290.25880@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13883 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab0LIWYN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Dec 2010 17:24:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Take advantage of kmem_cache_zalloc(). Save a memset() call in 
ext4_init_io_end() and save a few bytes.

Before:
 [jj@dragon linux-2.6]$ size fs/ext4/page-io.o
    text    data     bss     dec     hex filename
    3016       0     624    3640     e38 fs/ext4/page-io.o
After:
 [jj@dragon linux-2.6]$ size fs/ext4/page-io.o
    text    data     bss     dec     hex filename
    3000       0     624    3624     e28 fs/ext4/page-io.o


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 page-io.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index beacce1..0f5dfe0 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -158,11 +158,8 @@ static void ext4_end_io_work(struct work_struct *work)
 
 ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 {
-	ext4_io_end_t *io = NULL;
