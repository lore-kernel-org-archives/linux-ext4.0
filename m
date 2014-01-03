From: "Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>
Subject: AW: ext4 filesystem bad extent error review
Date: Fri, 3 Jan 2014 17:29:32 +0100
Message-ID: <B8A948099C53E0408BDBCE749AAECA9A2A80C78543@SI-MBX10.de.bosch.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
 <20140102184211.GC10870@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>,
	"Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:52722 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaACQ3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jan 2014 11:29:40 -0500
In-Reply-To: <20140102184211.GC10870@thunk.org>
Content-Language: de-DE
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 02, 2014 at 19:42, Theodore Ts'o [mailto:tytso@mit.edu]
wrote:
> On Thu, Jan 02, 2014 at 12:59:52PM +0800, Huang Weller (CM/ESW12-CN)
> wrote:
> >
> > We did more test which we backup the journal blocks  before we moun=
t
> the test partition.
> > Actually, before we mount the test partition, we use fsck.ext4 with=
 -
> n option to verify whether there is any  bad extents issues available=
=2E
> The fsck.ext4 never found any such kind issue. And we can prove that
> the bad extents issue is happened after journaling replay.
>=20
> Ok, so that implies that the failure is almost certainly due to
> corrupted blocks in the journal.  Hence, when we replay the journal, =
it
> causes the the file system to become corrupted, because the "newer"
> (and presumably, "more correct") metadata blocks found in the blocks
> recorded in the journal are in fact corrupted.
>=20
=2E....
> >
> > We  searched such error on internet, there are some one also has su=
ch
> issue. But there is no solution.
> > This issue maybe not a big issue which it can be repaired by
> fsck.ext4 easily. But we have below questions:
> > 1. whether this issue already been fixed in the latest kernel versi=
on?
> > 2. based on the information I provided in this mail, can you help t=
o
> solve this issue ?
>=20
> Well, the question is how did the journal get corrupted?  It's possib=
le
> that it's caused by a kernel bug, although I'm not aware of any such
> bugs being reported.
>=20
> In my mind, the most likely cause is that the SD card is ignoring the
> CACHE FLUSH command, or is not properly saving the SD card's Flash
> Translation Layer (FTL) metadata on a power drop. =20

Yes, this could be a possible reason, but we did exactly the same test
not only with power drops but also with doing only iMX watchdog resets.=
=20
In the latter case there was no power drop for the eMMC, but we=20
observed exactly the same kind of inode corruption.

During thousands of test loops with power drops or watchdog resets, whi=
le=20
creating thousands of files with multiple threads, we did not observe a=
ny=20
other kind of ext4 metadata damage or file content damage.=20

And in the error case so far we always found only a single damaged inod=
e.
The other inodes before and after the damaged inode in the journal, in =
the
same logical 4096 bytes block, seem to be intact and valid (examined wi=
th=20
a hex editor). And in all the failure cases - as far as we can say base=
d=20
on the ext4 disk layout documentation - only the ee_len or the ee_start=
_hi=20
and ee_start_lo entries are wrong (i.e. zeroed).
   =20
The eMMC has no "knowledge" about the logical meaning or the offset of=20
ee_len or ee_start. Thus, it does not seem very likely that whatever ki=
nd of
internal failure or bug in the eMMC controller/firmware always and only
damages these few bytes.

> What I tell people who are using flash devices is before they start
> using any flash device, to do power drop testing on a raw device,
> without any file system present.  The simplest way to do this is to
> write a program that writes consecutive 4k blocks that contain a
> timestamp, a sequence number, some random data, and a CRC-32 checksum
> over the contents of the timestamp, sequence number, a flags word, an=
d
> random data.  As the program writes such 4k block, it rolls the dice
> and once every 64 blocks or so (i.e., pick a random number, and see i=
f
> it is divisible by 64), then set a bit in the flags word indicating
> that this block was forced out using a cache flush, and then when
> writing this block, follow up the write with a CACHE FLUSH command.
> It's also best if the test program prints the blocks which have been
> written with CACHE FLUSH to the serial console, and that this is save=
d
> by your test rig.

We did similar tests in the past, but not yet with this particular type
of eMMC. I think we should repeat with this particular type.

>=20
> (This is what ext4's journal does before and after writing the commit
> block in the journal, and it guarantees that (a) all of the data in t=
he
> journal written up to the commit block will be available after a powe=
r
> drop, and (b) that the commit block has been written to the storage
> device and again, will be available after a power drop.)
>

Well, we also did the same tests with journal_checksum enabled. We were=
=20
still able to reproduce the failure w/o any checksumming error. So we
believe that the respective transaction (as well as all others) was=20
complete and not corrupted by the eMMC.=20
Is this a valid assumption ? If so, I would assume that the corrupted
Inode was really written to the eMMC and not corrupted by the eMMC.=20

(BTW, we do know that journal_checksum is somehow critical and might ma=
ke=20
things worse, but for test purpose and to exclude that the eMMC deliver=
s
corrupted transactions when reading the data, it seemed to be a meaning=
ful
approach)
=20
So, I think there _might_ be a kernel bug, but it could be also a probl=
em=20
related to the particular type of eMMC. We did not observe the same iss=
ue
in previous tests with another type of eMMC from another supplier, but =
this
was with an older kernel patch level and with another HW design.

Regarding a possible kernel bug: Is there any chance that the invalid=20
ee_len or ee_start are returned by, e.g., the block allocator ?
If so, can we try to instrument the code to get suitable traces ?
Just to see or to exclude that the corrupted inode is really written
to the eMMC ?


Mit freundlichen Gr=FC=DFen / Best regards

Dirk Juergens

Robert Bosch Car Multimedia GmbH

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
