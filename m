From: Lokesh Jaliminche <lokesh.jaliminche@gmail.com>
Subject: Re: [PATCH v5] EXT4: optimizing group search for inode allocation
Date: Sun, 17 Jan 2016 04:20:11 +0530
Message-ID: <20160116225011.GA3189@server_lokesh>
References: <CAKJOkCr-O+37QfFFJgtkRUZfo_-U=qmYy=Ooc7oqtqcVrz1HWQ@mail.gmail.com>
 <9CF60D02-FF10-44FF-A31E-D4E99F627AF2@dilger.ca>
 <20151226084153.GA4248@server_lokesh.domain.name>
 <2DA2ED68-7DD4-425D-8A47-E896E9BF0F4A@dilger.ca>
 <20160107004639.GA3902@server_lokesh.domain.name>
 <687935F0-EEA5-4CB6-9E5C-43E49FBB39E2@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36750 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbcAPWuX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jan 2016 17:50:23 -0500
Received: by mail-pf0-f194.google.com with SMTP id n128so9981201pfn.3
        for <linux-ext4@vger.kernel.org>; Sat, 16 Jan 2016 14:50:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <687935F0-EEA5-4CB6-9E5C-43E49FBB39E2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
Date: Thu, 7 Jan 2016 05:12:20 +0530
Subject: [PATCH v5] ext4: optimizing group serch for inode allocation

Added a check at the start of group search loop to
avoid looping unecessarily in case of empty group.
This also allow group search to jump directly to
"found_flex_bg" with "stats" and "group" already set,
so there is no need to go through the extra steps of
setting "best_desc" , "best_group" and then break
out of the loop just to set "stats" and "group" again.

