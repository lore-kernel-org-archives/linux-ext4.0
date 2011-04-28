From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [Ext4 punch hole 1/6 v5] Ext4 Punch Hole Support: Add flag to ext4_has_free_blocks
Date: Thu, 28 Apr 2011 09:28:53 +0300
Message-ID: <BANLkTinb9MpjMRAoOhUi-TG1zJVJKkm19g@mail.gmail.com>
References: <4DAD3C98.3050308@linux.vnet.ibm.com>
	<BANLkTi=1PEcextZ03RXXHixzHtav1m2tfQ@mail.gmail.com>
	<BANLkTi=kX8Roeq1oDUqqYp76ihNfsrLKSg@mail.gmail.com>
	<BANLkTinPejmzuWukBLFj__NDdAoq+uwphg@mail.gmail.com>
	<4DB88012.8010305@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61256 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1D1G2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Apr 2011 02:28:54 -0400
Received: by ewy4 with SMTP id 4so727046ewy.19
        for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2011 23:28:53 -0700 (PDT)
In-Reply-To: <4DB88012.8010305@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 27, 2011 at 11:44 PM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 4/25/2011 10:44 AM, Amir Goldstein wrote:
>>
>> On Mon, Apr 25, 2011 at 12:08 PM, Yongqiang Yang<xiaoqiangnk@gmail.c=
om>
>> =A0wrote:
>>>
>>> On Mon, Apr 25, 2011 at 3:51 PM, Amir Goldstein<amir73il@gmail.com>
>>> =A0wrote:
>>>>
>>>> Hi Allison,
>>>>
>>>> Sorry for the late response.
>>>> I find it hard to digest yet another set of flags,
>>>> especially, since there is already an impressive set of
>>>> flags for allocation hints, which is what USE_ROOTBLKS flag really=
 is.
>>>>
>>>> So I think it would be much better to pass the flag in
>>>> ext4_allocation_request
>>>> and add the 'ar' argument to functions that don't have it, rather =
than
>>>> adding
>>>> a 'flags' argument.
>>>
>>> It depends. =A0I had a look at Allison's patch and found that funct=
ions
>>> influenced by the patch can be divided into two groups:
>>> =A01. one of which is extent related and led by ext4_ext_insert_ext=
ent()
>>> =A02. while other one of which is very low level such as
>>> ext4_claim_free_blocks() which is used by ext4_da_reserve_space() i=
n a
>>> relatively hight level.
>>>
>>> So I think maybe it's a good idea for extent related functions, but
>>> not for low level functions such as ext4_claim_free_blocks.
>>>
>>> Actually ext4_ext_insert_extent() seldom allocates blocks, because =
a
>>> block can contain a lot of extents. =A0Thus adding 'ar' parameter t=
o
>>> ext4_ext_insert_extent() induces much unnecessary 'ar''s initializi=
ng.
>>>
>>
>> Yeah, it's not clear what's the best way to handle this.
>> =A0From a system designer point of view, I would suggest to add a ca=
pability
>> flag
>> for allocating from reserved space, but it is probably not going to =
be
>> an easy fix to push.
>>
>>>
>>>>
>>>> If you do create a patch to pass 'ar' down to has_free_blocks()
>>>> I will also be able to use it to pass the HINT_COWING flag.
>>>
>>> HINT_COWING is being passed via 'ar'.
>>>
>>
>> indeed, which is why if has_free_blocks gets 'ar' we will have that
>> flag, which we do not need anyway, since we have the IS_COWING(handl=
e)
>> flag.
>>
>>> Yongqiang.
>>>>
>>>> Now here is another advise:
>>>> In ext4_mb_new_blocks() after ext4_claim_free_blocks(), there is a=
 call
