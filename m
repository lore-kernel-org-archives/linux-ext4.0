From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: Ext4: deadlock occurs when running fsstress and ENOSPC errors are seen.
Date: Tue, 22 Apr 2014 11:19:32 +0530
Message-ID: <CADDb1s3veuMeiYVOzEz0wuwObH7rTWPqNxzMUiYWqm1xcPN=uA@mail.gmail.com>
References: <CADDb1s2RvN_S+abFXCe4ZhZPKZgP_PiocJdpiLzRC_Se5sgVVg@mail.gmail.com>
	<20140415124743.GD3403@thunk.org>
	<CADDb1s3HYDvb51Ngrwk82gkpbUWg1bRo7kaUmbGRmb0g_9JKgw@mail.gmail.com>
	<20140416050729.GD21807@thunk.org>
	<CADDb1s3CnQJyY4f1xS6a=+ceE3cr0ZmkE1EQZ95fLDBw7DHfNg@mail.gmail.com>
	<20140416174652.GA8793@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51279 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaDVFte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2014 01:49:34 -0400
In-Reply-To: <20140416174652.GA8793@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick,

Thanks for the reply, sorry for responding late.

On Wed, Apr 16, 2014 at 11:16 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Apr 16, 2014 at 01:21:34PM +0530, Amit Sahrawat wrote:
>> Sorry Ted, if it caused the confusion.
>>
>> There were actually 2 parts to the problem, the logs in the first ma=
il
>> were from the original situation =E2=80=93 where in there were many =
block
>> groups and error prints also showed that.
>>
>> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1493,=
 0
>> clusters in bitmap, 58339 in gd
>> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1000,=
 0
>> clusters in bitmap, 3 in gd
>> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1425,=
 0
>> clusters in bitmap, 1 in gd
>> JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). T=
here's
>> a risk of filesystem corruption in case of system crash.
>> JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). T=
here's
>> a risk of filesystem corruption in case of system crash.
>>
>> 1)    Original case =E2=80=93 when the disk got corrupted and we onl=
y had the
>> logs and the hung task messages. But not the HDD on which issue was
>> observed.
>> 2)    In order to reproduce the problem as was coming through the lo=
gs
>> (which highlighted the problem in the bitmap corruption). To minimiz=
e
>> the environment and make a proper case, we created a smaller partiti=
on
>> size and with only 2 groups. And intentionally corrupted the group 1
>> (our intention was just to replicate the error scenario).
>
> I'm assuming that the original broken fs simply had a corrupt block b=
itmap, and
> that the dd thing was just to simulate that corruption in a testing
> environment?

Yes, we did so in order to replicate the error scenario.
>
>> 3)    After corruption we used =E2=80=98fsstress=E2=80=99  - we got =
the similar problem
>> as was coming the original logs. =E2=80=93 We shared our analysis af=
ter this
>> point for looping in the writepages part the free blocks mismatch.
>
> Hm.  I tried it with 3.15-rc1 and didn't see any hangs.  Corrupt bitm=
aps shut
> down allocations from the block group and the FS continues, as expect=
ed.
>
We are using kernel version 3.8, so cannot switch to 3.15-rc1. It is a
limitation currently.

>> 4)    We came across =E2=80=98Darrick=E2=80=99 patches(in which it a=
lso mentioned about
>> how to corrupt to reproduce the problem) and applied on our
>> environment. It solved the initial problem about the looping in
>> writepages, but now we got hangs at other places.
>
> There are hundreds of Darrick patches ... to which one are you referr=
ing? :)
> (What was the subject line?)
>
ext4: error out if verifying the block bitmap fails
ext4: fix type declaration of ext4_validate_block_bitmap
ext4: mark block group as corrupt on block bitmap error
ext4: mark block group as corrupt on inode bitmap error
ext4: mark group corrupt on group descriptor checksum
ext4: don't count free clusters from a corrupt block group

