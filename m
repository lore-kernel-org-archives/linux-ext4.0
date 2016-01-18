From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v5] EXT4: optimizing group search for inode allocation
Date: Mon, 18 Jan 2016 14:50:48 -0700
Message-ID: <1ACAFB33-9F89-4718-99F4-CB0EE7206466@dilger.ca>
References: <CAKJOkCr-O+37QfFFJgtkRUZfo_-U=qmYy=Ooc7oqtqcVrz1HWQ@mail.gmail.com> <9CF60D02-FF10-44FF-A31E-D4E99F627AF2@dilger.ca> <20151226084153.GA4248@server_lokesh.domain.name> <2DA2ED68-7DD4-425D-8A47-E896E9BF0F4A@dilger.ca> <20160107004639.GA3902@server_lokesh.domain.name> <687935F0-EEA5-4CB6-9E5C-43E49FBB39E2@dilger.ca> <20160116230226.GB3189@server_lokesh>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F6636213-525E-4B20-AE50-A563B11AA174"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Lokesh Jaliminche <lokesh.jaliminche@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33891 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbcARVu7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2016 16:50:59 -0500
Received: by mail-pa0-f67.google.com with SMTP id yy13so33044118pab.1
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2016 13:50:59 -0800 (PST)
In-Reply-To: <20160116230226.GB3189@server_lokesh>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F6636213-525E-4B20-AE50-A563B11AA174
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 16, 2016, at 4:02 PM, Lokesh Jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>=20
> From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
> Date: Thu, 7 Jan 2016 05:12:20 +0530
> Subject: [PATCH v5] ext4: optimizing group serch for inode allocation
>=20
> Added a check at the start of group search loop to
> avoid looping unecessarily in case of empty group.
> This also allow group search to jump directly to
> "found_flex_bg" with "stats" and "group" already set,
> so there is no need to go through the extra steps of
> setting "best_desc" , "best_group" and then break
> out of the loop just to set "stats" and "group" again.

This looks very good, just one minor potential issue below.