>>>> to
>>>> dquot_alloc_block().
>>>> You need to call dquot_alloc_block_nofail() when allocating for pu=
nch
>>>> hole,
>>>> otherwise punch hole can fail on quota limits.
>>>> We already have a patch for doing that with HINT_COWING flag.
>>>>
>>>> I think maybe it is best if our groups (punch hole and snapshots) =
have
>>>> a mutual 'next'
>>>> repository we can work with to prepare for the 2.6.40 merge window=
=2E
>>>> It would be even better, if Ted also collaborated his big alloc pa=
tches.
>>>>
>>>> What do you think guys?
>>>>
>>>> Amir.
>>>>
>>>> On Tue, Apr 19, 2011 at 10:41 AM, Allison Henderson
>>>> <achender@linux.vnet.ibm.com> =A0wrote:
>>>>>
>>>>> This patch adds a flag to ext4_has_free_blocks which
>>>>> enables the use of reserved blocks. =A0This will allow
>>>>> a punch hole to proceed even if the disk is full.
>>>>> Punching a hole may require additional blocks to first
>>>>> split the extents. =A0The blocks will be reclaimed after
>>>>> the punch hole completes.
>>>>>
>>>>> Because ext4_has_free_blocks is a low level function,
>>>>> the flag needs to be passed down through several
>>>>> functions listed below:
>>>>>
>>>>> ext4_ext_insert_extent
>>>>> ext4_ext_create_new_leaf
>>>>> ext4_ext_grow_indepth
>>>>> ext4_ext_split
>>>>> ext4_ext_new_meta_block
>>>>> ext4_mb_new_blocks
>>>>> ext4_claim_free_blocks
>>>>> ext4_has_free_blocks
>>>>>
>>>>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>>>>> ---
>>>>> :100644 100644 97b970e... 794c4d2... M =A0fs/ext4/balloc.c
>>>>> :100644 100644 4daaf2b... 6c1f415... M =A0fs/ext4/ext4.h
>>>>> :100644 100644 dd2cb50... 0b186d9... M =A0fs/ext4/extents.c
>>>>> :100644 100644 1a86282... ec890fd... M =A0fs/ext4/inode.c
>>>>> :100644 100644 a5837a8... db8b120... M =A0fs/ext4/mballoc.c
>>>>> :100644 100644 b545ca1... 2d9b12c... M =A0fs/ext4/xattr.c
>>>>> =A0fs/ext4/balloc.c =A0| =A0 17 ++++++++++-------
>>>>> =A0fs/ext4/ext4.h =A0 =A0| =A0 16 +++++++++++++---
>>>>> =A0fs/ext4/extents.c | =A0 27 ++++++++++++++++-----------
>>>>> =A0fs/ext4/inode.c =A0 | =A0 =A06 +++---
>>>>> =A0fs/ext4/mballoc.c | =A0 =A05 +++--
>>>>> =A0fs/ext4/xattr.c =A0 | =A0 =A02 +-
>>>>> =A06 files changed, 46 insertions(+), 27 deletions(-)
>>>>>
>>>>> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
>>>>> index 97b970e..794c4d2 100644
>>>>> --- a/fs/ext4/balloc.c
>>>>> +++ b/fs/ext4/balloc.c
>>>>> @@ -493,7 +493,8 @@ error_return:
>>>>> =A0* Check if filesystem has nblocks free& =A0available for alloc=
ation.
>>>>> =A0* On success return 1, return 0 on failure.
>>>>> =A0*/
>>>>> -static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nb=
locks)
>>>>> +static int ext4_has_free_blocks(struct ext4_sb_info *sbi,
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s64=
 nblocks, int flags)
