From: Lokesh Jaliminche <lokesh.jaliminche@gmail.com>
Subject: Re: [PATCH v3] EXT4: optimizing group serch for inode allocation
Date: Sat, 26 Dec 2015 13:58:58 +0530
Message-ID: <20151226082858.GA4082@server_lokesh.domain.name>
References: <CAKJOkCr-O+37QfFFJgtkRUZfo_-U=qmYy=Ooc7oqtqcVrz1HWQ@mail.gmail.com>
 <9CF60D02-FF10-44FF-A31E-D4E99F627AF2@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34065 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbbLZI3G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Dec 2015 03:29:06 -0500
Received: by mail-pf0-f176.google.com with SMTP id e65so36197053pfe.1
        for <linux-ext4@vger.kernel.org>; Sat, 26 Dec 2015 00:29:05 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <9CF60D02-FF10-44FF-A31E-D4E99F627AF2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

>From 5199982d29ff291b181c25af63a22d6f2d6d3f7b Mon Sep 17 00:00:00 2001
From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
Date: Sat, 26 Dec 2015 13:19:36 +0530
Subject: [PATCH] ext4: optimizing group serch for inode allocation

Added a check at the start of group search loop to
avoid looping unecessarily in case of empty group.
This also allow group search to jump directly to
"found_flex_bg" with "stats" and "group" already set,
so there is no need to go through the extra steps of
setting "best_desc" and "best_group" and then break
out of the loop just to set "stats" and "group" again.

