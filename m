From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Thu, 1 Mar 2012 14:35:57 +0100
Message-ID: <CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
	<CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
	<20120229144244.GF5054@shiny>
	<CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	lczerner@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64204 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2CANf7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Mar 2012 08:35:59 -0500
In-Reply-To: <CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/2/29 Jacek Luczak <difrost.kernel@gmail.com>:
> 2012/2/29 Chris Mason <chris.mason@oracle.com>:
>> On Wed, Feb 29, 2012 at 03:07:45PM +0100, Jacek Luczak wrote:
>>
>> [ btrfs faster than ext for find and cp -a ]
>>
>>> 2012/2/29 Jacek Luczak <difrost.kernel@gmail.com>:
>>>
>>> I will try to answer the question from the broken email I've sent.
>>>
>>> @Lukas, it was always a fresh FS on top of LVM logical volume. I've
>>> been cleaning cache/remounting to sync all data before (re)doing
>>> tests.
>>
>> The next step is to get cp -a out of the picture, in this case you're
>> benchmarking both the read speed and the write speed (what are you
>> copying to btw?).
>
> It's simple cp -a Jenkins{,.bak} so dir to dir copy on same volume.
>
>> Using tar cf /dev/zero <some_dir> is one way to get a consistent picture
>> of the read speed.
>
> IMO the problem is not - only - in read speed. The directory order hit
> here. There's a difference in the sequential tests that place btrfs as
> the winner but still this should not have that huge influence on
> getdents. I know a bit on the difference between ext4 and btrfs
> directory handling and I would not expect that huge difference. On the
> production system where the issue has been observed doing some real
> work in the background copy takes up to 4h.
>
> For me btrfs looks perfect here, what could be worth checking is the
> change of timing in syscall between 39.4 and 3.2.7. Before getdents
> was not that high on the list while now it jumps to second position
> but without huge impact on the timings.
>
>> You can confirm the theory that it is directory order causing problems
>> by using acp to read the data.
>>
>> http://oss.oracle.com/~mason/acp/acp-0.6.tar.bz2
>
> Will check this still today and report back.
>

While I was about to grab acp I've noticed seekwatcher with made my day :)

seekwatcher run of tar cf to eliminate writes (all done on 3.2.7):
1) btrfs: http://dozzie.jarowit.net/~dozzie/luczajac/tar_btrfs.png
2) ext4: http://dozzie.jarowit.net/~dozzie/luczajac/tar_ext4.png
3) both merged: http://dozzie.jarowit.net/~dozzie/luczajac/tar_btrfs_ext4.png

I will send acp results soon.

-Jacek