Signed-off-by: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
---
  fs/ext4/ialloc.c |   10 ++++++++++
  1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1b8024d..d2835cc 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -477,6 +477,12 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
	     (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
		int best_ndir = inodes_per_group;
		int ret = -1;
+		/* Maximum usable blocks per group as some blocks are used
+		 * for inode tables and allocation bitmaps */
+			unsigned int max_blocks_per_flex =
+			((sbi->s_blocks_per_group -
+			 (sbi->s_itb_per_group + 2)) *
+			flex_size) >> sbi->s_cluster_bits;

		if (qstr) {
			hinfo.hash_version = DX_HASH_HALF_MD4;
@@ -489,6 +495,10 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
		for (i = 0; i < ngroups; i++) {
			g = (parent_group + i) % ngroups;
			get_orlov_stats(sb, g, flex_size, &stats);
+			/* can't get better group than empty group */
+			if (max_blocks_per_flex == stats.free_clusters &&
+			    (inodes_per_group * flex_size) == stats.free_inodes)
+				goto found_flex_bg;
			if (!stats.free_inodes)
				continue;
			if (stats.used_dirs >= best_ndir)
--.
1.7.1

On Mon, Jan 11, 2016 at 02:13:46PM -0700, Andreas Dilger wrote:
> On Jan 6, 2016, at 5:46 PM, Lokesh Jaliminche <lokesh.jaliminche@gmail.com> wrote:
> > 
> > you are right flex groups cannot be completely empty as some
> > blocks are used for inode table and allocation bitmaps. I
> > missed that point. I have corrected that. Also I have tested
> > and validated this patch by putting some traces it works!
> 
> Good news.  Thanks for updating the patch and testing it.
> More comments below.
> 
> > Here are corresponding logs:
> > commands:
> > =========
> > mkfs.ext4 -g 10000 -G 2 /dev/sdc
> > mount -t ext4  /dev/sdc /mnt/test_ext4/
> > cd /mnt/test_ext4
> > mkdir 1
> > cd 1
> > 
> > logs:
> > =====
> > Jan  7 03:36:45 root kernel: [   64.792939] max_usable_blocks_per_flex_group     =  [19692]
> > Jan  7 03:36:45 root kernel: [   64.792939] stats.free_clusters                  =  [19264]
> > Jan  7 03:36:45 root kernel: [   64.792939] Inodes_per_flex_group                =  [4864]
> > Jan  7 03:36:45 root kernel: [   64.792939] stats.free_inodes                    =  [4853]
> > Jan  7 03:36:45 root kernel: [   64.792950] max_usable_blocks_per_flex_group     =  [19692]
> > Jan  7 03:36:45 root kernel: [   64.792950] stats.free_clusters                  =  [19481]
> > Jan  7 03:36:45 root kernel: [   64.792950] Inodes_per_flex_group                =  [4864]
> > Jan  7 03:36:45 root kernel: [   64.792950] stats.free_inodes                    =  [4864]
> > Jan  7 03:36:45 root kernel: [   64.792958] max_usable_blocks_per_flex_group     =  [19692]
> > Jan  7 03:36:45 root kernel: [   64.792958] stats.free_clusters                  =  [19481]
> > Jan  7 03:36:45 root kernel: [   64.792958] Inodes_per_flex_group                =  [4864]
> > Jan  7 03:36:45 root kernel: [   64.792958] stats.free_inodes                    =  [4864]
> > Jan  7 03:36:45 root kernel: [   64.792965] max_usable_blocks_per_flex_group     =  [19692]
> > Jan  7 03:36:45 root kernel: [   64.792965] stats.free_clusters                  =  [19481]
> > Jan  7 03:36:45 root kernel: [   64.792965] Inodes_per_flex_group                =  [4864]
> > Jan  7 03:36:45 root kernel: [   64.792965] stats.free_inodes                    =  [4864]
> > Jan  7 03:36:45 root kernel: [   64.792972] max_usable_blocks_per_flex_group     =  [19692]
> > Jan  7 03:36:45 root kernel: [   64.792972] stats.free_clusters                  =  [19481]
> > Jan  7 03:36:45 root kernel: [   64.792972] Inodes_per_flex_group                =  [4864]
> > Jan  7 03:36:45 root kernel: [   64.792972] stats.free_inodes                    =  [4864]
> > Jan  7 03:36:45 root kernel: [   64.792979] max_usable_blocks_per_flex_group     =  [19692]<<<<<<<<<<<
> > Jan  7 03:36:45 root kernel: [   64.792979] stats.free_clusters                  =  [19692]<<<<<<<<<<<
> > Jan  7 03:36:45 root kernel: [   64.792979] Inodes_per_flex_group                =  [4864]<<<<<<<<<<<<
> > Jan  7 03:36:45 root kernel: [   64.792979] stats.free_inodes                    =  [4864]<<<<<<<<<<<<
> > Jan  7 03:36:45 root kernel: [   64.792985] found_flex_bg >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>condition satisfied
> > 
> > 
> > [Patch v4]:
> > ==========
> > From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
> > Date: Thu, 7 Jan 2016 05:12:20 +0530
> > Subject: [PATCH] ext4: optimizing group serch for inode allocation
> > 
> > Added a check at the start of group search loop to
> > avoid looping unecessarily in case of empty group.
> > This also allow group search to jump directly to
> > "found_flex_bg" with "stats" and "group" already set,
> > so there is no need to go through the extra steps of
> > setting "best_desc" , "best_group" and then break
> > out of the loop just to set "stats" and "group" again.
> > 
> > Signed-off-by: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
> > ---
> > fs/ext4/ext4.h   |    2 ++
> > fs/ext4/ialloc.c |   21 +++++++++++++++++++--
> > 2 files changed, 21 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index cc7ca4e..fc48f9a 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -326,6 +326,8 @@ struct flex_groups {
> > #define        EXT4_MAX_DESC_SIZE              EXT4_MIN_BLOCK_SIZE
> > #define EXT4_DESC_SIZE(s)              (EXT4_SB(s)->s_desc_size)
> > #ifdef __KERNEL__
> > +# define EXT4_INODE_TABLE_BLOCKS_PER_GROUP(s)  (EXT4_SB(s)->s_itb_per_group)
> > +# define EXT4_BLOCKS_PER_CLUSTER(s)    (EXT4_SB(s)->s_cluster_ratio)
> 
> I don't think there is much value to these macros.  They aren't much
> shorter than the actual variable access, and they don't provide any
> improved clarity for the reader.
> 
> I think they were introduced many years ago so that this header could
> be shared between the kernel and e2fsprogs, but that is no longer true
> so I don't think there is a need to add new ones.
> 
> Ted, any opinion on this?
> 
> > # define EXT4_BLOCKS_PER_GROUP(s)      (EXT4_SB(s)->s_blocks_per_group)
> > # define EXT4_CLUSTERS_PER_GROUP(s)    (EXT4_SB(s)->s_clusters_per_group)
> > # define EXT4_DESC_PER_BLOCK(s)                (EXT4_SB(s)->s_desc_per_block)
> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index 1b8024d..dc66ad8 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -463,7 +463,6 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
> >                        sbi->s_log_groups_per_flex;
> >                parent_group >>= sbi->s_log_groups_per_flex;
> >        }
> > -
> >        freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
> >        avefreei = freei / ngroups;
> 
> Not sure why this line is being deleted?
> 
> > @@ -477,7 +476,20 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
> >             (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
> >                int best_ndir = inodes_per_group;
> >                int ret = -1;
> > -
> > +               /* blocks used for inode table and allocation bitmaps */
> > +               unsigned int max_usable_blocks_per_flex_group;
> 
> This could be shorter and still clear, like "max_blocks_per_flex".
> 
> > +               unsigned int blocks_per_group = EXT4_BLOCKS_PER_GROUP(sb);
> > +               unsigned int inode_table_blocks_per_group = \
> > +                               EXT4_INODE_TABLE_BLOCKS_PER_GROUP(sb);
> > +               /* Number of blocks per cluster */
> > +               unsigned int cluster_ratio = EXT4_BLOCKS_PER_CLUSTER(sb);
> 
> There also isn't much value to making local variables that hold these
> same values again.  It increases stack space for little benefit.  They
> are only accessed once anyway.
> 
> > +               unsigned int inodes_per_flex_group = inodes_per_group * \
> > +                                                       flex_size;
> > +               max_usable_blocks_per_flex_group = \
> > +                                       ((blocks_per_group*flex_size) - \
> 
> Spaces around that '*'.
> 
> > +                                       (inode_table_blocks_per_group * \
> > +                                       flex_size + 2 * flex_size)) / \
> 
> This is C and not a CPP macro, so no need for linefeed escapes.
> 
> > +                                       cluster_ratio;
> 
> This should be ">> EXT4_SB(sb)->s_cluster_bits" to avoid the divide.
> 
> >                if (qstr) {
> >                        hinfo.hash_version = DX_HASH_HALF_MD4;
> >                        hinfo.seed = sbi->s_hash_seed;
> > @@ -489,6 +501,11 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
> >                for (i = 0; i < ngroups; i++) {
> >                        g = (parent_group + i) % ngroups;
> >                        get_orlov_stats(sb, g, flex_size, &stats);
> > +                       /* can't get better group than empty group */
> > +                       if (max_usable_blocks_per_flex_group == \
> > +                               stats.free_clusters && \
> 
> No need for linefeed escapes.
> 
> > +                               inodes_per_flex_group == stats.free_inodes)
> 
> Align continued line after '(' from the "if (" line.
> 
> > +                                       goto found_flex_bg;
> 
> This is indented too much.  It will work properly when you fix the
> previous line.
> 
> >                        if (!stats.free_inodes)
> >                                continue;
> >                        if (stats.used_dirs >= best_ndir)
> > --
> > 1.7.1
> > 
> > Regards,
> > Lokesh
> > 
> > On Sun, Jan 03, 2016 at 11:34:51AM -0700, Andreas Dilger wrote:
> >> On Dec 26, 2015, at 01:41, Lokesh Jaliminche <lokesh.jaliminche@gmail.com> wrote:
> >>> 
> >>> 
> >>> From 5199982d29ff291b181c25af63a22d6f2d6d3f7b Mon Sep 17 00:00:00 2001
> >>> From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
> >>> Date: Sat, 26 Dec 2015 13:19:36 +0530
> >>> Subject: [PATCH v3] ext4: optimizing group search for inode allocation
> >>> 
> >>> Added a check at the start of group search loop to
> >>> avoid looping unecessarily in case of empty group.
> >>> This also allow group search to jump directly to
> >>> "found_flex_bg" with "stats" and "group" already set,
> >>> so there is no need to go through the extra steps of
> >>> setting "best_desc" and "best_group" and then break
> >>> out of the loop just to set "stats" and "group" again.
> >>> 
> >>> Signed-off-by: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
> >>> ---
> >>> fs/ext4/ialloc.c |   12 ++++++++++--
> >>> 1 files changed, 10 insertions(+), 2 deletions(-)
> >>> 
> >>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> >>> index 1b8024d..16f94db 100644
> >>> --- a/fs/ext4/ialloc.c
> >>> +++ b/fs/ext4/ialloc.c
> >>> @@ -473,10 +473,14 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
> >>>       ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
> >>> 
> >>>       if (S_ISDIR(mode) &&
> >>> -           ((parent == d_inode(sb->s_root)) ||
> >>> -            (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
> >>> +               ((parent == d_inode(sb->s_root)) ||
> >>> +               (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
> >> 
> >> I don't understand why you are changing the indentation here?
> >> 
> >>> +               unsigned int inodes_per_flex_group;
> >>> +               unsigned long int clusters_per_flex_group;
> >>>               int best_ndir = inodes_per_group;
> >>>               int ret = -1;
> >>> +               inodes_per_flex_group = inodes_per_group * flex_size;
> >>> +               clusters_per_flex_group = sbi->s_clusters_per_group * flex_size;
> >> 
> >> Have you actually tested if this code works?  When I was looking at this
> >> code I was accidentally looking at the ext2 version, which only deals with
> >> individual groups, and not flex groups.  I don't think that a flex group
> >> can actually be completely empty, since it will always contain at least
> >> an inode table and some bitmaps.
> >> 
> >> This calculation needs to take this into account or it will just be
> >> overhead and not an optimization. Something like:
> >> 
> >>                /* account for inode table and allocation bitmaps */
> >>                clusters_per_flex_group = sbi->s_clusters_per_group * flex_size -
> >>                        ((inodes_per_flex_group * EXT4_INODE_SIZE(sb) +
> >>                          (flex_size << sb->s_blocksize_bits) * 2 ) >>
> >>                        EXT4_SB(sb)->s_cluster_bits;
> >> 
> >> It would be worthwhile to print this out and verify that there are actually
> >> groups with this many free blocks in a newly formatted filesystem.
> >> 
> >> Cheers, Andreas
> >> 
> >>>               if (qstr) {
> >>>                       hinfo.hash_version = DX_HASH_HALF_MD4;
> >>> @@ -489,6 +493,10 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
> >>>               for (i = 0; i < ngroups; i++) {
> >>>                       g = (parent_group + i) % ngroups;
> >>>                       get_orlov_stats(sb, g, flex_size, &stats);
> >>> +                       /* the group can't get any better than empty */
> >>> +                       if (inodes_per_flex_group == stats.free_inodes &&
> >>> +                               clusters_per_flex_group == stats.free_clusters)
> >>> +                               goto found_flex_bg;
> >>>                       if (!stats.free_inodes)
> >>>                               continue;
> >>>                       if (stats.used_dirs >= best_ndir)
> >>> --
> >>> 1.7.1
> >>> 
> >>> 
> >>>> On Mon, Dec 21, 2015 at 10:27:37AM -0700, Andreas Dilger wrote:
> >>>>> On Dec 18, 2015, at 4:32 PM, lokesh jaliminche <lokesh.jaliminche@gmail.com> wrote:
> >>>>> 
> >>>>> From 9e09fef78b2fa552c883bf8124af873abfde0805 Mon Sep 17 00:00:00 2001
> >>>>> From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@seagate.com>
> >>>> 
> >>>> In the patch summary there is a typo - s/serch/search/
> >>>> 
> >>>> Also, it appears your email client has mangled the whitespace in the
> >>>> patch.  Please use "git send-email" to send your patch to the list:
> >>>> 
> >>>> git send-email --to tytso@mit.edu --cc linux-ext4@vger.kernel.org HEAD~1
> >>>> 
> >>>> so that it arrives intact.  You probably need to set it up in ~/.gitconfig:
> >>>> 
> >>>> [sendemail]
> >>>>       confirm = compose
> >>>>       smtpdomain = {your client hostname}
> >>>>       smtpserver = {your SMTP server hostname}
> >>>> 
> >>>> Cheers, Andreas
> >>>> 
> >>>>> Added a check at the start of group search loop to
> >>>>> avoid looping unecessarily in case of empty group.
> >>>>> This also allow group search to jump directly to
> >>>>> "found_flex_bg" with "stats" and "group" already set,
> >>>>> so there is no need to go through the extra steps of
> >>>>> setting "best_desc" and "best_group" and then break
> >>>>> out of the loop just to set "stats" and "group" again.
> >>>>> 
> >>>>> Signed-off-by: Lokesh N Jaliminche <lokesh.jaliminche@gmail.com>
> >>>>> ---
> >>>>> fs/ext4/ialloc.c |    8 ++++++++
> >>>>> 1 files changed, 8 insertions(+), 0 deletions(-)
> >>>>> 
> >>>>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> >>>>> index 1b8024d..588bf8e 100644
> >>>>> --- a/fs/ext4/ialloc.c
> >>>>> +++ b/fs/ext4/ialloc.c
> >>>>> @@ -446,6 +446,8 @@ static int find_group_orlov(struct super_block
> >>>>> *sb, struct inode *parent,
> >>>>> struct ext4_sb_info *sbi = EXT4_SB(sb);
> >>>>> ext4_group_t real_ngroups = ext4_get_groups_count(sb);
> >>>>> int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
> >>>>> + unsigned int inodes_per_flex_group;
> >>>>> + long unsigned int blocks_per_clustre;
> >>>>> unsigned int freei, avefreei, grp_free;
> >>>>> ext4_fsblk_t freeb, avefreec;
> >>>>> unsigned int ndirs;
> >>>>> @@ -470,6 +472,8 @@ static int find_group_orlov(struct super_block
> >>>>> *sb, struct inode *parent,
> >>>>> percpu_counter_read_positive(&sbi->s_freeclusters_counter));
> >>>>> avefreec = freeb;
> >>>>> do_div(avefreec, ngroups);
> >>>>> + inodes_per_flex_group = inodes_per_group * flex_size;
> >>>>> + blocks_per_clustre = sbi->s_blocks_per_group * flex_size;
> >>>>> ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
> >>>>> 
> >>>>> if (S_ISDIR(mode) &&
> >>>>> @@ -489,6 +493,10 @@ static int find_group_orlov(struct super_block
> >>>>> *sb, struct inode *parent,
> >>>>> for (i = 0; i < ngroups; i++) {
> >>>>> g = (parent_group + i) % ngroups;
> >>>>> get_orlov_stats(sb, g, flex_size, &stats);
> >>>>> + /* the group can't get any better than empty */
> >>>>> + if (inodes_per_flex_group == stats.free_inodes &&
> >>>>> + blocks_per_clustre == stats.free_clusters)
> >>>>> + goto found_flex_bg;
> >>>>> if (!stats.free_inodes)
> >>>>> continue;
> >>>>> if (stats.used_dirs >= best_ndir)
> >>>>> --
> >>>>> 1.7.1
> >>>>> <0001-EXT4-optimizing-group-serch-for-inode-allocation.patch>
> >>>> 
> >>>> 
> >>>> Cheers, Andreas
> >>> 
> >>> 
> >>> <0001-ext4-optimizing-group-serch-for-inode-allocation.patch>
> > <0001-ext4-optimizing-group-serch-for-inode-allocation.patch>
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 



--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-optimizing-group-serch-for-inode-allocation.patch"

>From 11eeb037cbeecb82fd2ecb01056c9bfcd8d9d50f Mon Sep 17 00:00:00 2001
From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
Date: Thu, 7 Jan 2016 05:12:20 +0530
Subject: [PATCH] ext4: optimizing group serch for inode allocation

Added a check at the start of group search loop to
avoid looping unecessarily in case of empty group.
This also allow group search to jump directly to
"found_flex_bg" with "stats" and "group" already set,
so there is no need to go through the extra steps of
setting "best_desc" , "best_group" and then break
out of the loop just to set "stats" and "group" again.

Signed-off-by: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
---
 fs/ext4/ialloc.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1b8024d..d2835cc 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -477,6 +477,12 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	     (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
 		int best_ndir = inodes_per_group;
 		int ret = -1;
+		/* Maximum usable blocks per group as some blocks are used
+		 * for inode tables and allocation bitmaps */
+		unsigned int max_blocks_per_flex =
+			((sbi->s_blocks_per_group -
+			  (sbi->s_itb_per_group +  2)) *
+			 flex_size) >>  sbi->s_cluster_bits;
 
 		if (qstr) {
 			hinfo.hash_version = DX_HASH_HALF_MD4;
@@ -489,6 +495,10 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 		for (i = 0; i < ngroups; i++) {
 			g = (parent_group + i) % ngroups;
 			get_orlov_stats(sb, g, flex_size, &stats);
+			/* can't get better group than empty group */
+			if (max_blocks_per_flex == stats.free_clusters &&
+			    (inodes_per_group * flex_size) == stats.free_inodes)
+				goto found_flex_bg;
 			if (!stats.free_inodes)
 				continue;
 			if (stats.used_dirs >= best_ndir)
-- 
1.7.1


--jRHKVT23PllUwdXP--