>>>>> =A0{
>>>>> =A0 =A0 =A0 =A0s64 free_blocks, dirty_blocks, root_blocks;
>>>>> =A0 =A0 =A0 =A0struct percpu_counter *fbc =3D&sbi->s_freeblocks_c=
ounter;
>>>>> @@ -522,7 +523,9 @@ static int ext4_has_free_blocks(struct ext4_s=
b_info
>>>>> *sbi, s64 nblocks)
>>>>> =A0 =A0 =A0 =A0/* Hm, nope. =A0Are (enough) root reserved blocks =
available? */
>>>>> =A0 =A0 =A0 =A0if (sbi->s_resuid =3D=3D current_fsuid() ||
>>>>> =A0 =A0 =A0 =A0 =A0 =A0((sbi->s_resgid !=3D 0)&& =A0in_group_p(sb=
i->s_resgid)) ||
>>>>> - =A0 =A0 =A0 =A0 =A0 capable(CAP_SYS_RESOURCE)) {
>>>>> + =A0 =A0 =A0 =A0 =A0 capable(CAP_SYS_RESOURCE) ||
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (flags& =A0EXT4_HAS_FREE_BLKS_USE_R=
OOTBLKS)) {
>>>>> +
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (free_blocks>=3D (nblocks + dir=
ty_blocks))
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
>>>>> =A0 =A0 =A0 =A0}
>>>>> @@ -531,9 +534,9 @@ static int ext4_has_free_blocks(struct ext4_s=
b_info
>>>>> *sbi, s64 nblocks)
>>>>> =A0}
>>>>>
>>>>> =A0int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s64 nblocks)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s64 nblocks, int flags)
>>>>> =A0{
>>>>> - =A0 =A0 =A0 if (ext4_has_free_blocks(sbi, nblocks)) {
>>>>> + =A0 =A0 =A0 if (ext4_has_free_blocks(sbi, nblocks, flags)) {
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0percpu_counter_add(&sbi->s_dirtybl=
ocks_counter,
>>>>> nblocks);
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>>>>> =A0 =A0 =A0 =A0} else
>>>>> @@ -554,7 +557,7 @@ int ext4_claim_free_blocks(struct ext4_sb_inf=
o
>>>>> *sbi,
>>>>> =A0*/
>>>>> =A0int ext4_should_retry_alloc(struct super_block *sb, int *retri=
es)
>>>>> =A0{
>>>>> - =A0 =A0 =A0 if (!ext4_has_free_blocks(EXT4_SB(sb), 1) ||
>>>>> + =A0 =A0 =A0 if (!ext4_has_free_blocks(EXT4_SB(sb), 1, 0) ||
>>>>> =A0 =A0 =A0 =A0 =A0 =A0(*retries)++> =A03 ||
>>>>> =A0 =A0 =A0 =A0 =A0 =A0!EXT4_SB(sb)->s_journal)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>>>>> @@ -577,7 +580,7 @@ int ext4_should_retry_alloc(struct super_bloc=
k *sb,
>>>>> int *retries)
>>>>> =A0* error stores in errp pointer
>>>>> =A0*/
>>>>> =A0ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct ino=
de
>>>>> *inode,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t goal, unsigned long *c=
ount, int *errp)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t goal, unsigned long *c=
ount, int *errp, int
>>>>> flags)
>>>>> =A0{
>>>>> =A0 =A0 =A0 =A0struct ext4_allocation_request ar;
>>>>> =A0 =A0 =A0 =A0ext4_fsblk_t ret;
>>>>> @@ -588,7 +591,7 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *h=
andle,
>>>>> struct inode *inode,
>>>>> =A0 =A0 =A0 =A0ar.goal =3D goal;
>>>>> =A0 =A0 =A0 =A0ar.len =3D count ? *count : 1;
>>>>>
>>>>> - =A0 =A0 =A0 ret =3D ext4_mb_new_blocks(handle,&ar, errp);
>>>>> + =A0 =A0 =A0 ret =3D ext4_mb_new_blocks(handle,&ar, errp, flags)=
;
>>>>> =A0 =A0 =A0 =A0if (count)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*count =3D ar.len;
>>>>> =A0 =A0 =A0 =A0/*
>>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>>> index 4daaf2b..6c1f415 100644
>>>>> --- a/fs/ext4/ext4.h
>>>>> +++ b/fs/ext4/ext4.h
>>>>> @@ -512,6 +512,8 @@ struct ext4_new_group_data {
>>>>> =A0 =A0 =A0 =A0/* Convert extent to initialized after IO complete=
 */
>>>>> =A0#define EXT4_GET_BLOCKS_IO_CONVERT_EXT
>>>>> (EXT4_GET_BLOCKS_CONVERT|\
>>>>>
>>>>> EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
>>>>> + =A0 =A0 =A0 /* Punch out blocks of an extent */
>>>>> +#define EXT4_GET_BLOCKS_PUNCH_OUT_EXT =A0 =A0 =A0 =A0 =A00x0020
>>>>>
>>>>> =A0/*
>>>>> =A0* Flags used by ext4_free_blocks
>>>>> @@ -521,6 +523,11 @@ struct ext4_new_group_data {
>>>>> =A0#define EXT4_FREE_BLOCKS_VALIDATED =A0 =A0 0x0004
>>>>>
>>>>> =A0/*
>>>>> + * Flags used by ext4_has_free_blocks
>>>>> + */
>>>>> +#define EXT4_HAS_FREE_BLKS_USE_ROOTBLKS 0x0001
>>>>> +
>>>>> +/*
>>>>> =A0* ioctl commands
>>>>> =A0*/
>>>>> =A0#define =A0 =A0 =A0 =A0EXT4_IOC_GETFLAGS =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 FS_IOC_GETFLAGS
>>>>> @@ -1638,8 +1645,10 @@ extern int ext4_bg_has_super(struct super_=
block
>>>>> *sb, ext4_group_t group);
>>>>> =A0extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_group_t group=
);
>>>>> =A0extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, str=
uct
>>>>> inode *inode,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t goal, =
unsigned long *count, int
>>>>> *errp);
>>>>> -extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64
>>>>> nblocks);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t goal, =
unsigned long *count,
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *errp, int flag=
s);
>>>>> +extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 s64 nblocks, int flags);
>>>>> =A0extern void ext4_add_groupblocks(handle_t *handle, struct supe=
r_block
>>>>> *sb,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ex=
t4_fsblk_t block, unsigned long
>>>>> count);
>>>>> =A0extern ext4_fsblk_t ext4_count_free_blocks(struct super_block =
*);
>>>>> @@ -1696,7 +1705,8 @@ extern long ext4_mb_max_to_scan;
>>>>> =A0extern int ext4_mb_init(struct super_block *, int);
>>>>> =A0extern int ext4_mb_release(struct super_block *);
>>>>> =A0extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct ext4_allocation_request *, int
>>>>> *);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct ext4_allocation_request *,
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int=
 *, int flags);
