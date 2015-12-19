From: lokesh <lokesh.jaliminche@gmail.com>
Subject: Re: Regarding random grouop search start for allocation of inode.
Date: Sat, 19 Dec 2015 10:39:43 +0530
Message-ID: <20151219050943.GB23494@server_lokesh.domain.name>
References: <CAKJOkCrU7b3XLKHFUS-_eyZ9Lvh7XoPcU15pjAs+qGy2o6XA-w@mail.gmail.com>
 <CAKJOkCoZExQv6mNMQ7kM_ihQ4B41WoNQJYF+pOhXKJLg-OOt+Q@mail.gmail.com>
 <ED92218E-3E81-456C-A6C6-37C2D32AD06B@dilger.ca>
 <CAKJOkCr7fsyTxCxPivOp9-0MsbPL0nMQCnAcGUjd=gDq7zS6uQ@mail.gmail.com>
 <AB526984-C3CC-4EBF-BF17-D7AAE33F2337@dilger.ca>
 <CAKJOkCr5W-=9hu_pq9jvJ_+Fr_sjfNHK_d6vg+Oa5TeF0rHMMA@mail.gmail.com>
 <9260CD06-FEF8-4312-84CE-DA5053979297@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34627 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbbLSLOl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Dec 2015 06:14:41 -0500
Received: by mail-pf0-f193.google.com with SMTP id u7so3111836pfb.1
        for <linux-ext4@vger.kernel.org>; Sat, 19 Dec 2015 03:14:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <9260CD06-FEF8-4312-84CE-DA5053979297@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46rom 9e09fef78b2fa552c883bf8124af873abfde0805 Mon Sep 17 00:00:00 200=
