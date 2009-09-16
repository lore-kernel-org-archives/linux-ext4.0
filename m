From: Will Drewry <redpig@dataspill.org>
Subject: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Wed, 16 Sep 2009 11:24:57 -0500
Message-ID: <20090916162457.GA84213@freezingfog.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:58885 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZIPQZE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2009 12:25:04 -0400
Received: by qw-out-2122.google.com with SMTP id 9so1670190qwb.37
        for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 09:25:07 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi linux-ext4,

I have a two questions with an accompanying patch for clarification.

resize2fs is uninit_bg aware, but when it is expanding an ext4
filesystem, it will always zero the inode tables.  Is it safe to mimick
mke2fs's write_inode_table(.., lazy_flag=3D1) and leave the new block
groups' inode tables marked INODE_UNINIT, BLOCK_UNINIT and _not_ zero
out the inode table if uninit_bg is supported?

If it is okay, then it means offline resizing upwards can be just as
fast as mke2fs.  I've attached a patch which is probably incomplete.
I'd love feedback as to the feasibility of the change and/or patch
quality.

As a follow-on, would it be sane to add support like this for
online resizing.  From a cursory investigation, it looks like
setup_new_block_groups() could be modified to not zero itables
if uninit_bg is supported, and INODE_ZEROED could be replaced
with =CE=92G_*_UNINIT.  However, I'm not sure if that is a naive
view.  I'm happy to send along a patch illustrating this change
if that'd be helpful or welcome.

Any and all feedback is appreciated -- even if it just for me
to look at the archives/link/etc.

Thanks!


Signed-off-by: Will Drewry <redpig@dataspill.org>
---
resize/resize2fs.c |   28 ++++++++++++++++++++++------
1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 1a5d910..9fcc3b9 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -497,8 +497,7 @@ retry:
=20
 		fs->group_desc[i].bg_flags =3D 0;
 		if (csum_flag)
-			fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_UNINIT |
-				EXT2_BG_INODE_ZEROED;
+			fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_UNINIT;
 		if (i =3D=3D fs->group_desc_count-1) {
 			numblocks =3D (fs->super->s_blocks_count -
 				     fs->super->s_first_data_block) %
@@ -568,7 +567,7 @@ errout:
 static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
 {
 	ext2_filsys fs;
-	int		adj =3D 0;
+	int		adj =3D 0, csum_flag =3D 0, num =3D 0;
 	errcode_t	retval;
 	blk_t		group_block;
 	unsigned long	i;
@@ -624,6 +623,9 @@ static errcode_t adjust_superblock(ext2_resize_t rf=
s, blk_t new_size)
 				&rfs->itable_buf);
 	if (retval)
 		goto errout;
+	/* Track if we can get by with a lazy init */
+	csum_flag =3D EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
=20
 	memset(rfs->itable_buf, 0, fs->blocksize * fs->inode_blocks_per_group=
);
 	group_block =3D fs->super->s_first_data_block +
@@ -642,10 +644,24 @@ static errcode_t adjust_superblock(ext2_resize_t =
rfs, blk_t new_size)
 		/*
 		 * Write out the new inode table
 		 */
+		if (csum_flag) {
+			/* These are _new_ inode tables. No inodes should be in use.
+			 * (As per ext2fs_set_gdt_csum) */
+			fs->group_desc[i].bg_itable_unused =3D fs->super->s_inodes_per_grou=
p;
+			num =3D ((((fs->super->s_inodes_per_group -
+				  fs->group_desc[i].bg_itable_unused) *
+				 EXT2_INODE_SIZE(fs->super)) +
+				EXT2_BLOCK_SIZE(fs->super) - 1) /
+			       EXT2_BLOCK_SIZE(fs->super));
+		} else {
+			num =3D fs->inode_blocks_per_group;
+			/* The kernel doesn't need to zero the itable blocks. We will below=
 */
+			fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_ZEROED;
+		}
 		retval =3D io_channel_write_blk(fs->io,
-					      fs->group_desc[i].bg_inode_table,
-					      fs->inode_blocks_per_group,
-					      rfs->itable_buf);
+					      fs->group_desc[i].bg_inode_table, /* blk */
+					      num,  /* count */
+					      rfs->itable_buf);  /* contents */
 		if (retval) goto errout;
=20
 		io_channel_flush(fs->io);
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
