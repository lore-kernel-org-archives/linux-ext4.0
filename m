From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
Date: Fri, 2 Sep 2011 11:22:14 -0700
Message-ID: <20110902182214.GC12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33831 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab1IBSXP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Sep 2011 14:23:15 -0400
Content-Disposition: inline
In-Reply-To: <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 02, 2011 at 10:15:27AM -0400, Greg Freemyer wrote:
> On Wed, Aug 31, 2011 at 8:30 PM, Darrick J. Wong <djwong@us.ibm.com> =
wrote:
> > Hi all,
> >
> > This patchset adds crc32c checksums to most of the ext4 metadata ob=
jects. =A0A
> > full design document is on the ext4 wiki[1] but I will summarize th=
at document here.
> >
> > As much as we wish our storage hardware was totally reliable, it is=
 still
> > quite possible for data to be corrupted on disk, corrupted during t=
ransfer over
> > a wire, or written to the wrong places. =A0To protect against this =
sort of
> > non-hostile corruption, it is desirable to store checksums of metad=
ata objects
> > on the filesystem to prevent broken metadata from shredding the fil=
esystem.
> >
> > The crc32c polynomial was chosen for its improved error detection c=
apabilities
> > over crc32 and crc16, and because of its hardware acceleration on c=
urrent and
> > upcoming Intel and Sparc chips.
> >
> > Each type of metadata object has been retrofitted to store a checks=
um as follows:
> >
> > - The superblock stores a crc32c of itself.
> > - Each inode stores crc32c(fs_uuid + inode_num + inode + slack_spac=
e_after_inode)
> > - Block and inode bitmaps each get their own crc32c(fs_uuid + group=
_num +
> > =A0bitmap), stored in the block group descriptor.
> > - Each extent tree block stores a crc32c(fs_uuid + inode_num + exte=
nt_entries)
> > =A0in unused space at the end of the block.
> > - Each directory leaf block has an unused-looking directory entry b=
ig enough to
> > =A0store a crc32c(fs_uuid + inode_num + block) at the end of the bl=
ock.
> > - Each directory htree block is shortened to contain a crc32c(fs_uu=
id +
> > =A0inode_num + block) at the end of the block.
> > - Extended attribute blocks store crc32c(fs_uuid + block_no + ea_bl=
ock) in the
> > =A0header.
> > - Journal commit blocks can be converted to use crc32c to checksum =
all blocks
> > =A0in the transaction, if journal_checksum is given.
> >
> > The first four patches in the kernel patchset fix existing bugs in =
ext4 that
> > cause incorrect checkums to be written. =A0I think Ted already took=
 them, but
> > with recent instability I'm resending them to be cautious. =A0The s=
ubsequent 12
> > patches add the necessary code to support checksumming in ext4 and =
jbd2.
> >
> > I also have a set of three patches that provide a faster crc32c imp=
lementation
> > based on Bob Pearson's earlier crc32 patchset. =A0This will be sent=
 under
> > separate cover to the crypto list and to lkml/linux-ext4.
> >
> > The patchset for e2fsprogs will be sent under separate cover only t=
o linux-ext4
> > as it is quite lengthy (~36 patches).
> >
> > As far as performance impact goes, I see nearly no change with a st=
andard mail
> > server ffsb simulation. =A0On a test that involves only file creati=
on and
> > deletion and extent tree modifications, I see a drop of about 50 pe=
rcent with
> > the current kernel crc32c implementation; this improves to a drop o=
f about 20
> > percent with the enclosed crc32c implementation. =A0However, given =
that metadata
> > is usually a small fraction of total IO, it doesn't seem like the c=
ost of
> > enabling this feature is unreasonable.
> >
> > There are of course unresolved issues:
> >
> > - What to do when the block group descriptor isn't big enough to ho=
ld 2 crc32s
> > =A0(which is the case with 32-bit ext4 filesystems, sadly). =A0I'm =
not quite
> > =A0convinced that truncating a 32-bit checksum to 16-bits is a safe=
 idea. =A0Right
> > =A0now, one has to enable the 64bit feature to enable any bitmap ch=
ecksums.
> > =A0I'm not sure how effective crc16 is at checksumming 32768-bit bi=
tmaps.
> >
> > - Using the journal commit hooks to delay crc32c calculation until =
dirty
> > =A0buffers are actually being written to disk.
> >
> > - Can we get away with using a (hw accelerated) LE crc32c for jbd2,=
 which
> > =A0stores its data in BE order?
> >
> > - Interaction with online resize code. =A0Yongqiang seems to be in =
the process of
> > =A0rewriting this, so I haven't looked at it very closely yet.
> >
> > - If block group descriptors can now exceed 32 bytes (when 64bit fi=
lesystem
> > =A0support is enabled), should we use crc32c instead of crc16? =A0F=
rom what I've
> > =A0read of the literature, crc16 is not very effective on datasets =
exceeding 256
> > =A0bytes.
> >
> > Please have a look at the design document and patches, and please f=
eel free to
> > suggest any changes. =A0I will be at LPC next week if anyone wishes=
 to discuss,
> > debate, or protest.
> >
> > --D
> >
> > [1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
>=20
> Derrick,
>=20
> Brainstorming only:
>=20
> Another thing you might consider is to somehow tie into the data
> integrity patches that went into the kernel a couple years ago.  Thos=
e
> are tied to specialized storage devices (typically scsi) that can
> actually have the checksum live on the disk, but not in the normal
> data area.  ie. in the sector header / footer or some other out of
> band area.
>=20
> At a minimum, it may make sense to use the same CRC which that API
> does.  Then you could calculate the CRC once and put it both in-band
> in the inode and out-of-band in the dedicated integrity area of
> supporting storage devices.

If you have the necessary DIF/DIX hardware and kernel support then ever=
y block
in the FS is already checksummed and you don't need metadata_csum at al=
l.  This
patchset was really intended for setups where we don't have DIF/DIX.

=46urthermore, the nice thing about the in-filesystem checksum is that =
we bake in
other things like the FS UUID and the inode number, which gives you a s=
omewhat
better assurance that the data block belongs to the fs and the file tha=
t the
code think it belongs to.  The DIX interface allows for a 32-bit block =
number
and a 16-bit application tag ... which is unfortunately small given 64-=
bit
block numbers and 32-bit inode numbers.

I guess there's also an argument that from a layering perspective it's
desirable to have a FS image whose integrity features remain intact eve=
n if you
copy the image to a different device that doesn't support the hardware =
feature.

As a side note, the crc-t10dif implementation is quite slow -- the hard=
ware
accelerated crc32c is 15x faster, and the sw implementation is usually =
3-6x
faster.  I suspect somebody will want to fix that before DIF becomes mo=
re
widespread...

> That if the data is corrupted on the wire as an example, the
> controller itself may be able to verify its a bad crc and ask for a
> re-read without even involving the kernel.
>=20
> I believe supporting hardware is rare, but if the kernel is going to
> have a data integrity API to support it at all, then code like this i=
s
> exactly the kind of code that should layer on top of it.

The good news is that if you're really worried about integrity, metadat=
a_csum
and DIF/DIX aren't mutually exclusive features.  Rejecting corrupted wr=
ite
commands at write time seems like a useful feature. :)

--D
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
