From: Will Drewry <redpig@dataspill.org>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Wed, 16 Sep 2009 15:42:25 -0500
Message-ID: <20090916204225.GB84213@freezingfog.local>
References: <20090916162457.GA84213@freezingfog.local> <20090916190831.GH2537@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f190.google.com ([209.85.221.190]:52960 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZIPUrn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2009 16:47:43 -0400
Received: by qyk28 with SMTP id 28so5407327qyk.28
        for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:47:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20090916190831.GH2537@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 16, 2009 at 01:08:31PM -0600, Andreas Dilger wrote:
> On Sep 16, 2009  11:24 -0500, Will Drewry wrote:
> > I have a two questions with an accompanying patch for clarification=
=2E
> >=20
> > resize2fs is uninit_bg aware, but when it is expanding an ext4
> > filesystem, it will always zero the inode tables.  Is it safe to mi=
mick
> > mke2fs's write_inode_table(.., lazy_flag=3D1) and leave the new blo=
ck
> > groups' inode tables marked INODE_UNINIT, BLOCK_UNINIT and _not_ ze=
ro
> > out the inode table if uninit_bg is supported?
> >=20
> > If it is okay, then it means offline resizing upwards can be just a=
s
> > fast as mke2fs.  I've attached a patch which is probably incomplete=
=2E
> > I'd love feedback as to the feasibility of the change and/or patch
> > quality.
> >=20
> > As a follow-on, would it be sane to add support like this for
> > online resizing.  From a cursory investigation, it looks like
> > setup_new_block_groups() could be modified to not zero itables
> > if uninit_bg is supported, and INODE_ZEROED could be replaced
> > with =CE=92G_*_UNINIT.  However, I'm not sure if that is a naive
> > view.  I'm happy to send along a patch illustrating this change
> > if that'd be helpful or welcome.
>=20
> The question is why you would want to risk disk corruption vs.
> the (likely not performance critical) online resize?

I'm interested in it for a few reasons:
1. it undermines the use of uninit_bg on large filesystems as
   e2fsck -f will go back to normal speed, even without those block
   groups being 'used'.  In my local example, it goes from 14s to 2m24s=
=2E

2. it will spread the I/O cost out over time.  Online resizing often
   means that you don't want to/can't unmount the fs.  However, a
   large filesystem increase might result in gigabytes of 0s being
   written to the backing store which could result in I/O throttling
   that makes doing it online less useful.  It'd be nice to be able to
   optionally amortize that cost as is done if the fs had been mke2fs -=
O
   lazy_itable_init=3D1 at full size initially.

3. dm/sparse-file-backed ext4 filesystems end up having the file size
   expanded quite early as init'ing the itables force extra non-sparse
   bytes to be written.  Otherwise, ext4+uninit_bg is a really nice fs
   type for this purpose.

Would it seriously raise the risk of corruption if uninit_bg is already
in use? Alternately, would a patch to that effect stand a chance of eve=
r
making it upstream?

> > Any and all feedback is appreciated -- even if it just for me
> > to look at the archives/link/etc.
> >=20
> > diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> > index 1a5d910..9fcc3b9 100644
> > --- a/resize/resize2fs.c
> > +++ b/resize/resize2fs.c
> > @@ -497,8 +497,7 @@ retry:
> > =20
> >  		fs->group_desc[i].bg_flags =3D 0;
> >  		if (csum_flag)
> > -			fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_UNINIT |
> > -				EXT2_BG_INODE_ZEROED;
> > +			fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_UNINIT;
>=20
> This shouldn't be unconditional, since most users will want the
> safety of having zeroed inode tables.

I've attached a version with it being flagged by a "-l" for lazy.

Thanks for the quick response!
will

Signed-off-by: Will Drewry <redpig@dataspill.org>
---
 resize/main.c         |    7 +++++--
 resize/online.c       |    2 +-
 resize/resize2fs.8.in |    3 +++
 resize/resize2fs.c    |   41 +++++++++++++++++++++++++++++------------
 resize/resize2fs.h    |    5 ++++-
 5 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index 220c192..f04a939 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -39,7 +39,7 @@ char *program_name, *device_name, *io_options;
=20
 static void usage (char *prog)
 {
-	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
+	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-l] [-M] [-=
P] "
 			   "[-p] device [new_size]\n\n"), prog);
=20
 	exit (1);
