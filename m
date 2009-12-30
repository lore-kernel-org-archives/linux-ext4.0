From: tytso@mit.edu
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Date: Wed, 30 Dec 2009 00:37:20 -0500
Message-ID: <20091230053720.GK4429@thunk.org>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
 <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
 <87hbrfdylc.fsf@openvz.org>
 <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
 <87eimir4yk.fsf@openvz.org>
 <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
 <20091227225216.GB4429@thunk.org>
 <a4423d670912271502n13957e8boc168fdc75444dc09@mail.gmail.com>
 <20091228035159.GC4429@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Alexander Beregalov <a.beregalov@gmail.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46671 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZL3Fhb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Dec 2009 00:37:31 -0500
Content-Disposition: inline
In-Reply-To: <20091228035159.GC4429@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 27, 2009 at 10:51:59PM -0500, tytso@MIT.EDU wrote:
> OK, i've been able to reproduce the problem using xfsqa test #74
> (fstest) when an ext3 file system is mounted the ext4 file system
> driver.  I was then able to bisect it down to commit d21cd8f6, which
> was introduced between 2.6.33-rc1 and 2.6.33-rc2, as part of
> quota/ext4 patch series pushed by Jan.

OK, here's a patch which I think should avoid the BUG in
fs/ext4/inode.c.  It should fix the regression, but in the long run we
need to pretty seriously rethink how we account for the need for
potentially new meta-data blocks when doing delayed allocation.

The remaining problem with this machinery is that
ext4_da_update_reserve_space() and ext4_da_release_space() is that
they both try to calculate how many metadata blocks will potentially
required by calculating ext4_calc_metadata_amount() based on the
number of delayed allocation blocks found in i_reserved_data_blocks.
The problem is that ext4_calc_metadata_amount() assumes that the
number of blocks passed to it is contiguous, and what might be left
remaining to be written in the page cache could be anything but
contiguous.  This is a problem which has always been there, so it's
not a regression per se; just a design flaw.

The patch below should fixes the regression caused by commit d21cd8f,
but we need to look much more closely to find a better way of
accounting for the potential need for metadata for inodes facing
delayed allocation.  Could people who are having problems with the BUG
in line 1063 of fs/ext4/inode.c try this patch?

Thanks!!

    	      	       		    	   - Ted


commit 48b71e562ecd35ab12f6b6420a92fb3c9145da92
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Dec 30 00:04:04 2009 -0500

    ext4: Patch up how we claim metadata blocks for quota purposes
    
    Commit d21cd8f triggered a BUG in the function
    ext4_da_update_reserve_space() found in fs/ext4/inode.c, which was
    caused by fact that ext4_calc_metadata_amount() can over-estimate how
    many metadata blocks will be needed, especially when using direct
    block-mapped files.  Work around this by not claiming any excess
    metadata blocks than we are prepared to claim at this point.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e3b454..d6e84b4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1058,14 +1058,23 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
 
 	if (mdb_free) {
-		/* Account for allocated meta_blocks */
+		/* 
+		 * Account for allocated meta_blocks; it is possible
+		 * for us to have allocated more meta blocks than we
+		 * are prepared to free at this point.  This is
+		 * because ext4_calc_metadata_amount can over-estimate
+		 * how many blocks are still needed.  So we may not be
+		 * able to claim all of the allocated meta blocks
+		 * right away.  The accounting will work out in the end...
+		 */
 		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
-		BUG_ON(mdb_free < mdb_claim);
+		if (mdb_free < mdb_claim)
+			mdb_claim = mdb_free;
 		mdb_free -= mdb_claim;
 
 		/* update fs dirty blocks counter */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
-		EXT4_I(inode)->i_allocated_meta_blocks = 0;
+		EXT4_I(inode)->i_allocated_meta_blocks -= mdb_claim;
 		EXT4_I(inode)->i_reserved_meta_blocks = mdb;
 	}
 
@@ -1845,7 +1854,7 @@ repeat:
 static void ext4_da_release_space(struct inode *inode, int to_free)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int total, mdb, mdb_free, release;
+	int total, mdb, mdb_free, mdb_claim, release;
 
 	if (!to_free)
 		return;		/* Nothing to release, exit */
@@ -1874,6 +1883,16 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
 
+	if (mdb_free) {
+		/* Account for allocated meta_blocks */
+		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
+		if (mdb_free < mdb_claim)
+			mdb_claim = mdb_free;
+		mdb_free -= mdb_claim;
+
+		EXT4_I(inode)->i_allocated_meta_blocks -= mdb_claim;
+	}
+
 	release = to_free + mdb_free;
 
 	/* update fs dirty blocks counter for truncate case */
