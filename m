From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH][RFC] ext4: avoid taking down_read(&grp->alloc_sem)
Date: Mon, 14 Feb 2011 09:52:25 +0200
Message-ID: <AANLkTimgCcW0fQzQ3W=vhkTSWt=0=xPoaBucrM=mfHXG@mail.gmail.com>
References: <AANLkTimUmo5v14oKodaBKFtZPEHHuR9kZS5OSVtEFj2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43396 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1BNHw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 02:52:26 -0500
Received: by qwa26 with SMTP id 26so2903532qwa.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Feb 2011 23:52:25 -0800 (PST)
In-Reply-To: <AANLkTimUmo5v14oKodaBKFtZPEHHuR9kZS5OSVtEFj2c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I have checked myself over and over again and I always end up at the
same conclusion:

grp->alloc_sem is NOT NEEDED after buddy of non-last group has been ini=
tialized!

I see you have been busy with cleaning up the buffered write submission=
s path,
removing unneeded locks among other improvements.

I would help reviewing your patches, but I find following delayed
allocation code
way more complicated than following mballoc code ;-).

Anyway, if you have some time now, please try to verify my (simple)
patch, which:
"should improve performance and improve SMP scalability ...
 in the best way possible --- don't take locks when they aren't needed!=
"

I believe that in some workloads the buddy cache can be frequently load=
ed
without eventually allocating blocks from that group (no matching
extent found etc)
and it is in those  workloads, where we should see the most benefit
from not taking
grp->alloc_sem on mb_load_buddy().

Amir.

On Wed, Feb 9, 2011 at 12:05 PM, Amir G. <amir73il@users.sourceforge.ne=
t> wrote:
> Hi Aneesh,
>
> As you are signed off on most of the recent alloc_sem related code ch=
anges,
> can you please comment on the patch below, which tries to avoid takin=
g
> the read lock most of the times on a 4K block fs.
>
> Can anyone tell what performance impact (if any) will be caused by av=
oiding
> the read lock on most allocations? group spin lock will still be take=
n, but for
> much shorter periods of time (cycles).
>
> Any ideas how this patch can be properly tested?
>
> Thanks,
> Amir.
>
> grp->alloc_sem is used to synchronize buddy cache users with buddy ca=
che init
> of other groups that use the same buddy cache page and with adding bl=
ocks to
> group on online resize.
>
> When blocks_per_page <=3D 2, each group has it's own private buddy ca=
che page
> so taking the read lock for every allocation is futile and can be avo=
ided for
> every group, but the last one.
>
> The write lock is taken in ext4_mb_init_group() and in ext4_add_group=
blocks()
> to synchronize the buddy cache init of a group on first time allocati=
on after
> mount and after extending the last group.
>
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> ---
> =A0fs/ext4/mballoc.c | =A0 19 +++++++++++++++----
> =A01 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 1b3256b..22a5251 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1160,7 +1160,15 @@ ext4_mb_load_buddy(struct super_block *sb,
> ext4_group_t group,
> =A0 =A0 =A0 =A0e4b->bd_group =3D group;
> =A0 =A0 =A0 =A0e4b->bd_buddy_page =3D NULL;
> =A0 =A0 =A0 =A0e4b->bd_bitmap_page =3D NULL;
> - =A0 =A0 =A0 e4b->alloc_semp =3D &grp->alloc_sem;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* We only need to take the read lock if other groups=
 share the buddy
> + =A0 =A0 =A0 =A0* page with this group or if blocks may be added to =
this (last) group
> + =A0 =A0 =A0 =A0* by ext4_group_extend().
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (blocks_per_page > 2 || group =3D=3D sbi->s_groups_c=
ount - 1)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 e4b->alloc_semp =3D &grp->alloc_sem;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 e4b->alloc_semp =3D NULL;
>
> =A0 =A0 =A0 =A0/* Take the read lock on the group alloc
> =A0 =A0 =A0 =A0 * sem. This would make sure a parallel
> @@ -1169,7 +1177,8 @@ ext4_mb_load_buddy(struct super_block *sb,
> ext4_group_t group,
> =A0 =A0 =A0 =A0 * till we are done with allocation
> =A0 =A0 =A0 =A0 */
> =A0repeat_load_buddy:
> - =A0 =A0 =A0 down_read(e4b->alloc_semp);
> + =A0 =A0 =A0 if (e4b->alloc_semp)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 down_read(e4b->alloc_semp);
>
> =A0 =A0 =A0 =A0if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we need to check for group need ini=
t flag
> @@ -1177,7 +1186,8 @@ repeat_load_buddy:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * that new blocks didn't get added to=
 the group
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * when we are loading the buddy cache
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_read(e4b->alloc_semp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (e4b->alloc_semp)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_read(e4b->alloc_semp=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * we need full data about the group
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * to make a good selection
> @@ -1277,7 +1287,8 @@ err:
> =A0 =A0 =A0 =A0e4b->bd_bitmap =3D NULL;
>
> =A0 =A0 =A0 =A0/* Done with the buddy cache */
> - =A0 =A0 =A0 up_read(e4b->alloc_semp);
> + =A0 =A0 =A0 if (e4b->alloc_semp)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_read(e4b->alloc_semp);
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> --
> 1.7.0.4
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
