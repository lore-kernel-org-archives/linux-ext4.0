From: "Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>
Subject: AW: ext4 filesystem bad extent error review
Date: Fri, 3 Jan 2014 17:40:11 +0100
Message-ID: <B8A948099C53E0408BDBCE749AAECA9A2A80C78545@SI-MBX10.de.bosch.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
 <20140102184211.GC10870@thunk.org>
 <AE39A478622CF340ABEC2418D74074F61FC59AC406@SGPMBX05.APAC.bosch.com>
 <20140103154846.GB31411@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:52920 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaACQkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jan 2014 11:40:35 -0500
In-Reply-To: <20140103154846.GB31411@thunk.org>
Content-Language: de-DE
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 03, 2014 at 17:30, Theodore Ts'o [mailto:tytso@mit.edu]
wrote:
>=20
> On Fri, Jan 03, 2014 at 11:16:02AM +0800, Huang Weller (CM/ESW12-CN)
> wrote:
> >
> > It sounds like the barrier test. We wrote such kind test tool
> > before, the test program used ioctl(fd, BLKFLSBUF, 0) to set a
> > barrier before next write operation.  Do you think this ioctl is
> > enough ? Because I saw the ext4 use it. I will do the test with tha=
t
> > tool and then let you know the result.
>=20
> The BLKFLSBUF ioctl does __not__ send a CACHE FLUSH command to the
> hardware device.  It forces all of the dirty buffers in memory to the
> storage device, and then it invalidates all the buffer cache, but it
> does not send a CACHE FLUSH command to the hardware.  Hence, the
> hardware is free to write it to its on-disk cache, and not necessaril=
y
> guarantee that the data is written to stable store.  (For an example
> use case of BLKFLSBUF, we use it in e2fsck to drop the buffer cache
> for benchmarking purposes.)
>=20
> If you want to force a CACHE FLUSH (or barrier, depending on the
> underlying transport different names may be given to this operation),
> you need to call fsync() on the file descriptor open to the block
> device.
>=20
> > More information about journal block which caused the bad extents
> > error: We enabled the mount option journal_checksum in our test.  W=
e
> > reproduced the same problem and the journal checksum is correct
> > because the journal block will not be replayed if checksum is error=
=2E
>=20
> How did you enable the journal_checksum option?  Note that this is no=
t
> safe in general, which is why we don't enable it or the async_commit
> mount option by default.  The problem is that currently the journal
> replay stops when it hits a bad checksum, and this can leave the file
> system in a worse case than it currently is in.  There is a way we
> could fix it, by adding per-block checksums to the journal, so we can
> skip just the bad block, and then force an efsck afterwards, but that
> isn't something we've implemented yet.
>=20
> That being said, if the journal checksum was valid, and so the
> corrupted block was replayed, it does seem to argue against
> hardware-induced corruption.

Yes, this was also our feeling. Please see my other mail just sent
some minutes ago. We know about the possible problems with=20
journal_checksum, but we thought that it is a good option in our case
to identify if this is a HW- or SW-induced issue.

>=20
> Hmm....  I'm stumped, for the moment.  The journal layer is quite
> stable, and we haven't had any problems like this reported in many,
> many years.
>=20
> Let's take this back to first principles.  How reliably can you
> reproduce the problem?  How often does it fail? =20

With kernel 3.5.7.23 about once per overnight long term test.

> Is it something where
> you can characterize the workload leading to this failure?  Secondly,
> is a power drop involved in the reproduction at all, or is this
> something that can be reproduced by running some kind of workload, an=
d
> then doing a soft reset (i.e., force a kernel reboot, but _not_ do it
> via a power drop)?

As I stated in my other mail, it is also reproduced with soft resets.
Weller can give more details about the test setup.

>=20
> The other thing to ask is when did this problem first start appearing=
?
> With a kernel upgrade?  A compiler/toolchain upgrade?  Or has it
> always been there?
>=20
> Regards,
>=20
> 							- Ted


Mit freundlichen Gr=FC=DFen / Best regards

Dr. rer. nat.  Dirk Juergens

Robert Bosch Car Multimedia GmbH
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
