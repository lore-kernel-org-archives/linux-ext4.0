From: Will Drewry <redpig@dataspill.org>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Wed, 23 Sep 2009 14:28:03 -0500
Message-ID: <2359eed20909231228m2050cf65pa9029f931f655b10@mail.gmail.com>
References: <20090916162457.GA84213@freezingfog.local>
	 <20090916190831.GH2537@webber.adilger.int>
	 <20090916204225.GB84213@freezingfog.local>
	 <20090916212250.GL2537@webber.adilger.int>
	 <20090916231131.GC84213@freezingfog.local>
	 <20090919121909.GA1077@freezingfog.local>
	 <20090923093436.GW10562@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:49782 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZIWT2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2009 15:28:02 -0400
Received: by qyk4 with SMTP id 4so779243qyk.33
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 12:28:05 -0700 (PDT)
In-Reply-To: <20090923093436.GW10562@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 23, 2009 at 4:34 AM, Andreas Dilger <adilger@sun.com> wrote=
:
> On Sep 19, 2009 =A007:19 -0500, Will Drewry wrote:
>> @@ -482,6 +482,8 @@ retry:
>>
>> =A0 =A0 =A0 csum_flag =3D EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
>> + =A0 =A0 lazy_flag =3D EXT2_HAS_COMPAT_FEATURE(fs->super,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0EXT2_FEATURE_COMPAT_LAZY_BG);
>> =A0 =A0 =A0 adj =3D old_fs->group_desc_count;
>> =A0 =A0 =A0 max_group =3D fs->group_desc_count - adj;
>> =A0 =A0 =A0 if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPA=
T_META_BG)
>> @@ -496,9 +498,12 @@ retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 adjblocks =3D 0;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->group_desc[i].bg_flags =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (csum_flag)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->group_desc[i].bg_flags=
 |=3D EXT2_BG_INODE_UNINIT |
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2_BG_IN=
ODE_ZEROED;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (csum_flag) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->group_desc[i].bg_flags=
 |=3D EXT2_BG_INODE_UNINIT;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!lazy_flag) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->group_=
desc[i].bg_flags |=3D EXT2_BG_INODE_ZEROED;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>
> This code could be cleaned up a bit by assigning "EXT2_BG_INODE_ZEROE=
D" to
> lazy_flag so that you don't need to check this each time:
>
> =A0 =A0 =A0 =A0lazy_flag =3D EXT2_HAS_COMPAT_FEATURE(fs->super,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0EXT2_FEATURE_COMPAT_LAZY_BG) ?
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_B=
G_INODE_ZEROED : 0;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (csum_flag)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fs->group_desc[i].bg_f=
lags |=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_B=
G_INODE_UNINIT | lazy_flag;
>
> Still waiting to head from Ted on the use of COMPAT_LAZY_BG.

Ah nice - I can definitely do that.  I also think I mangled the spaces
v tabs on the ext4.h part of the patch.  If COMPAT_LAZY_BG is off limit=
s,
I can easily use some other flag/indicator.

That aside, I've also got a barebones kernel patch which supports lazy
online resizing which accompanies the e2fsprogs patch above. I realize
it is probably less-than-practical until there is an initializing
thread, but I'd appreciate any feedback if possible -- even if just to
ensure I'm understanding things correctly.

Thanks!
will


Signed-off-by: Will Drewry <redpig@dataspill.org>
---
fs/ext4/ext4.h   |    1 +
fs/ext4/resize.c |   38 ++++++++++++++++++++++++++++++++++++--
2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9714db3..24d2880 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1043,6 +1043,7 @@ static inline int ext4_valid_inum(struct
super_block *sb, unsigned long ino)
 #define EXT4_FEATURE_COMPAT_EXT_ATTR		0x0008
 #define EXT4_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT4_FEATURE_COMPAT_DIR_INDEX		0x0020
+#define EXT4_FEATURE_COMPAT_LAZY_BG		0x0040

 #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 68b0351..faf9263 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -183,7 +183,7 @@ static int setup_new_group_blocks(struct super_bloc=
k *sb,
 	handle_t *handle;
 	ext4_fsblk_t block;
 	ext4_grpblk_t bit;
-	int i;
+	int i, lazy =3D 0;
 	int err =3D 0, err2;

 	/* This transaction may be extended/restarted along the way */
@@ -261,13 +261,31 @@ static int setup_new_group_blocks(struct super_bl=
ock *sb,
 		   input->inode_bitmap - start);
 	ext4_set_bit(input->inode_bitmap - start, bh->b_data);

-	/* Zero out all of the inode table blocks */
+	/* Zero out all of the inode table blocks except if the fs supports l=
azy
+	 * itables. */
+	lazy =3D EXT4_HAS_RO_COMPAT_FEATURE(sb,
+	         EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	       EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_LAZY_BG);
+	if (lazy) {
+		ext4_debug("lazy_bg for inode blocks "
+			   "%#04llx (+%d) - %#04llx (+%d) ",
+			   input->inode_table, input->inode_table - start,
+			  input->inode_table + sbi->s_itb_per_group - 1,
+			  (input->inode_table - start) + sbi->s_itb_per_group - 1);
+	}
+
 	for (i =3D 0, block =3D input->inode_table, bit =3D block - start;
 	     i < sbi->s_itb_per_group; i++, bit++, block++) {
 		struct buffer_head *it;

 		ext4_debug("clear inode block %#04llx (+%d)\n", block, bit);

+		/* Even though we don't initialize the inode table, we need
+		 * to mark the blocks used by it for later init. */
+		if (lazy) {
+			ext4_set_bit(bit, bh->b_data);
+			continue;
+		}
 		if ((err =3D extend_or_restart_transaction(handle, 1, bh)))
 			goto exit_bh;

@@ -286,6 +304,11 @@ static int setup_new_group_blocks(struct super_blo=
ck *sb,
 	mark_bitmap_end(input->blocks_count, sb->s_blocksize * 8, bh->b_data)=
;
 	ext4_handle_dirty_metadata(handle, NULL, bh);
 	brelse(bh);
+	/* If lazy, we're done since we are marked INODE_UNINIT and that
+	 * includes the inode bitmap. (ext4_init_inode_bitmap will do
+	 * this for us later). */
+	if (lazy)
+		goto exit_journal;
 	/* Mark unused entries in inode bitmap used */
 	ext4_debug("clear inode bitmap %#04llx (+%llu)\n",
 		   input->inode_bitmap, input->inode_bitmap - start);
@@ -868,6 +891,17 @@ int ext4_group_add(struct super_block *sb, struct
ext4_new_group_data *input)
 	ext4_free_blks_set(sb, gdp, input->free_blocks_count);
 	ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
 	gdp->bg_flags =3D cpu_to_le16(EXT4_BG_INODE_ZEROED);
+	/* If we can do lazy initialization, we do. */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &=
&
+	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_LAZY_BG)) {
+		/* Only use EXT4_BG_INODE_UNINIT and not BLOCK_UNINIT
+		 * because we purposefully initialize the block bitmaps
+		 * to avoid managing super block backup decisions, making
+		 * sure the last block is init'd, etc.
+		 */
+		gdp->bg_flags =3D cpu_to_le16(EXT4_BG_INODE_UNINIT);
+		ext4_itable_unused_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
+	}
 	gdp->bg_checksum =3D ext4_group_desc_csum(sbi, input->group, gdp);

 	/*
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
