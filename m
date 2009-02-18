From: Greg KH <gregkh@suse.de>
Subject: [patch 26/39] ext4: Fix race between read_block_bitmap() and
	mark_diskspace_used()
Date: Wed, 18 Feb 2009 13:33:03 -0800
Message-ID: <20090218213303.GA19814@kroah.com>
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
Received: from kroah.org ([198.145.64.141]:56323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757217AbZBRVfw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:52 -0500
Content-Disposition: inline; filename="ext4-fix-race-between-read_block_bitmap-and-mark_diskspace_used.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit e8134b27e351e813414da3b95aa8eac6d3908088)

We need to make sure we update the block bitmap and clear
EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held, since
ext4_read_block_bitmap() looks at EXT4_BG_BLOCK_UNINIT to decide
whether to initialize the block bitmap each time it is called
(introduced by commit c806e68f), and this can race with block
allocations in ext4_mb_mark_diskspace_used().

ext4_read_block_bitmap does:

spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
	ext4_init_block_bitmap(sb, bh, block_group, desc);

Now on the block allocation side we do

mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
			ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
....
spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
	gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);

ie on allocation we update the bitmap then we take the sb_bgl_lock
and clear the EXT4_BG_BLOCK_UNINIT flag. What can happen is a
parallel ext4_read_block_bitmap can zero out the bitmap in between
the above mb_set_bits and spin_lock(sb_bg_lock..)

The race results in below user visible errors
EXT4-fs error (device sdb1): ext4_mb_release_inode_pa: free 100, pa_free 105
EXT4-fs error (device sdb1): mb_free_blocks: double-free of inode 0's block ..

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1070,7 +1070,10 @@ static void mb_clear_bits(spinlock_t *lo
 			cur += 32;
 			continue;
 		}
-		mb_clear_bit_atomic(lock, cur, bm);
+		if (lock)
+			mb_clear_bit_atomic(lock, cur, bm);
+		else
+			mb_clear_bit(cur, bm);
 		cur++;
 	}
 }
@@ -1088,7 +1091,10 @@ static void mb_set_bits(spinlock_t *lock
 			cur += 32;
 			continue;
 		}
-		mb_set_bit_atomic(lock, cur, bm);
+		if (lock)
+			mb_set_bit_atomic(lock, cur, bm);
+		else
+			mb_set_bit(cur, bm);
 		cur++;
 	}
 }
@@ -3033,10 +3039,9 @@ ext4_mb_mark_diskspace_used(struct ext4_
 		}
 	}
 #endif
-	mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
-				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
