From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Wed, 24 Sep 2008 14:38:42 +0200
Message-ID: <1222259922.3511.6.camel@frecb007923.frec.bull.fr>
References: <1221478895.6733.26.camel@frecb007923.frec.bull.fr>
	 <1221481007.6733.32.camel@frecb007923.frec.bull.fr>
	 <20080915133604.GA6548@skywalker>
	 <1221489026.6733.36.camel@frecb007923.frec.bull.fr>
	 <1221745514.3550.83.camel@frecb007923.frec.bull.fr>
	 <20080921004451.GA15402@mit.edu>
	 <1222070998.3581.25.camel@frecb007923.frec.bull.fr>
	 <20080922084721.GA6691@skywalker>
	 <1222075960.3581.33.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37831 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYIXMiM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Sep 2008 08:38:12 -0400
In-Reply-To: <1222075960.3581.33.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le lundi 22 septembre 2008 =C3=A0 11:32 +0200, Fr=C3=A9d=C3=A9ric Boh=C3=
=A9 a =C3=A9crit :
> Le lundi 22 septembre 2008 =C3=A0 14:17 +0530, Aneesh Kumar K.V a =C3=
=A9crit :
> > What you can do is make ext4_group_info generic for both mballoc an=
d
> > oldalloc. We can then add bg_flag to the in memory ext4_group_info
> > that would indicate whether the group is initialized or not. Here
> > initialized for an UNINIT_GROUP indicate we have done
> > ext4_init_block_bitmap on the buffer_head. Then=20
> > instead of depending on the buffer_head uptodate flag we can check
> > for the ext4_group_info bg_flags and decided whether the block/inod=
e
> > bitmap need to be initialized.
> >=20
>=20
> That makes sense ! I agree with you, we need an additional in-memory
> flag to know whether buffers are initialized or not. Anyway, making
> ext4_group_info generic will lead to unneeded memory consumption for
> oldalloc. Maybe a simple independent bits array could do the trick. I=
s
> there any advantage to re-use ext4_group_info ?
>=20

This is an implementation of what I was talking about. Please let me kn=
ow your comments.

Index: linux-2.6.27-rc6+patch_queue/fs/ext4/balloc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc6+patch_queue.orig/fs/ext4/balloc.c	2008-09-23 15:04=
:39.000000000 +0200
+++ linux-2.6.27-rc6+patch_queue/fs/ext4/balloc.c	2008-09-23 15:39:38.0=
00000000 +0200
@@ -175,6 +175,8 @@ unsigned ext4_init_block_bitmap(struct s
 		 */
 		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
 	}
+
+	ext4_set_bit(block_group, sbi->s_block_bitmap_buffer_state);
 	return free_blocks - ext4_group_used_meta_blocks(sb, block_group);
 }
=20
@@ -318,9 +320,13 @@ ext4_read_block_bitmap(struct super_bloc
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+
+	if (buffer_uptodate(bh) && ext4_test_bit(block_group,
+				EXT4_SB(sb)->s_block_bitmap_buffer_state))
 		return bh;
=20
+	lock_buffer(bh);
+
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		ext4_init_block_bitmap(sb, bh, block_group, desc);
@@ -328,7 +334,9 @@ ext4_read_block_bitmap(struct super_bloc
 		unlock_buffer(bh);
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 		return bh;
-	}
+	} else
+		ext4_set_bit(block_group,
+			      EXT4_SB(sb)->s_block_bitmap_buffer_state);
 	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
Index: linux-2.6.27-rc6+patch_queue/fs/ext4/ext4_sb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc6+patch_queue.orig/fs/ext4/ext4_sb.h	2008-09-23 15:0=
7:28.000000000 +0200
+++ linux-2.6.27-rc6+patch_queue/fs/ext4/ext4_sb.h	2008-09-23 15:40:57.=
000000000 +0200
@@ -147,6 +147,14 @@ struct ext4_sb_info {
=20
 	unsigned int s_log_groups_per_flex;
 	struct flex_groups *s_flex_groups;
+
+	/*
+	 * Flag for the state of the bitmaps buffers
+	 * 0 =3D unknown or uninitialized
+	 * 1 =3D initialized
+	 */
+	char *s_block_bitmap_buffer_state;
+	char *s_inode_bitmap_buffer_state;
 };
