From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Proposal draft for data checksumming for ext4
Date: Mon, 28 Apr 2014 12:36:10 -0700
Message-ID: <20140428193610.GE8434@birch.djwong.org>
References: <alpine.LFD.2.00.1403201736280.8407@localhost.localdomain>
 <20140320175950.GJ9070@birch.djwong.org>
 <87a9b5ctls.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24018 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbaD1TgZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2014 15:36:25 -0400
Content-Disposition: inline
In-Reply-To: <87a9b5ctls.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 28, 2014 at 08:21:51PM +0400, Dmitry Monakhov wrote:
> On Thu, 20 Mar 2014 10:59:50 -0700, "Darrick J. Wong" <darrick.wong@o=
racle.com> wrote:
> > On Thu, Mar 20, 2014 at 05:40:06PM +0100, Luk=C3=A1=C5=A1 Czerner w=
rote:
> > > Hi all,
> > >=20
> > > I've started thinking about implementing data checksumming for ex=
t4 file
> > > system. This is not meant to be a formal proposal or a definitive=
 design
> > > description since I am not that far yet, but just a few ideas to =
start
> > > the discussion and trying to figure out what the best design for =
data
> > > checksumming in ext4 might be.
> > >=20
> > >=20
> > >=20
> > > 			   Data checksumming for ext4
> > > 				  Version 0.1
> > > 				 March 20, 2014
> > >=20
> > >=20
> > > Goal
> > > =3D=3D=3D=3D
> > >=20
> > > The goal is to implement data checksumming for ext4 file system i=
n order
> > > to improve data integrity and increase protection against silent =
data
> > > corruption while maintaining reasonable performance and usability=
 of the
> > > file system.
> > >=20
> > > While data checksums can be certainly used in different ways, for=
 example
> > > data deduplication this proposal is very much focused on data int=
egrity.
> > >=20
> > >=20
> > > Checksum function
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > By default I plan to use crc32c checksum, but I do not see a reas=
on why not
> > > not to be able to support different checksum function. Also by de=
fault the
> > > checksum size should be 32 bits, but the plan is to make the form=
at
> > > flexible enough to be able to support different checksum sizes.
> >=20
> > <nod> Were you thinking of allowing the use of different functions =
for data and
> > metadata checksums?
> >=20
> > > Checksumming and Validating
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > >=20
> > > On write checksums on the data blocks need to be computed right b=
efore its
> > > bio is submitted and written out as metadata to its position (see=
 bellow)
> > > after the bio completes (similarly as we do unwritten extent conv=
ersion
> > > today).
> > >=20
> > > Similarly on read checksums needs to be computed after the bio co=
mpletes
> > > and compared with the stored values to verify that the data is in=
tact.
> > >=20
> > > All of this should be done using workqueues (Concurrency Managed
> > > Workqueues) so we do not block the other operations and to spread=
 the
> > > checksum computation and comparison across CPUs. One wq for reads=
 and one
> > > for writes. Specific setup of the wq such as priority, or concurr=
ency limits
> > > should be decided later based on the performance evaluation.
> > >=20
> > > While we already have ext4 infrastructure to submit bios in
> > > fs/ext4/page-io.c where the entry point is ext4_bio_write_page() =
we would
> > > need the same for reads to be able to provide ext4 specific hooks=
 for
> > > io completion.
> > >=20
> > >=20
> > > Where to store the checksums
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > >=20
> > > While the problems above are pretty straightforward when it comes=
 to the
> > > design, actually storing and retrieving the data checksums from t=
o/from
> > > the ext4 format requires much more thought to be efficient enough=
 and play
> > > nicely with the overall ext4 design while trying not to be too in=
trusive.
> > >=20
> > > I came up with several ideas about where to store and how to acce=
ss data
> > > checksums. While some of the ideas might not be the most viable o=
ptions,
> > > it's still interesting to think about the advantages and disadvan=
tages of
> > > each particular solution.
> > >=20
> > > a) Static layout
> > > ----------------
> > >=20
> > > This scheme fits perfectly into the ext4 design. Checksum blocks
> > > would be preallocated the same way as we do with inode tables for=
 example.
> > > Each block group should have it's own contiguous region of checks=
um blocks
> > > to be able to store checksums for bocks from entire block group i=
t belongs
> > > to. Each checksum block would contain header including checksum o=
f the
> > > checksum block.
> Oh. The most thing that bother me about that feature is possible
> performance degradation. number seeks increase dramatically because=20
> csumblock is not continuous with datablock. Off course journal should
> absorb that and real io will happen during journal checkpoint.
> But I assumes that mail server which does a lot of
> create()/write()/fsync() will complain about bad performance.
>=20
> BTW: it looks like we do not try to optimize io pattern inside
> jbd2_log_do_checkpoint(). For example __flush_batch() can submit
> buffer in sorted order(according to block numbers).
> =20
> =20
> > >=20
> > > We still have unused 4 Bytes in the ext4_group_desc structure, so=
 storing
