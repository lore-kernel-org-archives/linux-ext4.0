From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
Date: Fri, 2 Sep 2011 10:15:27 -0400
Message-ID: <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41134 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1IBOP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Sep 2011 10:15:58 -0400
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 31, 2011 at 8:30 PM, Darrick J. Wong <djwong@us.ibm.com> wr=
ote:
> Hi all,
>
> This patchset adds crc32c checksums to most of the ext4 metadata obje=
cts. =A0A
> full design document is on the ext4 wiki[1] but I will summarize that=
 document here.
>
> As much as we wish our storage hardware was totally reliable, it is s=
till
> quite possible for data to be corrupted on disk, corrupted during tra=
nsfer over
> a wire, or written to the wrong places. =A0To protect against this so=
rt of
> non-hostile corruption, it is desirable to store checksums of metadat=
a objects
> on the filesystem to prevent broken metadata from shredding the files=
ystem.
>
> The crc32c polynomial was chosen for its improved error detection cap=
abilities
> over crc32 and crc16, and because of its hardware acceleration on cur=
rent and
> upcoming Intel and Sparc chips.
>
> Each type of metadata object has been retrofitted to store a checksum=
 as follows:
>
> - The superblock stores a crc32c of itself.
> - Each inode stores crc32c(fs_uuid + inode_num + inode + slack_space_=
after_inode)
> - Block and inode bitmaps each get their own crc32c(fs_uuid + group_n=
um +
> =A0bitmap), stored in the block group descriptor.
> - Each extent tree block stores a crc32c(fs_uuid + inode_num + extent=
_entries)
> =A0in unused space at the end of the block.
> - Each directory leaf block has an unused-looking directory entry big=
 enough to
> =A0store a crc32c(fs_uuid + inode_num + block) at the end of the bloc=
k.
> - Each directory htree block is shortened to contain a crc32c(fs_uuid=
 +
> =A0inode_num + block) at the end of the block.
> - Extended attribute blocks store crc32c(fs_uuid + block_no + ea_bloc=
k) in the
> =A0header.
> - Journal commit blocks can be converted to use crc32c to checksum al=
l blocks
> =A0in the transaction, if journal_checksum is given.
>
> The first four patches in the kernel patchset fix existing bugs in ex=
t4 that
> cause incorrect checkums to be written. =A0I think Ted already took t=
hem, but
> with recent instability I'm resending them to be cautious. =A0The sub=
sequent 12
> patches add the necessary code to support checksumming in ext4 and jb=
d2.
>
> I also have a set of three patches that provide a faster crc32c imple=
mentation
> based on Bob Pearson's earlier crc32 patchset. =A0This will be sent u=
nder
> separate cover to the crypto list and to lkml/linux-ext4.
>
> The patchset for e2fsprogs will be sent under separate cover only to =
linux-ext4
> as it is quite lengthy (~36 patches).
>
> As far as performance impact goes, I see nearly no change with a stan=
dard mail
> server ffsb simulation. =A0On a test that involves only file creation=
 and
> deletion and extent tree modifications, I see a drop of about 50 perc=
ent with
> the current kernel crc32c implementation; this improves to a drop of =
about 20
> percent with the enclosed crc32c implementation. =A0However, given th=
at metadata
> is usually a small fraction of total IO, it doesn't seem like the cos=
t of
> enabling this feature is unreasonable.
>
> There are of course unresolved issues:
>
> - What to do when the block group descriptor isn't big enough to hold=
 2 crc32s
> =A0(which is the case with 32-bit ext4 filesystems, sadly). =A0I'm no=
t quite
> =A0convinced that truncating a 32-bit checksum to 16-bits is a safe i=
dea. =A0Right
> =A0now, one has to enable the 64bit feature to enable any bitmap chec=
ksums.
> =A0I'm not sure how effective crc16 is at checksumming 32768-bit bitm=
aps.
>
> - Using the journal commit hooks to delay crc32c calculation until di=
rty
> =A0buffers are actually being written to disk.
>
> - Can we get away with using a (hw accelerated) LE crc32c for jbd2, w=
hich
> =A0stores its data in BE order?
>
> - Interaction with online resize code. =A0Yongqiang seems to be in th=
e process of
> =A0rewriting this, so I haven't looked at it very closely yet.
>
> - If block group descriptors can now exceed 32 bytes (when 64bit file=
system
> =A0support is enabled), should we use crc32c instead of crc16? =A0Fro=
m what I've
> =A0read of the literature, crc16 is not very effective on datasets ex=
ceeding 256
> =A0bytes.
>
> Please have a look at the design document and patches, and please fee=
l free to
> suggest any changes. =A0I will be at LPC next week if anyone wishes t=
o discuss,
> debate, or protest.
>
> --D
>
> [1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

Derrick,

Brainstorming only:

Another thing you might consider is to somehow tie into the data
integrity patches that went into the kernel a couple years ago.  Those
are tied to specialized storage devices (typically scsi) that can
actually have the checksum live on the disk, but not in the normal
data area.  ie. in the sector header / footer or some other out of
band area.

At a minimum, it may make sense to use the same CRC which that API
does.  Then you could calculate the CRC once and put it both in-band
in the inode and out-of-band in the dedicated integrity area of
supporting storage devices.

That if the data is corrupted on the wire as an example, the
controller itself may be able to verify its a bad crc and ask for a
re-read without even involving the kernel.

I believe supporting hardware is rare, but if the kernel is going to
have a data integrity API to support it at all, then code like this is
exactly the kind of code that should layer on top of it.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
