From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Mon, 17 Mar 2014 10:23:57 -0700
Message-ID: <20140317172357.GH9070@birch.djwong.org>
References: <20140315214029.GA18873@thunk.org>
 <CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
 <20140316023841.GA902@thunk.org>
 <CAG5DWog0BDHTh1edtQ+457SmJeL_0MacgZ1gYeNL4sY4yEqZWw@mail.gmail.com>
 <20140316161637.GA19885@azat>
 <20140316184634.GA14162@thunk.org>
 <20140316205659.GC19885@azat>
 <20140317020029.GC14162@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: a3at.mail@gmail.com,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25497 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaCQRYC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2014 13:24:02 -0400
Content-Disposition: inline
In-Reply-To: <20140317020029.GC14162@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 16, 2014 at 10:00:30PM -0400, tytso@mit.edu wrote:
> On Mon, Mar 17, 2014 at 12:56:59AM +0400, a3at.mail@gmail.com wrote:
> > After I tested ext4 dev branch (eb3e7abb161ad5), without any xfs-tests complaints,
> > I understand what goes wrong, you have not last version of
> > this patch, the latest is v3.
> > (Actually you have description from last patch, but not the latest changes.)
> 
> What I did was to take your v3 version of the patch, and then since
> that patch removed the label failed_mount5, I changed instances of
> failed_mount4a to failed_mount5, just for aesthetic reasons.

/me wonders if it would be easier just to do something like this:

ext4: don't crash when validating block bitmap

If EXT4FS_DEBUG is defined, ext4_validate_block_bitmap is called via
ext4_count_free_clusters before sb->s_group_info is set up.  When this
happens, the kernel crashes because group info hasn't been loaded.
Forego marking the group corrupt for now; not setting BH_Verified
means we'll revisit the bitmap if something went wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/balloc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 2f35689..b375768 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -355,7 +355,10 @@ void ext4_validate_block_bitmap(struct super_block *sb,
 			       struct buffer_head *bh)
 {
 	ext4_fsblk_t	blk;
-	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
+	struct ext4_group_info *grp = NULL;
+
+	if (EXT4_SB(sb)->s_group_info)
+		grp = ext4_get_group_info(sb, block_group);
 
 	if (buffer_verified(bh))
 		return;
@@ -366,14 +369,18 @@ void ext4_validate_block_bitmap(struct super_block *sb,
 		ext4_unlock_group(sb, block_group);
 		ext4_error(sb, "bg %u: block %llu: invalid block bitmap",
 			   block_group, blk);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		if (grp)
+			set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
+				&grp->bb_state);
 		return;
 	}
 	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
 			desc, bh))) {
 		ext4_unlock_group(sb, block_group);
 		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		if (grp)
+			set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
+				&grp->bb_state);
 		return;
 	}
 	set_buffer_verified(bh);