1
=46rom: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
Date: Sat, 19 Dec 2015 00:33:06 +0530
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
 fs/ext4/ialloc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1b8024d..588bf8e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -446,6 +446,8 @@ static int find_group_orlov(struct super_block *sb,=
 struct inode *parent,
 	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
 	ext4_group_t real_ngroups =3D ext4_get_groups_count(sb);
 	int inodes_per_group =3D EXT4_INODES_PER_GROUP(sb);
+	unsigned int inodes_per_flex_group;
+	long unsigned int blocks_per_clustre;
 	unsigned int freei, avefreei, grp_free;
 	ext4_fsblk_t freeb, avefreec;
 	unsigned int ndirs;
@@ -470,6 +472,8 @@ static int find_group_orlov(struct super_block *sb,=
 struct inode *parent,
 		percpu_counter_read_positive(&sbi->s_freeclusters_counter));
 	avefreec =3D freeb;
 	do_div(avefreec, ngroups);
+	inodes_per_flex_group =3D inodes_per_group * flex_size;
+	blocks_per_clustre =3D sbi->s_blocks_per_group * flex_size;
 	ndirs =3D percpu_counter_read_positive(&sbi->s_dirs_counter);
=C2=B7
 	if (S_ISDIR(mode) &&
@@ -489,6 +493,10 @@ static int find_group_orlov(struct super_block *sb=
, struct inode *parent,
 		for (i =3D 0; i < ngroups; i++) {
 			g =3D (parent_group + i) % ngroups;
 			get_orlov_stats(sb, g, flex_size, &stats);
+			/* the group can't get any better than empty */
+			if (inodes_per_flex_group =3D=3D stats.free_inodes &&
+				blocks_per_clustre =3D=3D stats.free_clusters)
+					goto found_flex_bg;
 			if (!stats.free_inodes)
 				continue;
 			if (stats.used_dirs >=3D best_ndir)
--
1.7.1
On Tue, Dec 15, 2015 at 02:32:52PM -0700, Andreas Dilger wrote:
> On Dec 15, 2015, at 3:33 AM, lokesh jaliminche <lokesh.jaliminche@gma=
il.com> wrote:
> >=20
> > "No, this isn't correct.  This loop is looking for the *best* group=
 it
> > can find, and your "break" would have it exit the loop as soon as t=
he
> > *first* group that matches the conditions is found."
> >=20
> > But as we are checking  all the groups with the same conditions the=
n
> > how it guarantees better group selection ? As per my understanding =
 we
> > are just wasting time in looping.
>=20
> The important part of the loop is ensuring that the selected group is=
 always
> improving over the previous one:
>=20
> 			if (le16_to_cpu(desc->bg_used_dirs_count) >=3D best_ndir)
>                                 continue;
>=20
> The "best_ndir" value tracks for the best group found so far the numb=
er of
> used directories in the group, and if the new directory has fewer dir=
ectories
> than the  previous "best" directory and still meets all the other cri=
teria
> (fewer than average inodes allocated, etc) then the new group will be=
 chosen.
>=20
> That said, you are correct that the loop can spend a lot of time sear=
ching
> needlessly.  It would be trivial to add a check at the start of the l=
oop:
>=20
> 			/* the group can't get any better than empty */
> 			if (desc->bg_free_inodes_count =3D=3D inodes_per_group &&
> 			    desc->bg_free_blocks_count =3D=3D
> 						EXT4_BLOCKS_PER_GROUP(sb))
> 				goto found;
>=20
> This jumps directly to "found" with "desc" and "group" already set, s=
o
> there is no need to go through the extra steps of setting "best_desc"=
 and
> "best_group" and then break out of the loop just to set "desc" and "g=
roup"
> again.
>=20
> Since you are the one to find this optimization, could you please sub=
mit a
> patch to this effect so you get the credit.
>=20
> Cheers, Andreas
>=20
> > On Sat, Dec 5, 2015 at 3:24 AM, Andreas Dilger <adilger@dilger.ca> =
wrote:
> >>=20
> >>> On Dec 3, 2015, at 12:13 PM, lokesh jaliminche <lokesh.jaliminche=
@gmail.com> wrote:
> >>>=20
> >>> Ohh thanks for the clarification. There is one more thing I would=
 like
> >>> to point out here.
> >>> In the code there  is a loop to scan the groups for inode
> >>> alllocation(Inside find_group_orlov function).
> >>> There are some policies for group selection . while scanning the
> >>> groups, it checks for these
> >>> policies to be satisfied.
> >>> If a particular group satisfy these properties it should get sele=
cted
> >>> for inode allocation but instead
> >>> it does further lookup in next groups.
> >>> I think there is missing breaking condition. I have added break o=
ver
> >>> there and here is the
> >>> patch for that. Any reason for not having break condition over he=
re ?
> >>>=20
> >>> diff -Nur linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c
> >>> linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c
> >>> --- linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c    2014-04-=
12
> >>> 01:20:31.000000000 +0530
> >>> +++ linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c    2015-11-=
29
> >>> 21:36:51.805542209 +0530
> >>> @@ -529,6 +529,7 @@
> >>>            grp =3D g;
> >>>            ret =3D 0;
> >>>            best_ndir =3D stats.used_dirs;
> >>> +            break;
> >>>        }
> >>>        if (ret)
> >>>        goto fallback;
> >>=20
> >> No, this isn't correct.  This loop is looking for the *best* group=
 it can find,
> >> and your "break" would have it exit the loop as soon as the *first=
* directory
> >> that matches the conditions is found.  Since those conditions are =
fairly weak,
> >> for example that the group actually has free inodes, and it has be=
tter than
> >> average free inodes and blocks, it makes sense to search beyond ju=
st the first
> >> matching group.
> >>=20
> >> That said, it also doesn't make sense to search beyond a "perfect"=
 group that
> >> has no allocated inodes and no allocated blocks, so a break condit=
ion could be
> >> added to this loop and make it more efficient, especially for very=
 large
> >> filesystems that have 128k+ groups.
> >>=20
> >> It should be noted that this part of the algorithm only applies to=
 "top level"
> >> directories (those below the root inode, or with the EXT4_INODE_TO=
PDIR flag
> >> set, so searching a bit longer for a good group is not a bad idea =
in this case.
> >>=20
> >> Cheers, Andreas.
> >>=20
> >>> Thanks & Regards,
> >>>  Lokesh
> >>>=20
> >>>=20
> >>>=20
> >>> On Thu, Dec 3, 2015 at 11:28 PM, Andreas Dilger <adilger@dilger.c=
a> wrote:
> >>>> On Dec 3, 2015, at 01:07, lokesh jaliminche <lokesh.jaliminche@g=
mail.com> wrote:
> >>>>>=20
> >>>>> Thought of giving more clarification on my question
> >>>>> why group search start is random ? because we can also start  s=
earch
> >>>>> for valid groups for inode allocation from the start. As this g=
roup
> >>>>> search is random  inode selection might go to end of groups whi=
ch
> >>>>> might affect IO performance
> >>>>=20
> >>>> Starting the inode search at the beginning of the disk each time
> >>>> means that inode allocation will be inefficient because it will =
search
> >>>> over groups that are mostly or entirely full already.
> >>>>=20
> >>>> Allocating the new directory in a semi-random group, one that is
> >>>> relatively unused, ensures that new
> >>>> inode and block allocations are relatively efficient afterward.
> >>>>=20
> >>>> Cheers, Andreas
> >>>>=20
> >>>>> On Thu, Dec 3, 2015 at 1:14 PM, lokesh jaliminche
> >>>>> <lokesh.jaliminche@gmail.com> wrote:
> >>>>>> hello folks,
> >>>>>>              I am new to ext4 code. I was going through the
> >>>>>> ext4-source for allocation of inode.
> >>>>>> There is one thing that I did not understand while selection o=
f groups
> >>>>>> for inode allocation . I came across this code snippet which i=
s part
> >>>>>> of find_group_orlov function. question is, why group search st=
art is
> >>>>>> random ?
> >>>>>>=20
> >>>>>> Code snippet:
> >>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>> =D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if (qstr) {
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7hinfo.hash_version =3D LDISKFS_DX_HASH_HALF_MD4;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7hinfo.seed =3D sbi->s_hash_seed;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7ldiskfsfs_dirhash(qstr->name, qstr->len, &hinfo);
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7grp =3D hinfo.hash;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7} else
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7get_random_bytes(&grp, sizeof(grp));
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7parent_group =3D=
 (unsigned)grp % ngroups;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7for (i =3D 0; =
i < ngroups; i++) {
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7g =3D (parent_group + i) % ngroups;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7get_orlov_stats(sb, g, flex_size, &stats);
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7if (!stats.free_inodes)
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7continue;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7if (stats.used_dirs >=3D best_ndir)
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7continue;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7if (stats.free_inodes < avefreei)
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7continue;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7if (stats.free_blocks < avefreeb)
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7continue;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7grp =3D g;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7ret =3D 0;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7best_ndir =3D stats.used_dirs;
> >>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7}
> >>>>>>=20
> >>>>>> Thanks & Regards,
> >>>>>> Lokesh
> >>>>> N=E2=80=B9=C2=A7=D0=86=D0=B6=D0=BCr=D1=91=E2=80=BAy=D1=8A=D0=B8=
=D1=99=D0=A8b=D0=86X=C2=AC=C2=B6=D0=97=C2=A7v=D0=A8^=E2=80=93)=D0=AE=D1=
=94{.n=D0=97+=E2=80=B0=C2=B7=D2=90=D0=89{=C2=B1{ x=D0=89{ay=D1=94 =D0=9A=
=E2=80=A1=D0=AA=E2=84=A2=D0=BB,j =C2=AD=D1=9Ef=D0=88=D1=9E=C2=B7h=D1=99=
=E2=80=B9=D0=B0z=E2=84=96 =C2=AEw=D2=90=D1=9E=D1=91 =D1=9E=C2=B7=C2=A6j=
:+v=E2=80=B0=D0=81=D0=89w=D0=B8j=D0=A8m=C2=B6=D1=9F=D1=8F=D1=95 =C2=AB=E2=
=80=98=D0=BA=D0=B7zZ+=D1=93=D1=89=D1=99=D0=8B=D0=89=D0=AD=D1=9Ej"=D1=9C=
=D1=8A!=C2=B6i
> >>=20
> >>=20
> >> Cheers, Andreas
> >>=20
> >>=20
> >>=20
> >>=20
> >>=20
>=20
>=20
> Cheers, Andreas
>=20
>=20
>=20
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
