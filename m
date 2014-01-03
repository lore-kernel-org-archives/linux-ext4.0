From: "Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: RE: ext4 filesystem bad extent error review
Date: Fri, 3 Jan 2014 11:16:02 +0800
Message-ID: <AE39A478622CF340ABEC2418D74074F61FC59AC406@SGPMBX05.APAC.bosch.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
 <20140102184211.GC10870@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:38407 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaACDQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jan 2014 22:16:10 -0500
In-Reply-To: <20140102184211.GC10870@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Hi Ted,

>What I tell people who are using flash devices is before they start
>using any flash device, to do power drop testing on a raw device,
>without any file system present.  The simplest way to do this is to
>write a program that writes consecutive 4k blocks that contain a
>timestamp, a sequence number, some random data, and a CRC-32 checksum
>over the contents of the timestamp, sequence number, a flags word, and
>random data.  As the program writes such 4k block, it rolls the dice
>and once every 64 blocks or so (i.e., pick a random number, and see if
>it is divisible by 64), .....

It sounds like the barrier test. We wrote such kind test tool before, t=
he test program used ioctl(fd, BLKFLSBUF, 0) to set a barrier before ne=
xt write operation.
Do you think this ioctl is enough ? Because I saw the ext4 use it. I wi=
ll do the test with that tool and then let you know the result.=20

More information about journal block which caused the bad extents error=
:
We enabled the mount option journal_checksum in our test.  We reproduce=
d the same problem and the journal checksum is correct because the jour=
nal block will not be replayed if checksum is error.

Best Regards / Mit freundlichen Gr=FC=DFen

Huang weiliang

-----Original Message-----
=46rom: Theodore Ts'o [mailto:tytso@mit.edu]=20
Sent: Friday, January 03, 2014 2:42 AM
To: Huang Weller (CM/ESW12-CN)
Cc: linux-ext4@vger.kernel.org; Juergens Dirk (CM-AI/ECO2)
Subject: Re: ext4 filesystem bad extent error review

On Thu, Jan 02, 2014 at 12:59:52PM +0800, Huang Weller (CM/ESW12-CN) wr=
ote:
>=20
> We did more test which we backup the journal blocks  before we mount =
the test partition.
> Actually, before we mount the test partition, we use fsck.ext4 with -=
n option to verify whether there is any  bad extents issues available. =
The fsck.ext4 never found any such kind issue. And we can prove that th=
e bad extents issue is happened after journaling replay.

Ok, so that implies that the failure is almost certainly due to
corrupted blocks in the journal.  Hence, when we replay the journal,
it causes the the file system to become corrupted, because the "newer"
(and presumably, "more correct") metadata blocks found in the blocks
recorded in the journal are in fact corrupted.

BTW, you can use the logdump command in the debugfs program to look at
the journal.  The debugfs man page documents it, but once you know the
block that was corrupted, which in your case appears to be block 525:

debugfs: logdump -b 525 -c

Or to see the contents of all of the blocks logged in the journal:

debugfs: logdump -ac

>=20
> We  searched such error on internet, there are some one also has such=
 issue. But there is no solution.
> This issue maybe not a big issue which it can be repaired by fsck.ext=
4 easily. But we have below questions:
> 1. whether this issue already been fixed in the latest kernel version=
?
> 2. based on the information I provided in this mail, can you help to =
solve this issue ?

Well, the question is how did the journal get corrupted?  It's
possible that it's caused by a kernel bug, although I'm not aware of
any such bugs being reported.

In my mind, the most likely cause is that the SD card is ignoring the
CACHE FLUSH command, or is not properly saving the SD card's Flash
Translation Layer (FTL) metadata on a power drop.  Here are some
examples some investigation into lousy SSD's that have this bug ---
and historically, SD cards have been **worse** than SSD's, because the
manufacturers have a much lower per-unit cost, so they tend to put in
even cheaper and crappier FTL systems on SD and eMMC flash.

http://lkcl.net/reports/ssd_analysis.html

https://www.usenix.org/conference/fast13/understanding-robustness-ssds-=
under-power-fault

What I tell people who are using flash devices is before they start
using any flash device, to do power drop testing on a raw device,
without any file system present.  The simplest way to do this is to
write a program that writes consecutive 4k blocks that contain a
timestamp, a sequence number, some random data, and a CRC-32 checksum
over the contents of the timestamp, sequence number, a flags word, and
random data.  As the program writes such 4k block, it rolls the dice
and once every 64 blocks or so (i.e., pick a random number, and see if
it is divisible by 64), then set a bit in the flags word indicating
that this block was forced out using a cache flush, and then when
writing this block, follow up the write with a CACHE FLUSH command.
It's also best if the test program prints the blocks which have been
written with CACHE FLUSH to the serial console, and that this is saved
by your test rig.

(This is what ext4's journal does before and after writing the commit
block in the journal, and it guarantees that (a) all of the data in
the journal written up to the commit block will be available after a
power drop, and (b) that the commit block has been written to the
storage device and again, will be available after a power drop.)

Once you've written this program, set up a test rig which boots your
test board, runs the program, and then drops power to the test board
randomly.  After the power drop, examine the flash device and make
sure that all of the blocks written up to the last "commit block" are
in fact valid.

You will find that a surprising number of SD cards will fail this
test.  In fact, the really lousy cards will become unreadable after a
power drop.  (A fact many wedding photographers discover the hard way
they drop their camera and the SD card flies out, and then they find
all of that their priceless, once-in-a-lifetime photos are lost forweve=
r.)

I ****strongly**** recommend that if you are not testing your SD cards
in this way from your parts supplier, you do so immediately, and
reject any model that is not able to guarantee that data survives a
power drop.

Good luck, and I hope this is helpful,

					- Ted

P.S.  If you do write such a program, please consider making it
available under an open source license.  If more companies did this,
it would apply pressure to the flash manufacturers to stop making such
crappy products, and while it might raise the BOM cost of products by
a penny or two, the net result would be better for everyone in the
industry.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
