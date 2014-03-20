From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Proposal draft for data checksumming for ext4
Date: Thu, 20 Mar 2014 10:59:50 -0700
Message-ID: <20140320175950.GJ9070@birch.djwong.org>
References: <alpine.LFD.2.00.1403201736280.8407@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22603 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251AbaCTSAE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2014 14:00:04 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1403201736280.8407@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2014 at 05:40:06PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Hi all,
>=20
> I've started thinking about implementing data checksumming for ext4 f=
ile
> system. This is not meant to be a formal proposal or a definitive des=
ign
> description since I am not that far yet, but just a few ideas to star=
t
> the discussion and trying to figure out what the best design for data
> checksumming in ext4 might be.
>=20
>=20
>=20
> 			   Data checksumming for ext4
> 				  Version 0.1
> 				 March 20, 2014
>=20
>=20
> Goal
> =3D=3D=3D=3D
>=20
> The goal is to implement data checksumming for ext4 file system in or=
der
> to improve data integrity and increase protection against silent data
> corruption while maintaining reasonable performance and usability of =
the
> file system.
>=20
> While data checksums can be certainly used in different ways, for exa=
mple
> data deduplication this proposal is very much focused on data integri=
ty.
>=20
>=20
> Checksum function
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> By default I plan to use crc32c checksum, but I do not see a reason w=
hy not
> not to be able to support different checksum function. Also by defaul=
t the
> checksum size should be 32 bits, but the plan is to make the format
> flexible enough to be able to support different checksum sizes.

<nod> Were you thinking of allowing the use of different functions for =
data and
metadata checksums?

> Checksumming and Validating
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>=20
> On write checksums on the data blocks need to be computed right befor=
e its
> bio is submitted and written out as metadata to its position (see bel=
low)
> after the bio completes (similarly as we do unwritten extent conversi=
on
> today).
>=20
> Similarly on read checksums needs to be computed after the bio comple=
tes
> and compared with the stored values to verify that the data is intact=
=2E
>=20
> All of this should be done using workqueues (Concurrency Managed
> Workqueues) so we do not block the other operations and to spread the
> checksum computation and comparison across CPUs. One wq for reads and=
 one
> for writes. Specific setup of the wq such as priority, or concurrency=
 limits
> should be decided later based on the performance evaluation.
>=20
> While we already have ext4 infrastructure to submit bios in
> fs/ext4/page-io.c where the entry point is ext4_bio_write_page() we w=
ould
> need the same for reads to be able to provide ext4 specific hooks for
> io completion.
>=20
>=20
> Where to store the checksums
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>=20
> While the problems above are pretty straightforward when it comes to =
the
> design, actually storing and retrieving the data checksums from to/fr=
om
> the ext4 format requires much more thought to be efficient enough and=
 play
> nicely with the overall ext4 design while trying not to be too intrus=
ive.
>=20
> I came up with several ideas about where to store and how to access d=
ata
> checksums. While some of the ideas might not be the most viable optio=
ns,
> it's still interesting to think about the advantages and disadvantage=
s of
> each particular solution.
>=20
> a) Static layout
> ----------------
>=20
> This scheme fits perfectly into the ext4 design. Checksum blocks
> would be preallocated the same way as we do with inode tables for exa=
mple.
> Each block group should have it's own contiguous region of checksum b=
locks
> to be able to store checksums for bocks from entire block group it be=
longs
> to. Each checksum block would contain header including checksum of th=
e
> checksum block.
>=20
> We still have unused 4 Bytes in the ext4_group_desc structure, so sto=
ring
> a block number for the checksum table should not be a problem.

What if you have a 64bit filesystem?  Do you have some strategy in mind=
 to work
around that?  What about the snapshot exclusion bitmap field?  Afaict t=
hat
never went in, so perhaps that field could be reused?

> Finding a checksum location of each block in the block group should b=
e done
> in O(1) time, which is very good. Other advantage is a locality with =
the
> data blocks in question since both resides in the same block group.
>=20
> Big disadvantage is the fact that this solution is not very flexibile=
 which
