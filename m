From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: IO error semantics
Date: Mon, 25 Jan 2010 11:15:50 -0500
Message-ID: <87f94c371001250815t92cbce9t95df5c274745dae9@mail.gmail.com>
References: <4B4EB5B9.4020809@hitachi.com> <4B4EDE5C.8040600@hitachi.com>
	 <4B4EEE86.7080807@hitachi.com> <20100114141803.GB3146@quack.suse.cz>
	 <20100118051847.GA8678@laptop> <20100118060518.GA9151@laptop>
	 <20100118122437.GF7264@discord.disaster>
	 <20100118140039.GA13909@laptop>
	 <D65C918F-8CCD-4626-BA84-FD0410A5E81F@cam.ac.uk>
	 <4B5DB78D.2090408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
	Nick Piggin <npiggin@suse.de>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	linux-fsdevel@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f186.google.com ([209.85.223.186]:45928 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab0AYQP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jan 2010 11:15:57 -0500
In-Reply-To: <4B5DB78D.2090408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 25, 2010 at 10:23 AM, Ric Wheeler <rwheeler@redhat.com> wro=
te:
> On 01/18/2010 06:33 PM, Anton Altaparmakov wrote:
>>
>> Hi,
>>
>> On 18 Jan 2010, at 14:00, Nick Piggin wrote:
>>
>>>
>>> For write errors, you could also do block re-allocation, which woul=
d be
>>> fun.
>>>
>>
>> Yes it would. =A0(-:
>>
>> FWIW, Windows does this with Microsoft's NTFS driver. =A0When a writ=
e fails
>> due to a bad block, the block is marked as bad (recorded in the bad =
cluster
>> list and marked as allocated in the in-use bitmap so no-one tries to
>> allocate it), a new block is allocated, inode metadata is updated to=
 reflect
>> the change in the logical to physical block map of the file the bloc=
k
>> belongs to, and the write is then re-tried to its new location.
>>
>> I have never bothered implementing it in NTFS on Linux partially bec=
ause
>> there doesn't seem any obvious way to do it inside the file system. =
=A0I think
>> the VFS and/or the block layer would have to offer help there in som=
e way.
>> =A0What I mean for example is that if ->writepage fails then the fai=
lure is
>> only detected inside the asynchronous i/o completion handler at whic=
h point
>> the page is not locked any more, it is marked as being under writeba=
ck, and
>> we are in IRQ context (or something) and thus it is not easy to see =
how we
>> can from there get to doing all the above needed actions that requir=
e memory
>> allocations, disk i/o, etc... =A0I suppose a separate thread could d=
o it where
>> we just schedule the work to be done. =A0But problem with that is th=
at that
>> work later on might fail so we can't simply pretend the block was wr=
itten
>> successfully yet we do not want to report an error or the upper laye=
rs would
>> pick it up even though we hopefully will correct it in due course...
>>
>> Best regards,
>>
>> =A0 =A0 =A0 =A0Anton
>>
>
> For permanent write errors, I would expect any modern drive to do a s=
ector
> remapping internally. We should never need to track this kind of info=
rmation
> for any modern device that I know of (S-ATA, SAS, SSD's and raid arra=
ys
> should all handle this).
>
> Would not seem to be worth the complexity.
>
> Also keep in mind that retrying IO errors is not always a good thing =
