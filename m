From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 7 Jun 2011 16:01:21 +0300
Message-ID: <BANLkTikOrw-5TvL6VE8XHgc7Om=X-w3mkA@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
	<BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com>
	<4DECF2D5.7050408@redhat.com>
	<20110606205512.GE20818@thunk.org>
	<BD378E74-754D-45FF-9F65-EFAF8436BBFD@dilger.ca>
	<BANLkTin5WLnvaZtpym9896wWwscUetQy0Q@mail.gmail.com>
	<alpine.LFD.2.00.1106071205530.4754@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, "Ted Ts'o" <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38366 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1FGNBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 09:01:23 -0400
Received: by wwa36 with SMTP id 36so4901775wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 06:01:22 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106071205530.4754@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 7, 2011 at 1:09 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Tue, 7 Jun 2011, Amir G. wrote:
>
>> On Tue, Jun 7, 2011 at 8:17 AM, Andreas Dilger <adilger@dilger.ca> w=
rote:
>> > On 2011-06-06, at 2:55 PM, Ted Ts'o wrote:
>> >> On Mon, Jun 06, 2011 at 10:31:33AM -0500, Eric Sandeen wrote:
>> >>>> For one reason, a snapshot file format is currently an indirect=
 file
>> >>>> and big_alloc doesn't support indirect mapped files.
>> >>>> I am not saying it cannot be done, but if it does, there would =
be
>> >>>> several obstacles to cross.
>> >>>
>> >>> I know I'm kind of just throwing a bomb out here, but I am very =
concerned
>> >>> about the ever-growing feature (in)compatibility matrix in ext4.
>> >>
>> >> bigalloc doesn't support indirect blocks mainly because it was fa=
ster
>> >> to get things working if I didn't have to worry about indirect bl=
ocks.
>> >> It wouldn't be _that_ hard to make bigalloc work on indirect bloc=
ks.
>> >> I'll get around to it at some point.
>> >
>> > My main concern isn't about whether bigalloc grows support for ind=
irect-
>> > mapped files, but rather the opposite - that snapshots gain suppor=
t for
>> > extent-mapped files. =A0In fact, since extent-mapped files can be =
16TB in
>> > size, it might make sense that the snapshots are _always_ extent-m=
apped
>> > files, and we don't need to deal with the new block-mapped files w=
ith
>> > 4-triple-indirect blocks layout at all? =A0Since snapshots are onl=
y going
>> > into ext4, and ext4 + e2fsprogs already support extents, there wou=
ldn't
>> > be any issue about compatibility?
>> >
>> > The only concern might be that mapping fragmented files into exten=
ts is
>> > more effort, which makes me wonder about whether we should introdu=
ce the
>> > "block-mapped extents" that I proposed in the past, to allow effic=
ient
>> > mapping of files (or parts thereof) that are highly fragmented, bu=
t still
>> > keeping the benefits of extents (internal redundancy, 48-bit physi=
cal
>> > block numbers, and while we are adding a new extent format it coul=
d be
>> > designed to add 48-bit logical block numbers.
>> >
>>
>> You are right about snapshot file being a highly fragmented file by =
design,
>> so single block mapping is an advantage. The down side is that delet=
ing
>> an extent mapped file, requires mapping all blocks one-by-one to sna=
pshot
>> file, which is not efficient and makes deletes slow.
>> So having a format optimized for both single and multi block mapping=
 would be
>> best.
>>
>> The reason I DO NOT want to change the snapshot file format at this =
moment
>> is that it will make us lose all the stabilization that snapshot fea=
ture gained
>> during 1 year in production as next3.
>> You see, ext4_free_blocks() cares not if blocks are deleted from ind=
irect or
>> extent mapped files and from there on, the code that maps those bloc=
ks to
>> the special snapshot file is the same in next3 and ext4.
>>
>
> But the problem is, that you will not be able to change it in the fut=
ure
> or at least not without adding more incompatibility flags, which is
> exactly the point of this thread. I just wonder if it would not be
> better to do it now, because now is the right time. Although I do not
> know how much work will that require.
>

There are no compatibility issues.
ext4 fs is either 32bit or 64bit and you cannot convert between the 2 f=
ormats.
32bit ext4 has snapshots support with indirect mapped snapshot files.
64bit ext4 has no snapshots support.
if in the future, be it near or far, 64bit ext4 will have snapshots sup=
port with
a new snapshot file format, then 64bit feature + snapshots feature will
prevent the present (i.e. next) kernel from mouting that fs rw.
which is exactly the same as older kernel will prevent mounting a 32bit=
 ext4
with snapshots rw.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
