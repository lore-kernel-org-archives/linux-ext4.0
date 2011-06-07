From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 7 Jun 2011 08:58:06 +0300
Message-ID: <BANLkTin5WLnvaZtpym9896wWwscUetQy0Q@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
	<BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com>
	<4DECF2D5.7050408@redhat.com>
	<20110606205512.GE20818@thunk.org>
	<BD378E74-754D-45FF-9F65-EFAF8436BBFD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44460 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1FGF6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 01:58:08 -0400
Received: by wya21 with SMTP id 21so3293734wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jun 2011 22:58:06 -0700 (PDT)
In-Reply-To: <BD378E74-754D-45FF-9F65-EFAF8436BBFD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 7, 2011 at 8:17 AM, Andreas Dilger <adilger@dilger.ca> wrot=
e:
> On 2011-06-06, at 2:55 PM, Ted Ts'o wrote:
>> On Mon, Jun 06, 2011 at 10:31:33AM -0500, Eric Sandeen wrote:
>>>> For one reason, a snapshot file format is currently an indirect fi=
le
>>>> and big_alloc doesn't support indirect mapped files.
>>>> I am not saying it cannot be done, but if it does, there would be
>>>> several obstacles to cross.
>>>
>>> I know I'm kind of just throwing a bomb out here, but I am very con=
cerned
>>> about the ever-growing feature (in)compatibility matrix in ext4.
>>
>> bigalloc doesn't support indirect blocks mainly because it was faste=
r
>> to get things working if I didn't have to worry about indirect block=
s.
>> It wouldn't be _that_ hard to make bigalloc work on indirect blocks.
>> I'll get around to it at some point.
>
> My main concern isn't about whether bigalloc grows support for indire=
ct-
> mapped files, but rather the opposite - that snapshots gain support f=
or
> extent-mapped files. =A0In fact, since extent-mapped files can be 16T=
B in
> size, it might make sense that the snapshots are _always_ extent-mapp=
ed
> files, and we don't need to deal with the new block-mapped files with
> 4-triple-indirect blocks layout at all? =A0Since snapshots are only g=
oing
> into ext4, and ext4 + e2fsprogs already support extents, there wouldn=
't
> be any issue about compatibility?
>
> The only concern might be that mapping fragmented files into extents =
is
> more effort, which makes me wonder about whether we should introduce =
the
> "block-mapped extents" that I proposed in the past, to allow efficien=
t
> mapping of files (or parts thereof) that are highly fragmented, but s=
till
> keeping the benefits of extents (internal redundancy, 48-bit physical
> block numbers, and while we are adding a new extent format it could b=
e
> designed to add 48-bit logical block numbers.
>

You are right about snapshot file being a highly fragmented file by des=
ign,
so single block mapping is an advantage. The down side is that deleting
an extent mapped file, requires mapping all blocks one-by-one to snapsh=
ot
file, which is not efficient and makes deletes slow.
So having a format optimized for both single and multi block mapping wo=
uld be
best.

The reason I DO NOT want to change the snapshot file format at this mom=
ent
is that it will make us lose all the stabilization that snapshot featur=
e gained
during 1 year in production as next3.
You see, ext4_free_blocks() cares not if blocks are deleted from indire=
ct or
extent mapped files and from there on, the code that maps those blocks =
to
the special snapshot file is the same in next3 and ext4.

> In another email Amir G. wrote:
>> Andreas Dilger wrote:
>
>>> I'd be a lot more confident in its acceptance if there was at least=
 a design for how to move forward with this feature for filesystems wit=
h extents and 64bit support. I'd be happy with some co-requirement that=
 bigalloc is needed for filesystems larger than 2^32 blocks (for exampl=
e), so that there is never a need to have a snapshot with more than 2^3=
2 blocks.
>>>
>>> Doing this design work may point out some other solution which does=
 not require the 4*triple-indirect block hack in the first place, and w=
ill improve the code in the long run.
>>
>> The design in this case is quite one-way-to-go - that is defining a
>> new extent format with 48bit logical addresses.
>
> Agreed. =A0Is this something in your upcoming development plans, or j=
ust a
> feature that might be implemented some day?

To be honest, for me it was always in 'some day' category, but my
patron has already
asked me about supporting snapshots on >16TB volumes (with the move to =
ext4),
so that day may be coming after all.

>
>> There are 2 reasons I used the 4 tind blocks hack:
>> 1. Historic - the patches come from next3 which needed 16TB volume s=
upport
>> 2. KISS - I don't know if you noticed, but the amount of lines in th=
is
>> =A0 =A0hack is very small. both for ext4 and for libext2, the blk_to=
_path logic
>> =A0 =A0for indirect mapped files is very easy to modify, which makes=
 the patch
>> =A0 =A0very easy to review.
>
> Cheers, Andreas
>
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