> Signed-off-by: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
> ---
> fs/ext4/ialloc.c |   10 ++++++++++
> 1 files changed, 10 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 1b8024d..d2835cc 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -477,6 +477,12 @@ static int find_group_orlov(struct super_block =
*sb, struct inode *parent,
>             (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
>                int best_ndir =3D inodes_per_group;
>                int ret =3D -1;
> +               /* Maximum usable blocks per group as some blocks are =
used
> +                * for inode tables and allocation bitmaps */
> +               unsigned int max_blocks_per_flex =3D

This should be an unsigned long long or __u64, since the =
max_blocks_per_flex
calculation may overflow a 32-bit value on filesystems with larger =
block_size
and a large value for flex_size (larger than 2^13 for a 64KB blocksize).

The "stats.free_clusters" is already a __u64 for this reason.

> +                       ((sbi->s_blocks_per_group -
> +                         (sbi->s_itb_per_group +  2)) *
> +                        flex_size) >>  sbi->s_cluster_bits;
>=20
>                if (qstr) {
>                        hinfo.hash_version =3D DX_HASH_HALF_MD4;
> @@ -489,6 +495,10 @@ static int find_group_orlov(struct super_block =
*sb, struct inode *parent,
>                for (i =3D 0; i < ngroups; i++) {
>                        g =3D (parent_group + i) % ngroups;
>                        get_orlov_stats(sb, g, flex_size, &stats);
> +                       /* can't get better group than empty group */
> +                       if (max_blocks_per_flex =3D=3D =
stats.free_clusters &&
> +                           (inodes_per_group * flex_size) =3D=3D =
stats.free_inodes)
> +                               goto found_flex_bg;
>                        if (!stats.free_inodes)
>                                continue;
>                        if (stats.used_dirs >=3D best_ndir)
> --
> 1.7.1
>=20
>=20
>=20
> On Mon, Jan 11, 2016 at 02:13:46PM -0700, Andreas Dilger wrote:
>> On Jan 6, 2016, at 5:46 PM, Lokesh Jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>>>=20
>>> you are right flex groups cannot be completely empty as some
>>> blocks are used for inode table and allocation bitmaps. I
>>> missed that point. I have corrected that. Also I have tested
>>> and validated this patch by putting some traces it works!
>>=20
>> Good news.  Thanks for updating the patch and testing it.
>> More comments below.
>>=20
>>> Here are corresponding logs:
>>> commands:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> mkfs.ext4 -g 10000 -G 2 /dev/sdc
>>> mount -t ext4  /dev/sdc /mnt/test_ext4/
>>> cd /mnt/test_ext4
>>> mkdir 1
>>> cd 1
>>>=20
>>> logs:
>>> =3D=3D=3D=3D=3D
>>> Jan  7 03:36:45 root kernel: [   64.792939] =
max_usable_blocks_per_flex_group     =3D  [19692]
>>> Jan  7 03:36:45 root kernel: [   64.792939] stats.free_clusters      =
            =3D  [19264]
>>> Jan  7 03:36:45 root kernel: [   64.792939] Inodes_per_flex_group    =
            =3D  [4864]
>>> Jan  7 03:36:45 root kernel: [   64.792939] stats.free_inodes        =
            =3D  [4853]
>>> Jan  7 03:36:45 root kernel: [   64.792950] =
max_usable_blocks_per_flex_group     =3D  [19692]
>>> Jan  7 03:36:45 root kernel: [   64.792950] stats.free_clusters      =
            =3D  [19481]
>>> Jan  7 03:36:45 root kernel: [   64.792950] Inodes_per_flex_group    =
            =3D  [4864]
>>> Jan  7 03:36:45 root kernel: [   64.792950] stats.free_inodes        =
            =3D  [4864]
>>> Jan  7 03:36:45 root kernel: [   64.792958] =
max_usable_blocks_per_flex_group     =3D  [19692]
>>> Jan  7 03:36:45 root kernel: [   64.792958] stats.free_clusters      =
            =3D  [19481]
>>> Jan  7 03:36:45 root kernel: [   64.792958] Inodes_per_flex_group    =
            =3D  [4864]
>>> Jan  7 03:36:45 root kernel: [   64.792958] stats.free_inodes        =
            =3D  [4864]
>>> Jan  7 03:36:45 root kernel: [   64.792965] =
max_usable_blocks_per_flex_group     =3D  [19692]
>>> Jan  7 03:36:45 root kernel: [   64.792965] stats.free_clusters      =
            =3D  [19481]
>>> Jan  7 03:36:45 root kernel: [   64.792965] Inodes_per_flex_group    =
            =3D  [4864]
>>> Jan  7 03:36:45 root kernel: [   64.792965] stats.free_inodes        =
            =3D  [4864]
>>> Jan  7 03:36:45 root kernel: [   64.792972] =
max_usable_blocks_per_flex_group     =3D  [19692]
>>> Jan  7 03:36:45 root kernel: [   64.792972] stats.free_clusters      =
            =3D  [19481]
>>> Jan  7 03:36:45 root kernel: [   64.792972] Inodes_per_flex_group    =
            =3D  [4864]
>>> Jan  7 03:36:45 root kernel: [   64.792972] stats.free_inodes        =
            =3D  [4864]
>>> Jan  7 03:36:45 root kernel: [   64.792979] =
max_usable_blocks_per_flex_group     =3D  [19692]<<<<<<<<<<<
>>> Jan  7 03:36:45 root kernel: [   64.792979] stats.free_clusters      =
            =3D  [19692]<<<<<<<<<<<
>>> Jan  7 03:36:45 root kernel: [   64.792979] Inodes_per_flex_group    =
            =3D  [4864]<<<<<<<<<<<<
>>> Jan  7 03:36:45 root kernel: [   64.792979] stats.free_inodes        =
            =3D  [4864]<<<<<<<<<<<<
>>> Jan  7 03:36:45 root kernel: [   64.792985] found_flex_bg =
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>condition satisfied
>>>=20
>>>=20
>>> [Patch v4]:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
>>> Date: Thu, 7 Jan 2016 05:12:20 +0530
>>> Subject: [PATCH] ext4: optimizing group serch for inode allocation
>>>=20
>>> Added a check at the start of group search loop to
>>> avoid looping unecessarily in case of empty group.
>>> This also allow group search to jump directly to
>>> "found_flex_bg" with "stats" and "group" already set,
>>> so there is no need to go through the extra steps of
>>> setting "best_desc" , "best_group" and then break
>>> out of the loop just to set "stats" and "group" again.
>>>=20
>>> Signed-off-by: Lokesh Nagappa Jaliminche =
<lokesh.jaliminche@gmail.com>
>>> ---
>>> fs/ext4/ext4.h   |    2 ++
>>> fs/ext4/ialloc.c |   21 +++++++++++++++++++--
>>> 2 files changed, 21 insertions(+), 2 deletions(-)
>>>=20
>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>> index cc7ca4e..fc48f9a 100644
>>> --- a/fs/ext4/ext4.h
>>> +++ b/fs/ext4/ext4.h
>>> @@ -326,6 +326,8 @@ struct flex_groups {
>>> #define        EXT4_MAX_DESC_SIZE              EXT4_MIN_BLOCK_SIZE
>>> #define EXT4_DESC_SIZE(s)              (EXT4_SB(s)->s_desc_size)
>>> #ifdef __KERNEL__
>>> +# define EXT4_INODE_TABLE_BLOCKS_PER_GROUP(s)  =
(EXT4_SB(s)->s_itb_per_group)
>>> +# define EXT4_BLOCKS_PER_CLUSTER(s)    =
(EXT4_SB(s)->s_cluster_ratio)
>>=20
>> I don't think there is much value to these macros.  They aren't much
>> shorter than the actual variable access, and they don't provide any
>> improved clarity for the reader.
>>=20
>> I think they were introduced many years ago so that this header could
>> be shared between the kernel and e2fsprogs, but that is no longer =
true
>> so I don't think there is a need to add new ones.
>>=20
>> Ted, any opinion on this?
>>=20
>>> # define EXT4_BLOCKS_PER_GROUP(s)      =
(EXT4_SB(s)->s_blocks_per_group)
>>> # define EXT4_CLUSTERS_PER_GROUP(s)    =
(EXT4_SB(s)->s_clusters_per_group)
>>> # define EXT4_DESC_PER_BLOCK(s)                =
(EXT4_SB(s)->s_desc_per_block)
>>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>>> index 1b8024d..dc66ad8 100644
>>> --- a/fs/ext4/ialloc.c
>>> +++ b/fs/ext4/ialloc.c
>>> @@ -463,7 +463,6 @@ static int find_group_orlov(struct super_block =
*sb, struct inode *parent,
>>>                       sbi->s_log_groups_per_flex;
>>>               parent_group >>=3D sbi->s_log_groups_per_flex;
>>>       }
>>> -
>>>       freei =3D =
percpu_counter_read_positive(&sbi->s_freeinodes_counter);
>>>       avefreei =3D freei / ngroups;
>>=20
>> Not sure why this line is being deleted?
>>=20
>>> @@ -477,7 +476,20 @@ static int find_group_orlov(struct super_block =
*sb, struct inode *parent,
>>>            (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
>>>               int best_ndir =3D inodes_per_group;
>>>               int ret =3D -1;
>>> -
>>> +               /* blocks used for inode table and allocation =
bitmaps */
>>> +               unsigned int max_usable_blocks_per_flex_group;
>>=20
>> This could be shorter and still clear, like "max_blocks_per_flex".
>>=20
>>> +               unsigned int blocks_per_group =3D =
EXT4_BLOCKS_PER_GROUP(sb);
>>> +               unsigned int inode_table_blocks_per_group =3D \
>>> +                               =
EXT4_INODE_TABLE_BLOCKS_PER_GROUP(sb);
>>> +               /* Number of blocks per cluster */
>>> +               unsigned int cluster_ratio =3D =
EXT4_BLOCKS_PER_CLUSTER(sb);
>>=20
>> There also isn't much value to making local variables that hold these
>> same values again.  It increases stack space for little benefit.  =
They
>> are only accessed once anyway.
>>=20
>>> +               unsigned int inodes_per_flex_group =3D =
inodes_per_group * \
>>> +                                                       flex_size;
>>> +               max_usable_blocks_per_flex_group =3D \
>>> +                                       =
((blocks_per_group*flex_size) - \
>>=20
>> Spaces around that '*'.
>>=20
>>> +                                       =
(inode_table_blocks_per_group * \
>>> +                                       flex_size + 2 * flex_size)) =
/ \
>>=20
>> This is C and not a CPP macro, so no need for linefeed escapes.
>>=20
>>> +                                       cluster_ratio;
>>=20
>> This should be ">> EXT4_SB(sb)->s_cluster_bits" to avoid the divide.
>>=20
>>>               if (qstr) {
>>>                       hinfo.hash_version =3D DX_HASH_HALF_MD4;
>>>                       hinfo.seed =3D sbi->s_hash_seed;
>>> @@ -489,6 +501,11 @@ static int find_group_orlov(struct super_block =
*sb, struct inode *parent,
>>>               for (i =3D 0; i < ngroups; i++) {
>>>                       g =3D (parent_group + i) % ngroups;
>>>                       get_orlov_stats(sb, g, flex_size, &stats);
>>> +                       /* can't get better group than empty group =
*/
>>> +                       if (max_usable_blocks_per_flex_group =3D=3D =
\
>>> +                               stats.free_clusters && \
>>=20
>> No need for linefeed escapes.
>>=20
>>> +                               inodes_per_flex_group =3D=3D =
stats.free_inodes)
>>=20
>> Align continued line after '(' from the "if (" line.
>>=20
>>> +                                       goto found_flex_bg;
>>=20
>> This is indented too much.  It will work properly when you fix the
>> previous line.
>>=20
>>>                       if (!stats.free_inodes)
>>>                               continue;
>>>                       if (stats.used_dirs >=3D best_ndir)
>>> --
>>> 1.7.1
>>>=20
>>> Regards,
>>> Lokesh
>>>=20
>>> On Sun, Jan 03, 2016 at 11:34:51AM -0700, Andreas Dilger wrote:
>>>> On Dec 26, 2015, at 01:41, Lokesh Jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>>>>>=20
>>>>>=20
>>>>> =46rom 5199982d29ff291b181c25af63a22d6f2d6d3f7b Mon Sep 17 =
00:00:00 2001
>>>>> From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@gmail.com>
>>>>> Date: Sat, 26 Dec 2015 13:19:36 +0530
>>>>> Subject: [PATCH v3] ext4: optimizing group search for inode =
allocation
>>>>>=20
>>>>> Added a check at the start of group search loop to
>>>>> avoid looping unecessarily in case of empty group.
>>>>> This also allow group search to jump directly to
>>>>> "found_flex_bg" with "stats" and "group" already set,
>>>>> so there is no need to go through the extra steps of
>>>>> setting "best_desc" and "best_group" and then break
>>>>> out of the loop just to set "stats" and "group" again.
>>>>>=20
>>>>> Signed-off-by: Lokesh Nagappa Jaliminche =
<lokesh.jaliminche@gmail.com>
>>>>> ---
>>>>> fs/ext4/ialloc.c |   12 ++++++++++--
>>>>> 1 files changed, 10 insertions(+), 2 deletions(-)
>>>>>=20
>>>>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>>>>> index 1b8024d..16f94db 100644
>>>>> --- a/fs/ext4/ialloc.c
>>>>> +++ b/fs/ext4/ialloc.c
>>>>> @@ -473,10 +473,14 @@ static int find_group_orlov(struct =
super_block *sb, struct inode *parent,
>>>>>      ndirs =3D percpu_counter_read_positive(&sbi->s_dirs_counter);
>>>>>=20
>>>>>      if (S_ISDIR(mode) &&
>>>>> -           ((parent =3D=3D d_inode(sb->s_root)) ||
>>>>> -            (ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR)))) {
>>>>> +               ((parent =3D=3D d_inode(sb->s_root)) ||
>>>>> +               (ext4_test_inode_flag(parent, =
EXT4_INODE_TOPDIR)))) {
>>>>=20
>>>> I don't understand why you are changing the indentation here?
>>>>=20
>>>>> +               unsigned int inodes_per_flex_group;
>>>>> +               unsigned long int clusters_per_flex_group;
>>>>>              int best_ndir =3D inodes_per_group;
>>>>>              int ret =3D -1;
>>>>> +               inodes_per_flex_group =3D inodes_per_group * =
flex_size;
>>>>> +               clusters_per_flex_group =3D =
sbi->s_clusters_per_group * flex_size;
>>>>=20
>>>> Have you actually tested if this code works?  When I was looking at =
this
>>>> code I was accidentally looking at the ext2 version, which only =
deals with
>>>> individual groups, and not flex groups.  I don't think that a flex =
group
>>>> can actually be completely empty, since it will always contain at =
least
>>>> an inode table and some bitmaps.
>>>>=20
>>>> This calculation needs to take this into account or it will just be
>>>> overhead and not an optimization. Something like:
>>>>=20
>>>>               /* account for inode table and allocation bitmaps */
>>>>               clusters_per_flex_group =3D sbi->s_clusters_per_group =
* flex_size -
>>>>                       ((inodes_per_flex_group * EXT4_INODE_SIZE(sb) =
+
>>>>                         (flex_size << sb->s_blocksize_bits) * 2 ) =
>>
>>>>                       EXT4_SB(sb)->s_cluster_bits;
>>>>=20
>>>> It would be worthwhile to print this out and verify that there are =
actually
>>>> groups with this many free blocks in a newly formatted filesystem.
>>>>=20
>>>> Cheers, Andreas
>>>>=20
>>>>>              if (qstr) {
>>>>>                      hinfo.hash_version =3D DX_HASH_HALF_MD4;
>>>>> @@ -489,6 +493,10 @@ static int find_group_orlov(struct =
super_block *sb, struct inode *parent,
>>>>>              for (i =3D 0; i < ngroups; i++) {
>>>>>                      g =3D (parent_group + i) % ngroups;
>>>>>                      get_orlov_stats(sb, g, flex_size, &stats);
>>>>> +                       /* the group can't get any better than =
empty */
>>>>> +                       if (inodes_per_flex_group =3D=3D =
stats.free_inodes &&
>>>>> +                               clusters_per_flex_group =3D=3D =
stats.free_clusters)
>>>>> +                               goto found_flex_bg;
>>>>>                      if (!stats.free_inodes)
>>>>>                              continue;
>>>>>                      if (stats.used_dirs >=3D best_ndir)
>>>>> --
>>>>> 1.7.1
>>>>>=20
>>>>>=20
>>>>>> On Mon, Dec 21, 2015 at 10:27:37AM -0700, Andreas Dilger wrote:
>>>>>>> On Dec 18, 2015, at 4:32 PM, lokesh jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>>>>>>>=20
>>>>>>> =46rom 9e09fef78b2fa552c883bf8124af873abfde0805 Mon Sep 17 =
00:00:00 2001
>>>>>>> From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@seagate.com>
>>>>>>=20
>>>>>> In the patch summary there is a typo - s/serch/search/
>>>>>>=20
>>>>>> Also, it appears your email client has mangled the whitespace in =
the
>>>>>> patch.  Please use "git send-email" to send your patch to the =
list:
>>>>>>=20
>>>>>> git send-email --to tytso@mit.edu --cc linux-ext4@vger.kernel.org =
HEAD~1
>>>>>>=20
>>>>>> so that it arrives intact.  You probably need to set it up in =
~/.gitconfig:
>>>>>>=20
>>>>>> [sendemail]
>>>>>>      confirm =3D compose
>>>>>>      smtpdomain =3D {your client hostname}
>>>>>>      smtpserver =3D {your SMTP server hostname}
>>>>>>=20
>>>>>> Cheers, Andreas
>>>>>>=20
>>>>>>> Added a check at the start of group search loop to
>>>>>>> avoid looping unecessarily in case of empty group.
>>>>>>> This also allow group search to jump directly to
>>>>>>> "found_flex_bg" with "stats" and "group" already set,
>>>>>>> so there is no need to go through the extra steps of
>>>>>>> setting "best_desc" and "best_group" and then break
>>>>>>> out of the loop just to set "stats" and "group" again.
>>>>>>>=20
>>>>>>> Signed-off-by: Lokesh N Jaliminche <lokesh.jaliminche@gmail.com>
>>>>>>> ---
>>>>>>> fs/ext4/ialloc.c |    8 ++++++++
>>>>>>> 1 files changed, 8 insertions(+), 0 deletions(-)
>>>>>>>=20
>>>>>>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>>>>>>> index 1b8024d..588bf8e 100644
>>>>>>> --- a/fs/ext4/ialloc.c
>>>>>>> +++ b/fs/ext4/ialloc.c
>>>>>>> @@ -446,6 +446,8 @@ static int find_group_orlov(struct =
super_block
>>>>>>> *sb, struct inode *parent,
>>>>>>> struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>>>>>>> ext4_group_t real_ngroups =3D ext4_get_groups_count(sb);
>>>>>>> int inodes_per_group =3D EXT4_INODES_PER_GROUP(sb);
>>>>>>> + unsigned int inodes_per_flex_group;
>>>>>>> + long unsigned int blocks_per_clustre;
>>>>>>> unsigned int freei, avefreei, grp_free;
>>>>>>> ext4_fsblk_t freeb, avefreec;
>>>>>>> unsigned int ndirs;
>>>>>>> @@ -470,6 +472,8 @@ static int find_group_orlov(struct =
super_block
>>>>>>> *sb, struct inode *parent,
>>>>>>> percpu_counter_read_positive(&sbi->s_freeclusters_counter));
>>>>>>> avefreec =3D freeb;
>>>>>>> do_div(avefreec, ngroups);
>>>>>>> + inodes_per_flex_group =3D inodes_per_group * flex_size;
>>>>>>> + blocks_per_clustre =3D sbi->s_blocks_per_group * flex_size;
>>>>>>> ndirs =3D percpu_counter_read_positive(&sbi->s_dirs_counter);
>>>>>>>=20
>>>>>>> if (S_ISDIR(mode) &&
>>>>>>> @@ -489,6 +493,10 @@ static int find_group_orlov(struct =
super_block
>>>>>>> *sb, struct inode *parent,
>>>>>>> for (i =3D 0; i < ngroups; i++) {
>>>>>>> g =3D (parent_group + i) % ngroups;
>>>>>>> get_orlov_stats(sb, g, flex_size, &stats);
>>>>>>> + /* the group can't get any better than empty */
>>>>>>> + if (inodes_per_flex_group =3D=3D stats.free_inodes &&
>>>>>>> + blocks_per_clustre =3D=3D stats.free_clusters)
>>>>>>> + goto found_flex_bg;
>>>>>>> if (!stats.free_inodes)
>>>>>>> continue;
>>>>>>> if (stats.used_dirs >=3D best_ndir)
>>>>>>> --
>>>>>>> 1.7.1
>>>>>>> <0001-EXT4-optimizing-group-serch-for-inode-allocation.patch>
>>>>>>=20
>>>>>>=20
>>>>>> Cheers, Andreas
>>>>>=20
>>>>>=20
>>>>> <0001-ext4-optimizing-group-serch-for-inode-allocation.patch>
>>> <0001-ext4-optimizing-group-serch-for-inode-allocation.patch>
>>=20
>>=20
>> Cheers, Andreas
>>=20
>>=20
>>=20
>>=20
>>=20
>=20
>=20
> <0001-ext4-optimizing-group-serch-for-inode-allocation.patch>


Cheers, Andreas






--Apple-Mail=_F6636213-525E-4B20-AE50-A563B11AA174
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVp1eOXKl2rkXzB/gAQi83xAAmH2CTysspyj0nAdUMsJGiGcxyP19rRlo
prTbrHtud8DQpFZ0qJW2E6QjiIY3Zkc+IzXmT7qAv90FbOc99XNuiSvP2uP3L56Q
dxA9/b9yQpToki7fRZyJ7MYGANQ3YL7eDsxiX3Yr3nr1qu31BKmI3tLdfRSargqu
OfbVgiT1YSJZao6mkub8DgmL0LKxaBxn018IfNbgabsZcx7n2uikrD+Ld+DJ7yYh
7zQ2KRwEkmF6ff8+4fm9yw0+GKatEvjBYDQARdtPuflf5k1UqJPKqAMkTjfhRLvk
KYm2B2BHTBD3lgRZ/vStmmz1Eo4OzoLPQLsKUUrA7h2t1VTh535oTJoCx3Jj5y0E
F/KTP0Cj2fEmirHF/Ic0tHguHDJLG3kLOSOEpRmfY4JvGqHkd5WsLkv/AlRkHk4c
XSDZ1Q60tnGy4W4KDjFsN/jeDldtWSQ1u+g7Hc+cWqzebMKfWUvFDv2qbfuQ63eq
R06hqCgkkY/2Oyg9Y6JyMRSDP8CS/n39jDifSz3fwQsVfqhmzMYuy81Ip0+KpbxC
N2nLESQLqRncM0Ti/DqrGADEgvo36+jx2bUXjxEGEIR1G2PgFd5AWBPe35orEYa5
Eryzla1sMRVBvzV9o/XEM2dV/3RVe0BmZdYdCRXS/pM7yHJ6fxSREFJpDQx6D7E5
gz7AZgaRGns=
=yDjy
-----END PGP SIGNATURE-----

--Apple-Mail=_F6636213-525E-4B20-AE50-A563B11AA174--