> > > a block number for the checksum table should not be a problem.
> >=20
> > What if you have a 64bit filesystem?  Do you have some strategy in =
mind to work
> > around that?  What about the snapshot exclusion bitmap field?  Afai=
ct that
> > never went in, so perhaps that field could be reused?
> >=20
> > > Finding a checksum location of each block in the block group shou=
ld be done
> > > in O(1) time, which is very good. Other advantage is a locality w=
ith the
> > > data blocks in question since both resides in the same block grou=
p.
> > >=20
> > > Big disadvantage is the fact that this solution is not very flexi=
bile which
> > > comes from the fact that the location of "checksum table" is stat=
ically
> > > located at a precise position in the file system at mkfs time.
> >=20
> > Having a big dumb block of checksums would be easier to prefetch fr=
om disk for
> > fsck and kernel driver, rather than having to dig through some tree=
 structure.
> > (More on that below)
> >=20
> > > There are also other problems we should be concerned with. Ext4 f=
ile system
> > > does have support for metadata checksumming so all the metadata d=
oes have
> > > its own checksum. While we can avoid unnecessarily checksuming in=
odes, group
> > > descriptors and basicall all statically positioned metadata, we s=
till have
> > > dynamically allocated metadata blocks such as extent blocks. Thes=
e block
> > > do not have to be checksummed but we would still have space reser=
ved in the
> > > checksum table.
> >=20
> > Don't forget directory blocks--they (should) have checksums too, so=
 you can
> > skip those.
> Just quick note: We can hide checksum for directory inside
> ext4_dir_entry_2 for a special dirs '.' or '..' simply be increasing
> ->rec_len which make this feature compatible with older FS

metadata_csum already does this.

--D
> >=20
> > I wonder, could we use this table to store backrefs too?  It would =
make the
> > table considerably larger, but then we could (potentially) reconstr=
uct broken
> > extent trees.
> >=20
> > > I think that we should be able to make this feature without intro=
ducing any
> > > incompatibility, but it would make more sense to make it RO compa=
tible only
> > > so we can preserve the checksums. But that's up to the implementa=
tion.
> >=20
> > I think you'd have to have it be rocompat, otherwise you could writ=
e data with
> > an old kernel and a new kernel would freak out.
> >=20
> > > b) Special inode
> > > ----------------
> > >=20
> > > This is very "lazy" solution and should not be difficult to imple=
ment. The
> > > idea is to have a special inode which would store the checksum bl=
ocks in
> > > it's own data blocks.
> > >=20
> > > The big disadvantage is that we would have to walk the extent tre=
e twice for
> > > each read, or write. There is not much to say about this solution=
 other than
> > > again we can make this feature without introducing any incompatib=
ility, but
> > > it would probably make more sense to make it RO compatible to pre=
serve the
> > > checksums.
> > >=20
> > > c) Per inode checksum b-tree
> > > ----------------------------
> > >=20
> > > See d)
> > >=20
> > > d) Per block group checksum b-tree
> > > ----------------------------------
> > >=20
> > > Those two schemes are very similar in that both would store check=
sum in a
> > > b-tree with a block number (we could use logical block number in =
per inode
> > > tree) as a key. Obviously finding a checksum would be in logarith=
mic time,
> > > while the size of the tree would be possibly much bigger in the p=
er-inode
> > > case. In per block group case we will have much smaller boundary =
of
> > > number of checksum blocks stored.
> > >=20
> > > This and the fact that we would have to have at least one checksu=
m block
> > > per inode (which would be wasteful in the case of small files) is=
 making per
> > > block group solution much more viable. However the major disadvan=
tage of
> > > per block group solution is that the checksum tree would create a=
 source of
> > > contention when reading/writing from/to a different inodes in the=
 same block
> > > group. This might be mitigated by having a worker thread per a ra=
nge of block
> > > groups - but it might still be a bottleneck.
> > >=20
> > > Again we still have 4 Bytes in ext4_group_desc to store the point=
er to the
> > > root of the tree. While the ext4_inode structure have 4Bytes of
> > > i_obso_faddr but that's not enough. So we would have to figure ou=
t where to
> > > store it - we could possibly abuse i_block to store it along with=
 the extent
> > > nodes.
> >=20
> > I think(?) your purpose in using either a special inode or a btree =
to store the
> > checksums is to avoid wasting checksum blocks on things that are al=
ready
> > checksummed?  I'm not sure that we'd save enough space to justify t=
he extra
> > processing.
> >=20
> > --D
> >=20
> > > File system scrub
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > While this is certainly a feature which we want to have in both u=
serspace
> > > e2fsprogs and kernel I do not have any design notes at this stage=
=2E
> > >=20
> > >=20
> > >=20
> > >=20
> > > I am sure that there are other possibilities and variants of thos=
e design
> > > ideas, but I think that this should be enough to have a discussio=
n started.
> > > As I is not I think that the most viable option is d) that is, pe=
r block
> > > group checksum tree, which gives us enough flexibility while not =
being too
> > > complex solution.
> > >=20
> > > I'll try to update this description as it will be getting more co=
ncrete
> > > structure and I hope that we will have some productive discussion=
 about
> > > this at LSF.
> > >=20
> > > Thanks!
> > > -Lukas
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