>>>>> =A0extern int ext4_mb_reserve_blocks(struct super_block *, int);
>>>>> =A0extern void ext4_discard_preallocations(struct inode *);
>>>>> =A0extern int __init ext4_init_mballoc(void);
>>>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>>>> index dd2cb50..0b186d9 100644
>>>>> --- a/fs/ext4/extents.c
>>>>> +++ b/fs/ext4/extents.c
>>>>> @@ -192,12 +192,12 @@ static ext4_fsblk_t ext4_ext_find_goal(stru=
ct
>>>>> inode *inode,
>>>>> =A0static ext4_fsblk_t
>>>>> =A0ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ext4_ext_pa=
th *path,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_extent =
*ex, int *err)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_extent =
*ex, int *err, int flags)
>>>>> =A0{
>>>>> =A0 =A0 =A0 =A0ext4_fsblk_t goal, newblock;
>>>>>
>>>>> =A0 =A0 =A0 =A0goal =3D ext4_ext_find_goal(inode, path,
>>>>> le32_to_cpu(ex->ee_block));
>>>>> - =A0 =A0 =A0 newblock =3D ext4_new_meta_blocks(handle, inode, go=
al, NULL,
>>>>> err);
>>>>> + =A0 =A0 =A0 newblock =3D ext4_new_meta_blocks(handle, inode, go=
al, NULL, err,
>>>>> flags);
>>>>> =A0 =A0 =A0 =A0return newblock;
>>>>> =A0}
>>>>>
>>>>> @@ -793,7 +793,7 @@ static int ext4_ext_insert_index(handle_t *ha=
ndle,
>>>>> struct inode *inode,
>>>>> =A0*/
>>>>> =A0static int ext4_ext_split(handle_t *handle, struct inode *inod=
e,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0st=
ruct ext4_ext_path *path,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct ext4_extent *newext, int at)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct ext4_extent *newext, int at, int
>>>>> flags)
>>>>> =A0{
>>>>> =A0 =A0 =A0 =A0struct buffer_head *bh =3D NULL;
>>>>> =A0 =A0 =A0 =A0int depth =3D ext_depth(inode);
>>>>> @@ -847,7 +847,7 @@ static int ext4_ext_split(handle_t *handle, s=
truct
>>>>> inode *inode,
>>>>> =A0 =A0 =A0 =A0ext_debug("allocate %d blocks for indexes/leaf\n",=
 depth - at);
>>>>> =A0 =A0 =A0 =A0for (a =3D 0; a< =A0depth - at; a++) {
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0newblock =3D ext4_ext_new_meta_blo=
ck(handle, inode, path,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0newext,&err);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0newext,&err, flags);
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (newblock =3D=3D 0)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cleanup;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ablocks[a] =3D newblock;
>>>>> @@ -1057,7 +1057,7 @@ cleanup:
>>>>> =A0*/
>>>>> =A0static int ext4_ext_grow_indepth(handle_t *handle, struct inod=
e
>>>>> *inode,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0struct ext4_ext_path *path,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 struct ext4_extent *newext)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 struct ext4_extent *newext, int
>>>>> flags)
>>>>> =A0{
>>>>> =A0 =A0 =A0 =A0struct ext4_ext_path *curp =3D path;
>>>>> =A0 =A0 =A0 =A0struct ext4_extent_header *neh;
>>>>> @@ -1065,7 +1065,8 @@ static int ext4_ext_grow_indepth(handle_t
>>>>> *handle, struct inode *inode,
>>>>> =A0 =A0 =A0 =A0ext4_fsblk_t newblock;
>>>>> =A0 =A0 =A0 =A0int err =3D 0;
>>>>>
>>>>> - =A0 =A0 =A0 newblock =3D ext4_ext_new_meta_block(handle, inode,=
 path,
>>>>> newext,&err);
>>>>> + =A0 =A0 =A0 newblock =3D ext4_ext_new_meta_block(handle, inode,=
 path,
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 newext,&err, flags);
>>>>> =A0 =A0 =A0 =A0if (newblock =3D=3D 0)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
>>>>>
>>>>> @@ -1141,7 +1142,7 @@ out:
>>>>> =A0*/
>>>>> =A0static int ext4_ext_create_new_leaf(handle_t *handle, struct i=
node
>>>>> *inode,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0struct ext4_ext_path *path,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 struct ext4_extent *newext)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 struct ext4_extent *newext, int
>>>>> flags)
>>>>> =A0{
>>>>> =A0 =A0 =A0 =A0struct ext4_ext_path *curp;
>>>>> =A0 =A0 =A0 =A0int depth, i, err =3D 0;
>>>>> @@ -1161,7 +1162,7 @@ repeat:
>>>>> =A0 =A0 =A0 =A0if (EXT_HAS_FREE_INDEX(curp)) {
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* if we found index with free ent=
ry, then use that
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * entry: create all needed subtre=
e and add new leaf */
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_split(handle, inod=
e, path, newext, i);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_split(handle, inod=
e, path, newext, i,
>>>>> flags);
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>>>>>
>>>>> @@ -1174,7 +1175,7 @@ repeat:
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D PTR_ERR(pa=
th);
>>>>> =A0 =A0 =A0 =A0} else {
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* tree is full, time to grow in d=
epth */
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_grow_indepth(handl=
e, inode, path,
>>>>> newext);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_grow_indepth(handl=
e, inode, path,
>>>>> newext, flags);
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>>>>>
>>>>> @@ -1668,6 +1669,7 @@ int ext4_ext_insert_extent(handle_t *handle=
,
>>>>> struct inode *inode,
>>>>> =A0 =A0 =A0 =A0int depth, len, err;
>>>>> =A0 =A0 =A0 =A0ext4_lblk_t next;
>>>>> =A0 =A0 =A0 =A0unsigned uninitialized =3D 0;
>>>>> + =A0 =A0 =A0 int free_blks_flags =3D 0;
>>>>>
>>>>> =A0 =A0 =A0 =A0if (unlikely(ext4_ext_get_actual_len(newext) =3D=3D=
 0)) {
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_ERROR_INODE(inode, "ext4_ext_=
get_actual_len(newext)
>>>>> =3D=3D 0");
>>>>> @@ -1742,7 +1744,10 @@ repeat:
>>>>> =A0 =A0 =A0 =A0 * There is no free space in the found leaf.
>>>>> =A0 =A0 =A0 =A0 * We're gonna add a new leaf in the tree.
>>>>> =A0 =A0 =A0 =A0 */
>>>>> - =A0 =A0 =A0 err =3D ext4_ext_create_new_leaf(handle, inode, pat=
h, newext);
>>>>> + =A0 =A0 =A0 if (flag& =A0EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free_blks_flags =3D EXT4_HAS_FREE_B=
LKS_USE_ROOTBLKS;
>>>>> + =A0 =A0 =A0 err =3D ext4_ext_create_new_leaf(handle, inode, pat=
h,
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 newext, free_blks_flags);
>>>>> =A0 =A0 =A0 =A0if (err)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cleanup;
>>>>> =A0 =A0 =A0 =A0depth =3D ext_depth(inode);
>>>>> @@ -3446,7 +3451,7 @@ int ext4_ext_map_blocks(handle_t *handle, s=
truct
>>>>> inode *inode,
>>>>> =A0 =A0 =A0 =A0else
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* disable in-core preallocation f=
or non-regular files
>>>>> */
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ar.flags =3D 0;
>>>>> - =A0 =A0 =A0 newblock =3D ext4_mb_new_blocks(handle,&ar,&err);
>>>>> + =A0 =A0 =A0 newblock =3D ext4_mb_new_blocks(handle,&ar,&err, 0)=
;
>>>>> =A0 =A0 =A0 =A0if (!newblock)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out2;
>>>>> =A0 =A0 =A0 =A0ext_debug("allocate new block: goal %llu, found %l=
lu/%u\n",
>>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>>> index 1a86282..ec890fd 100644
>>>>> --- a/fs/ext4/inode.c
>>>>> +++ b/fs/ext4/inode.c
>>>>> @@ -640,7 +640,7 @@ static int ext4_alloc_blocks(handle_t *handle=
,
>>>>> struct inode *inode,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count =3D target;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* allocating blocks for indirect =
blocks and direct
>>>>> blocks */
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current_block =3D ext4_new_meta_bl=
ocks(handle, inode,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goal,&count,
>>>>> err);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goal,&count,
>>>>> err, 0);
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (*err)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_out;
>>>>>
>>>>> @@ -686,7 +686,7 @@ static int ext4_alloc_blocks(handle_t *handle=
,
>>>>> struct inode *inode,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* enable in-core preallocation on=
ly for regular files
>>>>> */
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ar.flags =3D EXT4_MB_HINT_DATA;
>>>>>
>>>>> - =A0 =A0 =A0 current_block =3D ext4_mb_new_blocks(handle,&ar, er=
r);
>>>>> + =A0 =A0 =A0 current_block =3D ext4_mb_new_blocks(handle,&ar, er=
r, 0);
>>>>> =A0 =A0 =A0 =A0if (unlikely(current_block + ar.len> =A0EXT4_MAX_B=
LOCK_FILE_PHYS))
>>>>> {
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_ERROR_INODE(inode,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
current_block %llu + ar.len %d> =A0%d!",
>>>>> @@ -1930,7 +1930,7 @@ repeat:
>>>>> =A0 =A0 =A0 =A0 * We do still charge estimated metadata to the sb=
 though;
>>>>> =A0 =A0 =A0 =A0 * we cannot afford to run out of free blocks.
>>>>> =A0 =A0 =A0 =A0 */
>>>>> - =A0 =A0 =A0 if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
>>>>> + =A0 =A0 =A0 if (ext4_claim_free_blocks(sbi, md_needed + 1, 0)) =
{
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dquot_release_reservation_block(in=
ode, 1);
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ext4_should_retry_alloc(inode-=
>i_sb,&retries)) {
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0yield();
>>>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>>>> index a5837a8..db8b120 100644
>>>>> --- a/fs/ext4/mballoc.c
>>>>> +++ b/fs/ext4/mballoc.c
>>>>> @@ -4276,7 +4276,8 @@ static int ext4_mb_discard_preallocations(s=
truct
>>>>> super_block *sb, int needed)
>>>>> =A0* to usual allocation
>>>>> =A0*/
>>>>> =A0ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct ext4_allocation_request *ar, int
>>>>> *errp)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct ext4_allocation_request *ar, int
>>>>> *errp,
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int=
 flags)
>>>>> =A0{
>>>>> =A0 =A0 =A0 =A0int freed;
>>>>> =A0 =A0 =A0 =A0struct ext4_allocation_context *ac =3D NULL;
>>>>> @@ -4303,7 +4304,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *h=
andle,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * there is enough free blocks to =
do block allocation
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * and verify allocation doesn't e=
xceed the quota
>>>>> limits.
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (ar->len&& =A0ext4_claim_free=
_blocks(sbi, ar->len))
>>>>> {
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (ar->len&& =A0ext4_claim_free=
_blocks(sbi, ar->len,
>>>>> flags)) {
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* let others to f=
ree the space */
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0yield();
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ar->len =3D ar->le=
n>> =A01;
>>>>> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
>>>>> index b545ca1..2d9b12c 100644
>>>>> --- a/fs/ext4/xattr.c
>>>>> +++ b/fs/ext4/xattr.c
>>>>> @@ -821,7 +821,7 @@ inserted:
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0go=
al =3D goal& =A0EXT4_MAX_BLOCK_FILE_PHYS;
>>>>>
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block =3D ext4_new=
_meta_blocks(handle, inode,
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goal, NULL,&error);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goal, NULL,&error,
>>>>> 0);
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (error)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0go=
to cleanup;
>>>>>
>>>>> --
>>>>> 1.7.1
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>>
>>>>
>>>
>>>
>>>
>>> --
>>> Best Wishes
>>> Yongqiang Yang
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> Hi All,
>
> I did some looking around with the idea of using an allocation_reques=
t
> instead of a flags parameter, but I noticed that ext4_new_meta_blocks=
 is
> already setting up an allocation_request to pass to ext4_mb_new_block=
s.
> =A0Would it make sense then that we add an "ar_flags" parameter inste=
ad of a
> "flag" or another "ar" parameter? =A0That way, ext4_new_meta_blocks c=
an just
> add the flags to the ar that it already has, and we wouldn't have to =
change
> the ext4_mb_new_blocks parameters. =A0And then USE_ROOTBLKS can be ad=
ded on to
> the EXT4_MB_HINT scheme instead of starting a new scheme. =A0That wou=
ld avoid
> the extra ar initializing. What does everybody think? =A0Would this w=
ork for
> the HINT_COWING flag?

I think this would be perfect.
ext4_new_meta_blocks() is not much more than a helper to setup the ar s=
truct,
so passing 'flags' (in that context I see no reason to call it
ar_flags) to it makes sense.
The important thing is that USE_ROOTBLKS is added to the EXT4_MB_HINT s=
cheme
and passed all the way down to has_free_blocks with the 'ar' struct.

This discussion makes me wonder (CC'ing Jan and Eric for that), wasn't
there ever an intention
to allow the use of reserved space for allocation of any metadata block=
s?
The use case is delayed allocation combined with async mmap writes.
Do we always account for enough metadata blocks when doing delayed allo=
cation?
Both for extent and indirect mapped files?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