> comes from the fact that the location of "checksum table" is statical=
ly
> located at a precise position in the file system at mkfs time.

Having a big dumb block of checksums would be easier to prefetch from d=
isk for
fsck and kernel driver, rather than having to dig through some tree str=
ucture.
(More on that below)

> There are also other problems we should be concerned with. Ext4 file =
system
> does have support for metadata checksumming so all the metadata does =
have
> its own checksum. While we can avoid unnecessarily checksuming inodes=
, group
> descriptors and basicall all statically positioned metadata, we still=
 have
> dynamically allocated metadata blocks such as extent blocks. These bl=
ock
> do not have to be checksummed but we would still have space reserved =
in the
> checksum table.

Don't forget directory blocks--they (should) have checksums too, so you=
 can
skip those.

I wonder, could we use this table to store backrefs too?  It would make=
 the
table considerably larger, but then we could (potentially) reconstruct =
broken
extent trees.

> I think that we should be able to make this feature without introduci=
ng any
> incompatibility, but it would make more sense to make it RO compatibl=
e only
> so we can preserve the checksums. But that's up to the implementation=
=2E

I think you'd have to have it be rocompat, otherwise you could write da=
ta with
an old kernel and a new kernel would freak out.

> b) Special inode
> ----------------
>=20
> This is very "lazy" solution and should not be difficult to implement=
=2E The
> idea is to have a special inode which would store the checksum blocks=
 in
> it's own data blocks.
>=20
> The big disadvantage is that we would have to walk the extent tree tw=
ice for
> each read, or write. There is not much to say about this solution oth=
er than
> again we can make this feature without introducing any incompatibilit=
y, but
> it would probably make more sense to make it RO compatible to preserv=
e the
> checksums.
>=20
> c) Per inode checksum b-tree
> ----------------------------
>=20
> See d)
>=20
> d) Per block group checksum b-tree
> ----------------------------------
>=20
> Those two schemes are very similar in that both would store checksum =
in a
> b-tree with a block number (we could use logical block number in per =
inode
> tree) as a key. Obviously finding a checksum would be in logarithmic =
time,
> while the size of the tree would be possibly much bigger in the per-i=
node
> case. In per block group case we will have much smaller boundary of
> number of checksum blocks stored.
>=20
> This and the fact that we would have to have at least one checksum bl=
ock
> per inode (which would be wasteful in the case of small files) is mak=
ing per
> block group solution much more viable. However the major disadvantage=
 of
> per block group solution is that the checksum tree would create a sou=
rce of
> contention when reading/writing from/to a different inodes in the sam=
e block
> group. This might be mitigated by having a worker thread per a range =
of block
> groups - but it might still be a bottleneck.
>=20
> Again we still have 4 Bytes in ext4_group_desc to store the pointer t=
o the
> root of the tree. While the ext4_inode structure have 4Bytes of
> i_obso_faddr but that's not enough. So we would have to figure out wh=
ere to
> store it - we could possibly abuse i_block to store it along with the=
 extent
> nodes.

I think(?) your purpose in using either a special inode or a btree to s=
tore the
checksums is to avoid wasting checksum blocks on things that are alread=
y
checksummed?  I'm not sure that we'd save enough space to justify the e=
xtra
processing.

--D

> File system scrub
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> While this is certainly a feature which we want to have in both users=
pace
> e2fsprogs and kernel I do not have any design notes at this stage.
>=20
>=20
>=20
>=20
> I am sure that there are other possibilities and variants of those de=
sign
> ideas, but I think that this should be enough to have a discussion st=
arted.
> As I is not I think that the most viable option is d) that is, per bl=
ock
> group checksum tree, which gives us enough flexibility while not bein=
g too
> complex solution.
>=20
> I'll try to update this description as it will be getting more concre=
te
> structure and I hope that we will have some productive discussion abo=
ut
> this at LSF.
>=20
> Thanks!
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
