From: Dan Carpenter <error27@gmail.com>
Subject: [patch] ext4: off by one check in ext4_groupinfo_create_slab()
Date: Thu, 10 Feb 2011 02:24:12 +0300
Message-ID: <20110209232412.GC4384@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40232 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1BIXYl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 18:24:41 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If cache_index == NR_GRPINFO_CACHES then we read past the end of the
ext4_groupinfo_caches[] array a couple lines later.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 02cff4a..d1fe09a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2438,7 +2438,7 @@ static int ext4_groupinfo_create_slab(size_t size)
 	int cache_index = blocksize_bits - EXT4_MIN_BLOCK_LOG_SIZE;
 	struct kmem_cache *cachep;
 
-	if (cache_index > NR_GRPINFO_CACHES)
+	if (cache_index >= NR_GRPINFO_CACHES)
 		return -EINVAL;
 
 	if (unlikely(cache_index < 0))