Signed-off-by: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
---
 fs/ext4/ialloc.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1b8024d..16f94db 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -473,10 +473,14 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
        ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);

        if (S_ISDIR(mode) &&
-           ((parent == d_inode(sb->s_root)) ||
-            (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
+               ((parent == d_inode(sb->s_root)) ||
+               (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
+               unsigned int inodes_per_flex_group;
+               unsigned long int clusters_per_flex_group;
                int best_ndir = inodes_per_group;
                int ret = -1;
+               inodes_per_flex_group = inodes_per_group * flex_size;
+               clusters_per_flex_group = sbi->s_clusters_per_group * flex_size;

                if (qstr) {
                        hinfo.hash_version = DX_HASH_HALF_MD4;
@@ -489,6 +493,10 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
                for (i = 0; i < ngroups; i++) {
                        g = (parent_group + i) % ngroups;
                        get_orlov_stats(sb, g, flex_size, &stats);
+                       /* the group can't get any better than empty */
+                       if (inodes_per_flex_group == stats.free_inodes &&
+                               clusters_per_flex_group == stats.free_clusters)
+                               goto found_flex_bg;
                        if (!stats.free_inodes)
                                continue;
                        if (stats.used_dirs >= best_ndir)
-- 
1.7.1

On Mon, Dec 21, 2015 at 10:27:37AM -0700, Andreas Dilger wrote:
> On Dec 18, 2015, at 4:32 PM, lokesh jaliminche <lokesh.jaliminche@gmail.com> wrote:
> > 
> > From 9e09fef78b2fa552c883bf8124af873abfde0805 Mon Sep 17 00:00:00 2001
> > From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@seagate.com>
> 
> In the patch summary there is a typo - s/serch/search/
> 
> Also, it appears your email client has mangled the whitespace in the
> patch.  Please use "git send-email" to send your patch to the list:
> 
>   git send-email --to tytso@mit.edu --cc linux-ext4@vger.kernel.org HEAD~1
> 
> so that it arrives intact.  You probably need to set it up in ~/.gitconfig:
> 
> [sendemail]
>         confirm = compose
>         smtpdomain = {your client hostname}
>         smtpserver = {your SMTP server hostname}
> 
> Cheers, Andreas
> 
> > Added a check at the start of group search loop to
> > avoid looping unecessarily in case of empty group.
> > This also allow group search to jump directly to
> > "found_flex_bg" with "stats" and "group" already set,
> > so there is no need to go through the extra steps of
> > setting "best_desc" and "best_group" and then break
> > out of the loop just to set "stats" and "group" again.
> > 
> > Signed-off-by: Lokesh N Jaliminche <lokesh.jaliminche@gmail.com>
> > ---
> > fs/ext4/ialloc.c |    8 ++++++++
> > 1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index 1b8024d..588bf8e 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -446,6 +446,8 @@ static int find_group_orlov(struct super_block
> > *sb, struct inode *parent,
> >  struct ext4_sb_info *sbi = EXT4_SB(sb);
> >  ext4_group_t real_ngroups = ext4_get_groups_count(sb);
> >  int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
> > + unsigned int inodes_per_flex_group;
> > + long unsigned int blocks_per_clustre;
> >  unsigned int freei, avefreei, grp_free;
> >  ext4_fsblk_t freeb, avefreec;
> >  unsigned int ndirs;
> > @@ -470,6 +472,8 @@ static int find_group_orlov(struct super_block
> > *sb, struct inode *parent,
> >  percpu_counter_read_positive(&sbi->s_freeclusters_counter));
> >  avefreec = freeb;
> >  do_div(avefreec, ngroups);
> > + inodes_per_flex_group = inodes_per_group * flex_size;
> > + blocks_per_clustre = sbi->s_blocks_per_group * flex_size;
> >  ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
> > 
> >  if (S_ISDIR(mode) &&
> > @@ -489,6 +493,10 @@ static int find_group_orlov(struct super_block
> > *sb, struct inode *parent,
> >  for (i = 0; i < ngroups; i++) {
> >  g = (parent_group + i) % ngroups;
> >  get_orlov_stats(sb, g, flex_size, &stats);
> > + /* the group can't get any better than empty */
> > + if (inodes_per_flex_group == stats.free_inodes &&
> > + blocks_per_clustre == stats.free_clusters)
> > + goto found_flex_bg;
> >  if (!stats.free_inodes)
> >  continue;
> >  if (stats.used_dirs >= best_ndir)
> > --
> > 1.7.1
> > <0001-EXT4-optimizing-group-serch-for-inode-allocation.patch>
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 



--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-optimizing-group-serch-for-inode-allocation.patch"

>From 5199982d29ff291b181c25af63a22d6f2d6d3f7b Mon Sep 17 00:00:00 2001
From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
Date: Sat, 26 Dec 2015 13:19:36 +0530
Subject: [PATCH] ext4: optimizing group serch for inode allocation

Added a check at the start of group search loop to
avoid looping unecessarily in case of empty group.
This also allow group search to jump directly to
"found_flex_bg" with "stats" and "group" already set,
so there is no need to go through the extra steps of
setting "best_desc" and "best_group" and then break
out of the loop just to set "stats" and "group" again.

Signed-off-by: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
---
 fs/ext4/ialloc.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1b8024d..16f94db 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -473,10 +473,14 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 
 	if (S_ISDIR(mode) &&
-	    ((parent == d_inode(sb->s_root)) ||
-	     (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
+		((parent == d_inode(sb->s_root)) ||
+		(ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
+		unsigned int inodes_per_flex_group;
+		unsigned long int clusters_per_flex_group;
 		int best_ndir = inodes_per_group;
 		int ret = -1;
+		inodes_per_flex_group = inodes_per_group * flex_size;
+		clusters_per_flex_group = sbi->s_clusters_per_group * flex_size;
 
 		if (qstr) {
 			hinfo.hash_version = DX_HASH_HALF_MD4;
@@ -489,6 +493,10 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 		for (i = 0; i < ngroups; i++) {
 			g = (parent_group + i) % ngroups;
 			get_orlov_stats(sb, g, flex_size, &stats);
+			/* the group can't get any better than empty */
+			if (inodes_per_flex_group == stats.free_inodes &&
+				clusters_per_flex_group == stats.free_clusters)
+				goto found_flex_bg;
 			if (!stats.free_inodes)
 				continue;
 			if (stats.used_dirs >= best_ndir)
-- 
1.7.1


--UlVJffcvxoiEqYs2--
