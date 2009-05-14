From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Thu, 14 May 2009 17:23:25 -0400
Message-ID: <20090514212325.GG21316@mit.edu>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39386 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbZENVXc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2009 17:23:32 -0400
Content-Disposition: inline
In-Reply-To: <20090514210244.GL5146@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2009 at 06:32:45AM +0930, Kevin Shanahan wrote:
> Okay, so now I've booted into 2.6.29.3 + check_block_validity patch +
> short circuit i_cached_extent patch, mounted the fs without
> nodelalloc. I was able to run the full exchange backup without
> triggering the check_block_validity error.

Great!

So here's the final fix (it replaces the short circuit i_cached_extent
patch) which I plan to push to Linus.  It should be much less of a
performance hit than simply short-circuiting i_cached_extent...

Thanks so much for helping to find track this down!!!  If ever someone
deserved an "Ext4 Baker Street Irregulars" T-shirt, it would be
you....

       	       	   	      	   	      - Ted

commit 039ed7a483fdcb2dbbc29f00cd0d74c101ab14c5
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu May 14 17:09:37 2009 -0400

    ext4: Fix race in ext4_inode_info.i_cached_extent
    
    If one CPU is reading from a file while another CPU is writing to the
    same file different locations, there is nothing protecting the
    i_cached_extent structure from being used and updated at the same
    time.  This could potentially cause the wrong location on disk to be
    read or written to, including potentially causing the corruption of
    the block group descriptors and/or inode table.
    
    Many thanks to Ken Shannah for helping to track down this problem.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 172656c..e3a55eb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1841,11 +1841,13 @@ ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
 {
 	struct ext4_ext_cache *cex;
 	BUG_ON(len == 0);
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	cex = &EXT4_I(inode)->i_cached_extent;
 	cex->ec_type = type;
 	cex->ec_block = block;
 	cex->ec_len = len;
 	cex->ec_start = start;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
 /*
@@ -1902,12 +1904,17 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 			struct ext4_extent *ex)
 {
 	struct ext4_ext_cache *cex;
+	int ret = EXT4_EXT_CACHE_NO;
 
+	/* 
+	 * We borrow i_block_reservation_lock to protect i_cached_extent
+	 */
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	cex = &EXT4_I(inode)->i_cached_extent;
 
 	/* has cache valid data? */
 	if (cex->ec_type == EXT4_EXT_CACHE_NO)
-		return EXT4_EXT_CACHE_NO;
+		goto errout;
 
 	BUG_ON(cex->ec_type != EXT4_EXT_CACHE_GAP &&
 			cex->ec_type != EXT4_EXT_CACHE_EXTENT);
@@ -1918,11 +1925,11 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 		ext_debug("%u cached by %u:%u:%llu\n",
 				block,
 				cex->ec_block, cex->ec_len, cex->ec_start);
-		return cex->ec_type;
+		ret = cex->ec_type;
 	}
