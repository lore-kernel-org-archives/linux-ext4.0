From: Greg KH <gregkh@suse.de>
Subject: [patch 37/60] ext4: fix ext4_free_inode() vs.  ext4_claim_inode() race
Date: Tue, 09 Jun 2009 17:14:05 -0700
Message-ID: <20090610002348.220859343@blue.kroah.org>
References: <20090610001328.251476848@blue.kroah.org>
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
	alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57178 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466AbZFJDfs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:48 -0400
Content-Disposition: inline; filename=ext4-fix-ext4_free_inode-vs.-ext4_claim_inode-race.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Sandeen <sandeen@redhat.com>

(cherry picked from commit 7ce9d5d1f3c8736511daa413c64985a05b2feee3)

I was seeing fsck errors on inode bitmaps after a 4 thread
dbench run on a 4 cpu machine:

Inode bitmap differences: -50736 -(50752--50753) etc...

I believe that this is because ext4_free_inode() uses atomic
bitops, and although ext4_new_inode() *used* to also use atomic
bitops for synchronization, commit
393418676a7602e1d7d3f6e560159c65c8cbd50e changed this to use
the sb_bgl_lock, so that we could also synchronize against
read_inode_bitmap and initialization of uninit inode tables.

However, that change left ext4_free_inode using atomic bitops,
which I think leaves no synchronization between setting &
unsetting bits in the inode table.

The below patch fixes it for me, although I wonder if we're
getting at all heavy-handed with this spinlock...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ialloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -188,7 +188,7 @@ void ext4_free_inode (handle_t *handle, 
 	struct ext4_group_desc * gdp;
 	struct ext4_super_block * es;
 	struct ext4_sb_info *sbi;
-	int fatal = 0, err;
+	int fatal = 0, err, cleared;
 	ext4_group_t flex_group;
 
 	if (atomic_read(&inode->i_count) > 1) {
@@ -242,10 +242,12 @@ void ext4_free_inode (handle_t *handle, 
 		goto error_return;
 
 	/* Ok, now we can actually update the inode bitmaps.. */
-	if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
-					bit, bitmap_bh->b_data))
-		ext4_error (sb, "ext4_free_inode",
-			      "bit already cleared for inode %lu", ino);
+	spin_lock(sb_bgl_lock(sbi, block_group));
+	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	spin_unlock(sb_bgl_lock(sbi, block_group));
+	if (!cleared)
+		ext4_error(sb, "ext4_free_inode",
+			   "bit already cleared for inode %lu", ino);
 	else {
 		gdp = ext4_get_group_desc (sb, block_group, &bh2);
 


