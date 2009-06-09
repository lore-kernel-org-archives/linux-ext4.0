From: Greg KH <gregkh@suse.de>
Subject: [patch 87/87] ext4: Fix race in ext4_inode_info.i_cached_extent
Date: Tue, 09 Jun 2009 02:40:15 -0700
Message-ID: <20090609094112.789197843@blue.kroah.org>
References: <20090609093848.204935043@blue.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:32952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001AbZFIKWf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 06:22:35 -0400
Content-Disposition: inline; filename=ext4-fix-race-in-ext4_inode_info.i_cached_extent.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 2ec0ae3acec47f628179ee95fe2c4da01b5e9fc4)

If two CPU's simultaneously call ext4_ext_get_blocks() at the same
time, there is nothing protecting the i_cached_extent structure from
being used and updated at the same time.  This could potentially cause
the wrong location on disk to be read or written to, including
potentially causing the corruption of the block group descriptors
and/or inode table.

This bug has been in the ext4 code since almost the very beginning of
ext4's development.  Fortunately once the data is stored in the page
cache cache, ext4_get_blocks() doesn't need to be called, so trying to
replicate this problem to the point where we could identify its root
cause was *extremely* difficult.  Many thanks to Kevin Shanahan for
working over several months to be able to reproduce this easily so we
could finally nail down the cause of the corruption.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1740,11 +1740,13 @@ ext4_ext_put_in_cache(struct inode *inod
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
@@ -1801,12 +1803,17 @@ ext4_ext_in_cache(struct inode *inode, e
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
@@ -1817,11 +1824,11 @@ ext4_ext_in_cache(struct inode *inode, e
 		ext_debug("%u cached by %u:%u:%llu\n",
 				block,
 				cex->ec_block, cex->ec_len, cex->ec_start);
-		return cex->ec_type;
+		ret = cex->ec_type;
 	}
