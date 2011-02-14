From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH][RFC] ext4: avoid taking down_read(&grp->alloc_sem)
Date: Mon, 14 Feb 2011 14:08:48 +0200
Message-ID: <AANLkTi=pdJ+JyVubimd-d=thvQ7CcxrzprrFBsf-VhXu@mail.gmail.com>
References: <AANLkTimUmo5v14oKodaBKFtZPEHHuR9kZS5OSVtEFj2c@mail.gmail.com>
	<8739nrc642.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41166 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab1BNMI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 07:08:56 -0500
Received: by qyk12 with SMTP id 12so3771614qyk.19
        for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 04:08:55 -0800 (PST)
In-Reply-To: <8739nrc642.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 14, 2011 at 11:34 AM, Aneesh Kumar K. V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Wed, 9 Feb 2011 12:05:11 +0200, "Amir G." <amir73il@users.sourcefo=
rge.net> wrote:
>> Hi Aneesh,
>>
>> As you are signed off on most of the recent alloc_sem related code c=
hanges,
>> can you please comment on the patch below, which tries to avoid taki=
ng
>> the read lock most of the times on a 4K block fs.
>>
>> Can anyone tell what performance impact (if any) will be caused by a=
voiding
>> the read lock on most allocations? group spin lock will still be tak=
en, but for
>> much shorter periods of time (cycles).
>>
>> Any ideas how this patch can be properly tested?
>
> A quick check says the changes are correct. But i am not sure whether=
 we
> want to conditionalize these locks unless they appear as highly
> contented locks in a profile.
>

Hi Aneesh,

In general, I would agree with your statement about not conditioning lo=
cks,
but in this case, the condition for locking is not only unlikely(), but=
 0,
in the VERY common use case of 4K block.
So keeping the lock for the sake of generalization seems just wrong.

Unfortunately, I do not have a large scale SMP system under my hands to
find out exactly how contended is grp->alloc_sem, but I expect will be
contended in situations of fragmented block groups, where finding a goo=
d
extend requires searching over several block groups, without ever takin=
g
ext4_lock_group().

=46urthermore, I actually need this patch to resolve lock dependencies =
in my
snapshots implementation, so this is not just a "do the right thing" ar=
gument.

Besides, e4b->alloc_semp is already tested in any other place in the co=
de,
except for the 3 places I added in the patch, so it not like the condit=
ion is
complicating the code.

=46or the case of last block group, maybe it would be more readable
to change s_resize_lock to s_resize_sem and take
down_read(&sb->s_resize_sem) when loading buddy of last group or more
accurately, extend-able last group.

We can have also have ext4_mb_good_group() only allow allocation from
extend-able last group for MB_HINT_DATA allocations or make it availabl=
e
via another allocation hint.
(I don't intend to allow it for snapshot COW allocations)

=46inally, I would consider changing grp->alloc_sem to grp->init_sem,
as the name is misleading people to believe it is protecting against co=
ncurrent
allocations, while it is really protecting against concurrent init of
buddy cache.
grp->init_sem may also be a more appropriate name for its other use for
protecting concurrent lazy inode table init and inode allocations.

Thanks a lot for taking the time to review my patch,
Amir.

>>
>> Thanks,
>> Amir.
>>
>> grp->alloc_sem is used to synchronize buddy cache users with buddy c=
ache init
>> of other groups that use the same buddy cache page and with adding b=
locks to
>> group on online resize.
>>
>> When blocks_per_page <=3D 2, each group has it's own private buddy c=
ache page
>> so taking the read lock for every allocation is futile and can be av=
oided for
>> every group, but the last one.
>>
>> The write lock is taken in ext4_mb_init_group() and in ext4_add_grou=
pblocks()
>> to synchronize the buddy cache init of a group on first time allocat=
ion after
>> mount and after extending the last group.
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>> ---
>> =A0fs/ext4/mballoc.c | =A0 19 +++++++++++++++----
>> =A01 files changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 1b3256b..22a5251 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -1160,7 +1160,15 @@ ext4_mb_load_buddy(struct super_block *sb,
>> ext4_group_t group,
>> =A0 =A0 =A0 e4b->bd_group =3D group;
>> =A0 =A0 =A0 e4b->bd_buddy_page =3D NULL;
>> =A0 =A0 =A0 e4b->bd_bitmap_page =3D NULL;
>> - =A0 =A0 e4b->alloc_semp =3D &grp->alloc_sem;
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* We only need to take the read lock if other groups sh=
are the buddy
>> + =A0 =A0 =A0* page with this group or if blocks may be added to thi=
s (last) group
>> + =A0 =A0 =A0* by ext4_group_extend().
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (blocks_per_page > 2 || group =3D=3D sbi->s_groups_coun=
t - 1)
>
>
> If we can say groups_per_page > 1 that would make it more clear.
>

I agree. I just wanted to keep my patch 2 lines shorter ;-)

>> + =A0 =A0 =A0 =A0 =A0 =A0 e4b->alloc_semp =3D &grp->alloc_sem;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 e4b->alloc_semp =3D NULL;
>>
>> =A0 =A0 =A0 /* Take the read lock on the group alloc
>> =A0 =A0 =A0 =A0* sem. This would make sure a parallel
>> @@ -1169,7 +1177,8 @@ ext4_mb_load_buddy(struct super_block *sb,
>> ext4_group_t group,
>> =A0 =A0 =A0 =A0* till we are done with allocation
>> =A0 =A0 =A0 =A0*/
>> =A0repeat_load_buddy:
>> - =A0 =A0 down_read(e4b->alloc_semp);
>> + =A0 =A0 if (e4b->alloc_semp)
>> + =A0 =A0 =A0 =A0 =A0 =A0 down_read(e4b->alloc_semp);
>>
>> =A0 =A0 =A0 if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we need to check for group need init =
flag
>> @@ -1177,7 +1186,8 @@ repeat_load_buddy:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* that new blocks didn't get added to=
 the group
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* when we are loading the buddy cache
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 up_read(e4b->alloc_semp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (e4b->alloc_semp)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_read(e4b->alloc_semp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we need full data about the group
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to make a good selection
>> @@ -1277,7 +1287,8 @@ err:
>> =A0 =A0 =A0 e4b->bd_bitmap =3D NULL;
>>
>> =A0 =A0 =A0 /* Done with the buddy cache */
>> - =A0 =A0 up_read(e4b->alloc_semp);
>> + =A0 =A0 if (e4b->alloc_semp)
>> + =A0 =A0 =A0 =A0 =A0 =A0 up_read(e4b->alloc_semp);
>> =A0 =A0 =A0 return ret;
>> =A0}
>>
>
> -aneesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
