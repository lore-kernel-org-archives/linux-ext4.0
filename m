From: Greg KH <gregkh@suse.de>
Subject: [patch 30/39] ext4: mark the blocks/inode bitmap beyond end of
	group as used
Date: Wed, 18 Feb 2009 13:33:11 -0800
Message-ID: <20090218213311.GE19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56359 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757252AbZBRVf5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:57 -0500
Content-Disposition: inline; filename="ext4-mark-the-blocks-inode-bitmap-beyond-end-of-group-as-used.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 648f5879f5892dddd3ba71cd0d285599f40f2512)

We need to mark the block/inode bitmap beyond the end of the group
with '1'.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ialloc.c  |    2 +-
 fs/ext4/mballoc.c |    4 ++--
 fs/ext4/resize.c  |    6 ++----
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -84,7 +84,7 @@ unsigned ext4_init_inode_bitmap(struct s
 	}
 
 	memset(bh->b_data, 0, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
-	mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), EXT4_BLOCKS_PER_GROUP(sb),
+	mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), sb->s_blocksize * 8,
 			bh->b_data);
 
 	return EXT4_INODES_PER_GROUP(sb);
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3036,8 +3036,8 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	    in_range(block + len - 1, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group)) {
 		ext4_error(sb, __func__,
-			   "Allocating block in system zone - block = %llu",
-			   block);
+			   "Allocating block %llu in system zone of %d group\n",
+			   block, ac->ac_b_ex.fe_group);
 		/* File system mounted not to panic on error
 		 * Fix the bitmap and repeat the block allocation
 		 * We leak some of the blocks here.
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -284,11 +284,9 @@ static int setup_new_group_blocks(struct
 	if ((err = extend_or_restart_transaction(handle, 2, bh)))
 		goto exit_bh;
 
-	mark_bitmap_end(input->blocks_count, EXT4_BLOCKS_PER_GROUP(sb),
-			bh->b_data);
+	mark_bitmap_end(input->blocks_count, sb->s_blocksize * 8, bh->b_data);
 	ext4_journal_dirty_metadata(handle, bh);
 	brelse(bh);
