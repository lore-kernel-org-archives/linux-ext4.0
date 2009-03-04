From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix ext4_free_inode vs. ext4_claim_inode race
Date: Wed, 04 Mar 2009 17:11:28 -0600
Message-ID: <49AF0AA0.3080506@redhat.com>
References: <49AE05D1.9050607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54063 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbZCDXLc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Mar 2009 18:11:32 -0500
In-Reply-To: <49AE05D1.9050607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> I was seeing fsck errors on inode bitmaps after a 4 thread
> dbench run on a 4 cpu machine:
>
> Inode bitmap differences: -50736 -(50752--50753) etc...
>
> I believe that this is because ext4_free_inode() uses atomic
> bitops, and although ext4_new_inode() *used* to also use atomic 
> bitops for synchronization, commit 
> 393418676a7602e1d7d3f6e560159c65c8cbd50e changed this to use
> the sb_bgl_lock, so that we could also synchronize against
> read_inode_bitmap and initialization of uninit inode tables.
>
> However, that change left ext4_free_inode using atomic bitops,
> which I think leaves no synchronization between setting & 
> unsetting bits in the inode table.
>
> The below patch fixes it for me, although I wonder if we're 
> getting at all heavy-handed with this spinlock...
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>   
This patch may be a bit faster, though a little trickier.

Basically, we have 2 races to worry about, I think:
* set_bit vs. clear_bit
* set_bit vs. itable init

We don't have to worry about clear_bit vs. itable_init because if
we are clearing an inode, by definition the itable can't be uninit.

So I think we can leave ext4_free_inode() as-is with the atomic
bitops clearing the bitmap, and instead just modify ext4_claim_inode():

The idea is to only take the spinlock if the bg is uninit (using
a test/lock/retest scheme) and if it's not really uninit (meaning
there is no race with the uninit->initialization thread) then
just use the atomic bitops at that point.

This did seem to speed up my dbench testing by a percent or two,
though I should probably do an aggregate of a few more runs to be
sure.

If this is too tricky and could use more soak time, we could live
with the original patch for 2.6.29, I think, while we ponder & test
a better solution to this.

(I need to convince myself that there is no window here yet
between the potentially nonatomic set_bit and the atomic
clear_bit in free_inode... but I think it's ok, as the inode
should not be findable to be freed until new_inode is quite
finished with it.)

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/ialloc.c
+++ linux-2.6/fs/ext4/ialloc.c
@@ -609,26 +609,33 @@ static int ext4_claim_inode(struct super
 			struct buffer_head *inode_bitmap_bh,
 			unsigned long ino, ext4_group_t group, int mode)
 {
-	int free = 0, retval = 0, count;
+	int free = 0, bitset, count;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
 
-	spin_lock(sb_bgl_lock(sbi, group));
-	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
-		/* not a free inode */
-		retval = 1;
-		goto err_ret;
+	/* if uninit, protect against ext4_read_inode_bitmap initialization */
+	bitset = -1;
+	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
+		spin_lock(sb_bgl_lock(sbi, group));
+		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT))
+			bitset = ext4_set_bit(ino, inode_bitmap_bh->b_data);
+		spin_unlock(sb_bgl_lock(sbi, group));
 	}
+	if (bitset < 0) /* we didn't set it above, so not uninit */
+		bitset = ext4_set_bit_atomic(sb_bgl_lock(sbi, group),
+					ino, inode_bitmap_bh->b_data);
+	if (bitset)	/* this is not a free inode */
+		return 1;
 	ino++;
 	if ((group == 0 && ino < EXT4_FIRST_INO(sb)) ||
 			ino > EXT4_INODES_PER_GROUP(sb)) {
-		spin_unlock(sb_bgl_lock(sbi, group));
 		ext4_error(sb, __func__,
 			   "reserved inode or inode > inodes count - "
 			   "block_group = %u, inode=%lu", group,
 			   ino + group * EXT4_INODES_PER_GROUP(sb));
 		return 1;
 	}
+	spin_lock(sb_bgl_lock(sbi, group));
 	/* If we didn't allocate from within the initialized part of the inode
 	 * table then we need to initialize up to this inode. */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
@@ -665,9 +672,8 @@ static int ext4_claim_inode(struct super
 		ext4_used_dirs_set(sb, gdp, count);
 	}
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
-err_ret:
 	spin_unlock(sb_bgl_lock(sbi, group));
-	return retval;
+	return 0;
 }
 
 /*