So, the patches helps in marking the block group as corrupt and avoids
further allocation. But when we consider the normal write path using
write_begin. Since, there is mismatch between the free cluster count
from the group descriptor and the bitmap. In that case it marks the
pages dirty by copying dirty but later it get ENOSPC from the
writepages when it actually does the allocation.

So, our doubt is if we are marking the block group as corrupt, we
should also subtract the block group count from the
s_freeclusters_counter. This will make sure we have the valid
freecluster count and error =E2=80=98ENOSPC=E2=80=99 can be returned fr=
om the
write_begin, instead of propagating such paths till the writepages.

We made change like this:

@@ -737,14 +737,18 @@ void ext4_mb_generate_buddy(struct super_block *s=
b,
        grp->bb_fragments =3D fragments;

        if (free !=3D grp->bb_free) {
+               struct ext4_sb_info *sbi =3D EXT4_SB(sb);
                ext4_grp_locked_error(sb, group, 0, 0,
                                      "%u clusters in bitmap, %u in gd;=
 "
                                      "block bitmap corrupt.",
                                      free, grp->bb_free);
                /*
                 * If we intend to continue, we consider group descript=
or
                 * corrupt and update bb_free using bitmap value
                 */
+               percpu_counter_sub(&sbi->s_freeclusters_counter, grp->b=
b_free);
                grp->bb_free =3D free;
                set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_s=
tate);
        }
        mb_set_largest_free_order(sb, grp);

Is this the correct method? Or are missing something in this? Please
share your opinion.


>> Using =E2=80=98tune2fs=E2=80=99 is not a viable solution in our case=
, we can only
>> provide the solution via. the kernel changes. So, we made the change=
s
>> as shared earlier.
>
> Would it help if you could set errors=3Dremount-ro in mke2fs?
>
Sorry, we cannot reformat or use tune2fs to change the =E2=80=98errors=E2=
=80=99 value.

> --D
>> So the question isn't how the file system got corrupted, but that
>> you'd prefer that the system recovers without hanging after this
>> corruption.
>> >> Yes,  our priority is to keep the system running.
>>
>> Again, Sorry for the confusion. But the intention was just to show t=
he
>> original problem and what we did in order to replicate the problem.
>>
>> Thanks & Regards,
>> Amit Sahrawat
>>
>>
>> On Wed, Apr 16, 2014 at 10:37 AM, Theodore Ts'o <tytso@mit.edu> wrot=
e:
>> > On Wed, Apr 16, 2014 at 10:30:10AM +0530, Amit Sahrawat wrote:
>> >> 4)    Corrupt the block group =E2=80=981=E2=80=99  by writing all=
 =E2=80=981=E2=80=99, we had one file
>> >> with all 1=E2=80=99s, so using =E2=80=98dd=E2=80=99 =E2=80=93
>> >> dd if=3Di_file of=3D/dev/sdb1 bs=3D4096 seek=3D17 count=3D1
>> >> After this mount the partition =E2=80=93 create few random size f=
iles and then
>> >> ran =E2=80=98fsstress,
>> >
>> > Um, sigh.  You didn't say that you were deliberately corrupting th=
e
>> > file system.  That wasn't in the subject line, or anywhere else in=
 the
>> > original message.
>> >
>> > So the question isn't how the file system got corrupted, but that
>> > you'd prefer that the system recovers without hanging after this
>> > corruption.
>> >
>> > I wish you had *said* that.  It would have saved me a lot of time,
>> > since I was trying to figure out how the system had gotten so
>> > corrupted (not realizing you had deliberately corrupted the file
>> > system).
>> >
>> > So I think if you run "tune2fs -e remount-ro /dev/sdb1" before you
>> > started the fsstress, the file system would have remounted the
>> > filesystem read-only at the first EXT4-fs error message.  This wou=
ld
>> > avoid the hang that you saw, since the file system would hopefully
>> > "failed fast", before th euser had the opportunity to put data int=
o
>> > the page cache that would be lost when the system discovered there=
 was
>> > no place to put the data.
>> >
>> > Regards,
>> >
>> >                                                 - Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