@@ -189,7 +189,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name =3D *argv;
=20
-	while ((c =3D getopt (argc, argv, "d:fFhMPpS:")) !=3D EOF) {
+	while ((c =3D getopt (argc, argv, "d:fFhlMPpS:")) !=3D EOF) {
 		switch (c) {
 		case 'h':
 			usage(program_name);
@@ -209,6 +209,9 @@ int main (int argc, char ** argv)
 		case 'd':
 			flags |=3D atoi(optarg);
 			break;
+		case 'l':
+			flags |=3D RESIZE_LAZY_INIT;
+			break;
 		case 'p':
 			flags |=3D RESIZE_PERCENT_COMPLETE;
 			break;
diff --git a/resize/online.c b/resize/online.c
index 4bc5451..f0b0569 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -104,7 +104,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const ch=
ar *mtpt,
 	 * but at least it allows on-line resizing to function.
 	 */
 	new_fs->super->s_feature_incompat &=3D ~EXT4_FEATURE_INCOMPAT_FLEX_BG=
;
-	retval =3D adjust_fs_info(new_fs, fs, 0, *new_size);
+	retval =3D adjust_fs_info(new_fs, fs, 0, *new_size, flags);
 	if (retval)
 		return retval;
=20
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index 3ea7a63..020393e 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -102,6 +102,9 @@ really useful for doing
 .B resize2fs
 time trials.
 .TP
+.B \-l
+Lazily initialize new inode tables if supported (uninit_bg).
+.TP
 .B \-M
 Shrink the filesystem to the minimum size.
 .TP
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 1a5d910..fee2e3f 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -41,7 +41,8 @@
 #endif
=20
 static void fix_uninit_block_bitmaps(ext2_filsys fs);
-static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size);
+static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size,
+                                   int flags);
 static errcode_t blocks_to_move(ext2_resize_t rfs);
 static errcode_t block_mover(ext2_resize_t rfs);
 static errcode_t inode_scan_and_fix(ext2_resize_t rfs);
@@ -106,7 +107,7 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size=
, int flags,
 	if (retval)
 		goto errout;
=20
-	retval =3D adjust_superblock(rfs, *new_size);
+	retval =3D adjust_superblock(rfs, *new_size, flags);
 	if (retval)
 		goto errout;
=20
@@ -292,7 +293,7 @@ static void free_gdp_blocks(ext2_filsys fs,
  * filesystem.
  */
 errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
-			 ext2fs_block_bitmap reserve_blocks, blk_t new_size)
+			 ext2fs_block_bitmap reserve_blocks, blk_t new_size, int flags)
 {
 	errcode_t	retval;
 	int		overhead =3D 0;
@@ -496,9 +497,11 @@ retry:
 		adjblocks =3D 0;
=20
 		fs->group_desc[i].bg_flags =3D 0;
-		if (csum_flag)
-			fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_UNINIT |
-				EXT2_BG_INODE_ZEROED;
+		if (csum_flag) {
+			fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_UNINIT;
+			if (!(flags & RESIZE_LAZY_INIT))
+				fs->group_desc[i].bg_flags |=3D EXT2_BG_INODE_ZEROED;
+		}
 		if (i =3D=3D fs->group_desc_count-1) {
 			numblocks =3D (fs->super->s_blocks_count -
 				     fs->super->s_first_data_block) %
@@ -565,10 +568,10 @@ errout:
  * This routine adjusts the superblock and other data structures, both
  * in disk as well as in memory...
  */
-static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
+static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size, =
int flags)
 {
 	ext2_filsys fs;
-	int		adj =3D 0;
+	int		adj =3D 0, csum_flag =3D 0, num =3D 0;
 	errcode_t	retval;
 	blk_t		group_block;
 	unsigned long	i;
@@ -584,7 +587,7 @@ static errcode_t adjust_superblock(ext2_resize_t rf=
s, blk_t new_size)
 	if (retval)
 		return retval;
=20
-	retval =3D adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks, new_s=
ize);
+	retval =3D adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks, new_s=
ize, flags);
 	if (retval)
 		goto errout;
=20
@@ -624,6 +627,9 @@ static errcode_t adjust_superblock(ext2_resize_t rf=
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
@@ -642,10 +648,21 @@ static errcode_t adjust_superblock(ext2_resize_t =
rfs, blk_t new_size)
 		/*
 		 * Write out the new inode table
 		 */
+		if (csum_flag && (flags & RESIZE_LAZY_INIT)) {
+			/* These are _new_ inode tables. No inodes should be in use. */
+			fs->group_desc[i].bg_itable_unused =3D fs->super->s_inodes_per_grou=
p;
+			num =3D ((((fs->super->s_inodes_per_group -
+				  fs->group_desc[i].bg_itable_unused) *
+				 EXT2_INODE_SIZE(fs->super)) +
+				EXT2_BLOCK_SIZE(fs->super) - 1) /
+			       EXT2_BLOCK_SIZE(fs->super));
+		} else {
+			num =3D fs->inode_blocks_per_group;
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
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index fab7290..d4c862c 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -77,6 +77,8 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 #define RESIZE_DEBUG_INODEMAP		0x0004
 #define RESIZE_DEBUG_ITABLEMOVE		0x0008
=20
+#define RESIZE_LAZY_INIT		0x0010
+
 #define RESIZE_PERCENT_COMPLETE		0x0100
 #define RESIZE_VERBOSE			0x0200
=20
@@ -129,7 +131,8 @@ extern errcode_t resize_fs(ext2_filsys fs, blk_t *n=
ew_size, int flags,
=20
 extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
 				ext2fs_block_bitmap reserve_blocks,
-				blk_t new_size);
+				blk_t new_size,
+				int flags);
 extern blk_t calculate_minimum_resize_size(ext2_filsys fs);
=20
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
