From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 7 Jun 2011 17:39:04 +0300
Message-ID: <BANLkTinuwxVf8xx19n46QcoC0bVcxAnutQ@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
	<BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com>
	<4DECF2D5.7050408@redhat.com>
	<20110606205512.GE20818@thunk.org>
	<BD378E74-754D-45FF-9F65-EFAF8436BBFD@dilger.ca>
	<BANLkTin5WLnvaZtpym9896wWwscUetQy0Q@mail.gmail.com>
	<alpine.LFD.2.00.1106071205530.4754@dhcp-27-109.brq.redhat.com>
	<BANLkTikOrw-5TvL6VE8XHgc7Om=X-w3mkA@mail.gmail.com>
	<4DEE2CB2.8000908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, "Ted Ts'o" <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47707 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab1FGOjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 10:39:06 -0400
Received: by wya21 with SMTP id 21so3606936wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 07:39:04 -0700 (PDT)
In-Reply-To: <4DEE2CB2.8000908@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 7, 2011 at 4:50 PM, Ric Wheeler <ricwheeler@gmail.com> wrot=
e:
> On 06/07/2011 09:01 AM, Amir G. wrote:
>>
>> On Tue, Jun 7, 2011 at 1:09 PM, Lukas Czerner<lczerner@redhat.com> =A0=
wrote:
>>>
>>> On Tue, 7 Jun 2011, Amir G. wrote:
>>>
>>>> On Tue, Jun 7, 2011 at 8:17 AM, Andreas Dilger<adilger@dilger.ca>
>>>> =A0wrote:
>>>>>
>>>>> On 2011-06-06, at 2:55 PM, Ted Ts'o wrote:
>>>>>>
>>>>>> On Mon, Jun 06, 2011 at 10:31:33AM -0500, Eric Sandeen wrote:
>>>>>>>>
>>>>>>>> For one reason, a snapshot file format is currently an indirec=
t file
>>>>>>>> and big_alloc doesn't support indirect mapped files.
>>>>>>>> I am not saying it cannot be done, but if it does, there would=
 be
>>>>>>>> several obstacles to cross.
>>>>>>>
>>>>>>> I know I'm kind of just throwing a bomb out here, but I am very
>>>>>>> concerned
>>>>>>> about the ever-growing feature (in)compatibility matrix in ext4=
=2E
>>>>>>
>>>>>> bigalloc doesn't support indirect blocks mainly because it was f=
aster
>>>>>> to get things working if I didn't have to worry about indirect b=
locks.
>>>>>> It wouldn't be _that_ hard to make bigalloc work on indirect blo=
cks.
>>>>>> I'll get around to it at some point.
>>>>>
>>>>> My main concern isn't about whether bigalloc grows support for
>>>>> indirect-
>>>>> mapped files, but rather the opposite - that snapshots gain suppo=
rt for
>>>>> extent-mapped files. =A0In fact, since extent-mapped files can be=
 16TB in
>>>>> size, it might make sense that the snapshots are _always_ extent-=
mapped
>>>>> files, and we don't need to deal with the new block-mapped files =
with
>>>>> 4-triple-indirect blocks layout at all? =A0Since snapshots are on=
ly going
>>>>> into ext4, and ext4 + e2fsprogs already support extents, there wo=
uldn't
>>>>> be any issue about compatibility?
>>>>>
>>>>> The only concern might be that mapping fragmented files into exte=
nts is
>>>>> more effort, which makes me wonder about whether we should introd=
uce
>>>>> the
>>>>> "block-mapped extents" that I proposed in the past, to allow effi=
cient
>>>>> mapping of files (or parts thereof) that are highly fragmented, b=
ut
>>>>> still
>>>>> keeping the benefits of extents (internal redundancy, 48-bit phys=
ical
>>>>> block numbers, and while we are adding a new extent format it cou=
ld be
>>>>> designed to add 48-bit logical block numbers.
>>>>>
>>>> You are right about snapshot file being a highly fragmented file b=
y
>>>> design,
>>>> so single block mapping is an advantage. The down side is that del=
eting
>>>> an extent mapped file, requires mapping all blocks one-by-one to
>>>> snapshot
>>>> file, which is not efficient and makes deletes slow.
>>>> So having a format optimized for both single and multi block mappi=
ng
>>>> would be
>>>> best.
>>>>
>>>> The reason I DO NOT want to change the snapshot file format at thi=
s
>>>> moment
>>>> is that it will make us lose all the stabilization that snapshot f=
eature
>>>> gained
>>>> during 1 year in production as next3.
>>>> You see, ext4_free_blocks() cares not if blocks are deleted from
>>>> indirect or
>>>> extent mapped files and from there on, the code that maps those bl=
ocks
>>>> to
>>>> the special snapshot file is the same in next3 and ext4.
>>>>
>>> But the problem is, that you will not be able to change it in the f=
uture
>>> or at least not without adding more incompatibility flags, which is
>>> exactly the point of this thread. I just wonder if it would not be
>>> better to do it now, because now is the right time. Although I do n=
ot
>>> know how much work will that require.
>>>
>> There are no compatibility issues.
>> ext4 fs is either 32bit or 64bit and you cannot convert between the =
2
>> formats.
>> 32bit ext4 has snapshots support with indirect mapped snapshot files=
=2E
>> 64bit ext4 has no snapshots support.
>> if in the future, be it near or far, 64bit ext4 will have snapshots
>> support with
>> a new snapshot file format, then 64bit feature + snapshots feature w=
ill
>> prevent the present (i.e. next) kernel from mouting that fs rw.
>> which is exactly the same as older kernel will prevent mounting a 32=
bit
>> ext4
>> with snapshots rw.
>>
>> Amir.
>
> Hi Amir,
>
> I really am not comfortable with having two formats for snapshots.
>
> Why not just do one 64 bit format and skip the 32 bit one?

Well for 2 reasons mainly:
1. Something like that could hold back the feature further more
and maybe even to eternity and some people do want to use it
this lifetime.
2. There are performance implications that need to be studied.
An indirect format gives me the ability to maps blocks of different
block groups without taking a global lock (not doing that yet).
With extent tree format, a global lock is needed for re-balancing
the tree, so concurrent COW operations on different blocks
in different block groups are bound to contend the same global
lock, which is something I am trying to see if can be avoided.


>
> This seems like a recipe for end user confusion and pain :)
>

I honestly don't see how the internal format of a snapshot file
affects the end user in any way.
What happens in 32bit ext4 stays in 32bit ext4.
There is no migration of formats whatsoever to 64bit ext4.
The only pain caused by 2 formats is having to maintain
the code for 2 formats.
But the fact of the matter is that indirect mapped file code
is there to stay, so having the snapshot file use it for now,
is not much of a maintenance burden later.
All it takes is an EXTENT_FL flag to distinguish between
an indirect mapped snapshot to a future extent mapped (v2)
snapshot.

> thanks!
>
> Ric
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