=20
 #endif	/* _EXT4_SB */
Index: linux-2.6.27-rc6+patch_queue/fs/ext4/ialloc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc6+patch_queue.orig/fs/ext4/ialloc.c	2008-09-23 15:09=
:15.000000000 +0200
+++ linux-2.6.27-rc6+patch_queue/fs/ext4/ialloc.c	2008-09-23 15:41:24.0=
00000000 +0200
@@ -86,6 +86,7 @@ unsigned ext4_init_inode_bitmap(struct s
 	memset(bh->b_data, 0, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
 	mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), EXT4_BLOCKS_PER_GROUP(sb),
 			bh->b_data);
+	ext4_set_bit(block_group, sbi->s_inode_bitmap_buffer_state);
=20
 	return EXT4_INODES_PER_GROUP(sb);
 }
@@ -115,9 +116,12 @@ ext4_read_inode_bitmap(struct super_bloc
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+
+	if (buffer_uptodate(bh) && ext4_test_bit(block_group,
+				EXT4_SB(sb)->s_inode_bitmap_buffer_state))
 		return bh;
=20
+	lock_buffer(bh);
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
@@ -125,7 +129,9 @@ ext4_read_inode_bitmap(struct super_bloc
 		unlock_buffer(bh);
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 		return bh;
-	}
+	} else
+		ext4_set_bit(block_group,
+				EXT4_SB(sb)->s_inode_bitmap_buffer_state);
 	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
Index: linux-2.6.27-rc6+patch_queue/fs/ext4/mballoc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc6+patch_queue.orig/fs/ext4/mballoc.c	2008-09-23 15:1=
1:48.000000000 +0200
+++ linux-2.6.27-rc6+patch_queue/fs/ext4/mballoc.c	2008-09-24 14:27:55.=
000000000 +0200
@@ -785,9 +785,12 @@ static int ext4_mb_init_cache(struct pag
 		if (bh[i] =3D=3D NULL)
 			goto out;
=20
-		if (bh_uptodate_or_lock(bh[i]))
+		if (buffer_uptodate(bh[i]) && ext4_test_bit(first_group + i,
+				EXT4_SB(sb)->s_block_bitmap_buffer_state))
 			continue;
=20
+		lock_buffer(bh[i]);
+
 		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			ext4_init_block_bitmap(sb, bh[i],
@@ -796,7 +799,9 @@ static int ext4_mb_init_cache(struct pag
 			unlock_buffer(bh[i]);
 			spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 			continue;
-		}
+		} else
+			ext4_set_bit(first_group + i,
+				EXT4_SB(sb)->s_block_bitmap_buffer_state);
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 		get_bh(bh[i]);
 		bh[i]->b_end_io =3D end_buffer_read_sync;
Index: linux-2.6.27-rc6+patch_queue/fs/ext4/super.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc6+patch_queue.orig/fs/ext4/super.c	2008-09-23 15:16:=
15.000000000 +0200
+++ linux-2.6.27-rc6+patch_queue/fs/ext4/super.c	2008-09-24 14:28:42.00=
0000000 +0200
@@ -2219,6 +2219,20 @@ static int ext4_fill_super(struct super_
 		printk(KERN_ERR "EXT4-fs: not enough memory\n");
 		goto failed_mount;
 	}
+	sbi->s_block_bitmap_buffer_state =3D kzalloc((sbi->s_groups_count +
+				    le16_to_cpu(es->s_reserved_gdt_blocks) +
+				    7) / 8, GFP_KERNEL);
+	if (sbi->s_block_bitmap_buffer_state =3D=3D NULL) {
+		printk(KERN_ERR "EXT4-fs: not enough memory\n");
+		goto failed_mount;
+	}
+	sbi->s_inode_bitmap_buffer_state =3D kzalloc((sbi->s_groups_count +
+				    le16_to_cpu(es->s_reserved_gdt_blocks) +
+				    7) / 8, GFP_KERNEL);
+	if (sbi->s_inode_bitmap_buffer_state =3D=3D NULL) {
+		printk(KERN_ERR "EXT4-fs: not enough memory\n");
+		goto failed_mount;
+	}
=20
 	bgl_lock_init(&sbi->s_blockgroup_lock);
=20

=20


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
