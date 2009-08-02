From: Mark Lord <lkml@rtr.ca>
Subject: ext4 ioctl(FIEMAP) bug? observed in 2.6.29.4 (32-bit x86)
Date: Sun, 02 Aug 2009 17:35:24 -0400
Message-ID: <4A76069C.1010801@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:39986 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbZHBVfZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Aug 2009 17:35:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have been stressing out the FIEMAP ioctl() quite a bit recently,
while working on the wiper.sh SSD TRIM utility (part of the hdparm package).

For an hour or so today, things got very confusing.
My wiper.sh script stopped working correctly, and I narrowed
it down to FIEMAP's incorrect use of the "LAST" flag.

Normally, FIEMAP signals the final extent of a file by
setting the "LAST" bit (bit-0) in flags.
When the application sees this flag, it knows it should
not need to issue any more FIEMAP calls.

But suddenly, for a couple of hours today, FIEMAP began
setting the "LAST" flag on every single FIEMAP call,
tricking my code into thinking that the file being
queried was a lot smaller than it really was.

No strace(), because I still hadn't figured-out what was going on,
but I did save this trace from debug code inside hdparm.

The file being FIEMAP'd was a 50GB+ file, filling the ext4
filesystem to near 100% capacity.  I have no idea what caused
FIEMAP to misbehave, but after a couple of hours it suddenly
started working correctly again.

This was all observed on 32-bit x86 Linux-2.6.29.4,
and no, it is not reproduceable.

A command-line "sync" was done before the file was
opened for FIEMAP.

The output below shows the sequence of FIEMAP calls
on the single massive file.  Notice that the first call
returned the "LAST" flag set, despite there being many
many more extents after that bunch.

Cheers

ioctl(FIEMAP) returned 57 extents
log=0 phy=6543114240 len=16777216 flags=0x800
log=16777216 phy=48435822592 len=8388608 flags=0x800
log=25165824 phy=48452599808 len=8388608 flags=0x800
...
log=3917479936 phy=70330089472 len=125829120 flags=0x800
log=4043309056 phy=70455918592 len=125829120 flags=0x800
log=4169138176 phy=70581747712 len=125829120 flags=0x801 <<== BUG!
ioctl(FIEMAP) returned 204 extents
log=4294967296 phy=70707576832 len=125829120 flags=0x800
...
log=29469179904 phy=100050927616 len=125829120 flags=0x800
ioctl(FIEMAP) returned 204 extents
log=29595009024 phy=100176756736 len=125829120 flags=0x800
...
log=45743718400 phy=73115267072 len=102400 flags=0x800
ioctl(FIEMAP) returned 204 extents
...
...
log=51256500224 phy=19321303040 len=4096 flags=0x800
log=51256504320 phy=19321757696 len=4096 flags=0x800
ioctl(FIEMAP) returned 176 extents
log=51256508416 phy=19325272064 len=4096 flags=0x800
...
log=51262967808 phy=102504951808 len=36864 flags=0x800
log=51263004672 phy=102518059008 len=36864 flags=0x800
log=51263041536 phy=107746783232 len=20480 flags=0x801  << CORRECT
ioctl(FIEMAP) returned 0 extents
