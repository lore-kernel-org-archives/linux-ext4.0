From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Mon, 6 Jun 2011 21:25:48 +0300
Message-ID: <BANLkTinzvYyqiVH9gFqoAz7uWqNdmXXXpA@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
	<BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com>
	<4DECF2D5.7050408@redhat.com>
	<77863E67-6DAF-491D-836D-09FCD379B81F@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57802 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab1FFSZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 14:25:50 -0400
Received: by wya21 with SMTP id 21so3003942wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jun 2011 11:25:49 -0700 (PDT)
In-Reply-To: <77863E67-6DAF-491D-836D-09FCD379B81F@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 6, 2011 at 7:33 PM, Andreas Dilger <aedilger@gmail.com> wro=
te:
> On 2011-06-06, at 9:31 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 6/6/11 9:32 AM, Amir G. wrote:
>>>
>>> For one reason, a snapshot file format is currently an indirect fil=
e
>>> and big_alloc
>>> doesn't support indirect mapped files.
>>> I am not saying it cannot be done, but if it does, there would be
>>> several obstacles
>>> to cross.
>>
>> I know I'm kind of just throwing a bomb out here, but I am very conc=
erned
>> about the ever-growing feature (in)compatibility matrix in ext4.
>
> I tend to agree. A new feature like this for ext4 that does not work =
the default features of ext4 (extents) means that it will not be usable=
 for the majority of users, but will make the code complex for all of t=
he developers.

Snapshots support extent mapped files, otherwise they would not be
considered for merging.
As Ted put it, as long as the feature support the 'default'/'common'
configuration options it
could be merged.

>
> Has any thought gone into how this feature could be implemented for e=
xtent-mapped files? =A0It seems that part of the problem is because the=
 snapshot "file" needs to be able to map the whole filesystem, which ne=
ither indirect-mapped nor extent-mapped files can do without changes.
>
> The current change is to allow indirect-mapped files to have an extra=
 triple-indirect block, which works up to 2^32 blocks (the same limit a=
s extent-mapped files) but this is not useful for filesystems over 2^32=
 blocks, which is another reason that ext4 was introduced.
>
> So, it seems the reason the 64bit feature is unsupported is really fo=
r filesystems larger than the maximum file size, and not for any other =
reason. Is that correct?

That is correct, see:
http://sourceforge.net/apps/mediawiki/next3/index.php?title=3DExt4_snap=
shots_TODO#Large_file_system_size_.2864bit_support.29

> Would that mean Ted's bigalloc patches will avoid this problem, or do=
 they not actually increase the maximum file size?

They don't increase the maximum file size, because with big_alloc the
extents map still has blocksize (e.g. 4k)
resolution.
Besides, one of the main principles of ext4 snapshots is
Move-on-write, which means there is no
read IO for COW.
There is no way to implement COW efficiently, if you have to read in
an entire (~1M) cluster when
writing a single (~4K) block. you may as well use LVM snapshots for tha=
t...


>
>> Take for example dioread_nolock caveats:
>>
>> =A0 =A0 =A0 =A0 =A0"However this does not work with nobh
>> =A0 =A0 =A0 =A0 =A0 option and the mount will fail.
>
> Does anyone actually use nobh? =A0I recall it was a performance tweak=
 fir ext3, but i think it was eclipsed by other improvements in ext4. =A0=
If nobody is using it anymore, we might consider removing it entirely, =
since it was only a mount-time option and did not affect the on-disk fo=
rmat.
>
> Does smolt return the filesystem mount options?
>
>> Nor does it work with
>> =A0 =A0 =A0 =A0 =A0 data journaling and dioread_nolock option will b=
e
>> =A0 =A0 =A0 =A0 =A0 ignored with kernel warning. Note that dioread_n=
olock
>> =A0 =A0 =A0 =A0 =A0 code path is only used for extent-based files."
>
> Does this mean that dioread_nolock isn't needed for indirect-mapped f=
iles, or that it will work incorrectly on indirect-mapped files, or onl=
y that they will use some less efficient code path? I don't recall the =
details if this option, but it seems that it was related to unwritten e=
xtents, in which case it is irrelevant to indirect-mapped files.
>
>> If ext4 matches the lifespan of ext3, in 10 years I fear that it wil=
l look
>> more like a collection of various individuals' pet projects, rather =
than
>> any kind of well-designed, cohesive project.
>>
>> How long can we really keep adding features which are semi- or wholl=
y-
>> incompatible with other features?
>>
>> Consider this a cry in the wilderness for less rushed feature introd=
uction,
>> and a more holistic approach to ext4 design...
>
> I agree. I am far less concerned with new features that are only avai=
lable to users of newly-formatted ext4 filesystems. What worries me is =
a feature that in NOT usable on new filesystems and may be dead code in=
 a couple of years.
>
> I'd be a lot more confident in its acceptance if there was at least a=
 design for how to move forward with this feature for filesystems with =
extents and 64bit support. I'd be happy with some co-requirement that b=
igalloc is needed for filesystems larger than 2^32 blocks (for example)=
, so that there is never a need to have a snapshot with more than 2^32 =
blocks.
>
> Doing this design work may point out some other solution which does n=
ot require the 4*triple-indirect block hack in the first place, and wil=
l improve the code in the long run.

The design in this case is quite one-way-to-go - that is defining a
new extent format with 48bit logical addresses.
There are 2 reasons I used the 4 tind blocks hack:
1. Historic - the patches come from next3 which needed 16TB volume supp=
ort
2. KISS - I don't know if you noticed, but the amount of lines in this
hack is very
small. both for ext4 and for libext2, the blk_to_path logic for
indirect mapped files
is very easy to modify, which makes the patch very easy to review.
see for yourself:
https://github.com/amir73il/e2fsprogs-snapshots/commit/75025f02f0991577=
94a75f22f86851707c1061b8

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
