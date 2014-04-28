From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Proposal draft for data checksumming for ext4
Date: Mon, 28 Apr 2014 20:21:51 +0400
Message-ID: <87a9b5ctls.fsf@openvz.org>
References: <alpine.LFD.2.00.1403201736280.8407@localhost.localdomain> <20140320175950.GJ9070@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46202 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbaD1QV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2014 12:21:58 -0400
Received: by mail-lb0-f170.google.com with SMTP id s7so5277276lbd.1
        for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2014 09:21:54 -0700 (PDT)
In-Reply-To: <20140320175950.GJ9070@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 20 Mar 2014 10:59:50 -0700, "Darrick J. Wong" <darrick.wong@ora=
cle.com> wrote:
> On Thu, Mar 20, 2014 at 05:40:06PM +0100, Luk=C3=A1=C5=A1 Czerner wro=
te:
> > Hi all,
> >=20
> > I've started thinking about implementing data checksumming for ext4=
 file
> > system. This is not meant to be a formal proposal or a definitive d=
esign
> > description since I am not that far yet, but just a few ideas to st=
art
> > the discussion and trying to figure out what the best design for da=
ta
> > checksumming in ext4 might be.
> >=20
> >=20
> >=20
> > 			   Data checksumming for ext4
> > 				  Version 0.1
> > 				 March 20, 2014
> >=20
> >=20
> > Goal
> > =3D=3D=3D=3D
> >=20
> > The goal is to implement data checksumming for ext4 file system in =
order
> > to improve data integrity and increase protection against silent da=
ta
> > corruption while maintaining reasonable performance and usability o=
f the
> > file system.
> >=20
> > While data checksums can be certainly used in different ways, for e=
xample
> > data deduplication this proposal is very much focused on data integ=
rity.
> >=20
> >=20
> > Checksum function
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> > By default I plan to use crc32c checksum, but I do not see a reason=
 why not
> > not to be able to support different checksum function. Also by defa=
ult the
> > checksum size should be 32 bits, but the plan is to make the format
> > flexible enough to be able to support different checksum sizes.
>=20
> <nod> Were you thinking of allowing the use of different functions fo=
r data and
> metadata checksums?
>=20
> > Checksumming and Validating
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >=20
> > On write checksums on the data blocks need to be computed right bef=
ore its
> > bio is submitted and written out as metadata to its position (see b=
ellow)
> > after the bio completes (similarly as we do unwritten extent conver=
sion
> > today).
> >=20
> > Similarly on read checksums needs to be computed after the bio comp=
letes
> > and compared with the stored values to verify that the data is inta=
ct.
> >=20
> > All of this should be done using workqueues (Concurrency Managed
> > Workqueues) so we do not block the other operations and to spread t=
he
> > checksum computation and comparison across CPUs. One wq for reads a=
nd one
> > for writes. Specific setup of the wq such as priority, or concurren=
cy limits
> > should be decided later based on the performance evaluation.
> >=20
> > While we already have ext4 infrastructure to submit bios in
> > fs/ext4/page-io.c where the entry point is ext4_bio_write_page() we=
 would
> > need the same for reads to be able to provide ext4 specific hooks f=
or
> > io completion.
> >=20
> >=20
> > Where to store the checksums
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >=20
> > While the problems above are pretty straightforward when it comes t=
o the
> > design, actually storing and retrieving the data checksums from to/=
from
> > the ext4 format requires much more thought to be efficient enough a=
nd play
> > nicely with the overall ext4 design while trying not to be too intr=
usive.
> >=20
> > I came up with several ideas about where to store and how to access=
 data
> > checksums. While some of the ideas might not be the most viable opt=
ions,
> > it's still interesting to think about the advantages and disadvanta=
ges of
> > each particular solution.
> >=20
> > a) Static layout
> > ----------------
> >=20
> > This scheme fits perfectly into the ext4 design. Checksum blocks
> > would be preallocated the same way as we do with inode tables for e=
xample.
> > Each block group should have it's own contiguous region of checksum=
 blocks
> > to be able to store checksums for bocks from entire block group it =
belongs
> > to. Each checksum block would contain header including checksum of =
the
> > checksum block.
Oh. The most thing that bother me about that feature is possible
performance degradation. number seeks increase dramatically because=20
csumblock is not continuous with datablock. Off course journal should
absorb that and real io will happen during journal checkpoint.
But I assumes that mail server which does a lot of
create()/write()/fsync() will complain about bad performance.

BTW: it looks like we do not try to optimize io pattern inside
jbd2_log_do_checkpoint(). For example __flush_batch() can submit
buffer in sorted order(according to block numbers).
=20
=20
> >=20
> > We still have unused 4 Bytes in the ext4_group_desc structure, so s=
toring
> > a block number for the checksum table should not be a problem.
>=20
> What if you have a 64bit filesystem?  Do you have some strategy in mi=
nd to work
> around that?  What about the snapshot exclusion bitmap field?  Afaict=
 that
> never went in, so perhaps that field could be reused?
>=20
> > Finding a checksum location of each block in the block group should=
 be done
> > in O(1) time, which is very good. Other advantage is a locality wit=
h the
> > data blocks in question since both resides in the same block group.
> >=20
> > Big disadvantage is the fact that this solution is not very flexibi=
le which
> > comes from the fact that the location of "checksum table" is static=
ally
> > located at a precise position in the file system at mkfs time.
>=20
> Having a big dumb block of checksums would be easier to prefetch from=
 disk for
> fsck and kernel driver, rather than having to dig through some tree s=
tructure.
> (More on that below)
>=20
> > There are also other problems we should be concerned with. Ext4 fil=
e system
> > does have support for metadata checksumming so all the metadata doe=
s have
> > its own checksum. While we can avoid unnecessarily checksuming inod=
es, group
> > descriptors and basicall all statically positioned metadata, we sti=
ll have
> > dynamically allocated metadata blocks such as extent blocks. These =
block
> > do not have to be checksummed but we would still have space reserve=
d in the
> > checksum table.
>=20
> Don't forget directory blocks--they (should) have checksums too, so y=
ou can
> skip those.
Just quick note: We can hide checksum for directory inside
ext4_dir_entry_2 for a special dirs '.' or '..' simply be increasing
->rec_len which make this feature compatible with older FS
>=20
> I wonder, could we use this table to store backrefs too?  It would ma=
ke the
> table considerably larger, but then we could (potentially) reconstruc=
t broken
> extent trees.
>=20
> > I think that we should be able to make this feature without introdu=
cing any
> > incompatibility, but it would make more sense to make it RO compati=
ble only
> > so we can preserve the checksums. But that's up to the implementati=
on.
>=20
> I think you'd have to have it be rocompat, otherwise you could write =
data with
> an old kernel and a new kernel would freak out.
>=20
> > b) Special inode
> > ----------------
> >=20
> > This is very "lazy" solution and should not be difficult to impleme=
nt. The
> > idea is to have a special inode which would store the checksum bloc=
ks in
> > it's own data blocks.
> >=20
> > The big disadvantage is that we would have to walk the extent tree =
twice for
> > each read, or write. There is not much to say about this solution o=
ther than
> > again we can make this feature without introducing any incompatibil=
ity, but
> > it would probably make more sense to make it RO compatible to prese=
rve the
> > checksums.
> >=20
> > c) Per inode checksum b-tree
> > ----------------------------
> >=20
> > See d)
> >=20
> > d) Per block group checksum b-tree
> > ----------------------------------
> >=20
> > Those two schemes are very similar in that both would store checksu=
m in a
> > b-tree with a block number (we could use logical block number in pe=
r inode
> > tree) as a key. Obviously finding a checksum would be in logarithmi=
c time,
> > while the size of the tree would be possibly much bigger in the per=
-inode
> > case. In per block group case we will have much smaller boundary of
> > number of checksum blocks stored.
> >=20
> > This and the fact that we would have to have at least one checksum =
block
> > per inode (which would be wasteful in the case of small files) is m=
aking per
> > block group solution much more viable. However the major disadvanta=
ge of
> > per block group solution is that the checksum tree would create a s=
ource of
> > contention when reading/writing from/to a different inodes in the s=
ame block
> > group. This might be mitigated by having a worker thread per a rang=
e of block
> > groups - but it might still be a bottleneck.
> >=20
> > Again we still have 4 Bytes in ext4_group_desc to store the pointer=
 to the
> > root of the tree. While the ext4_inode structure have 4Bytes of
> > i_obso_faddr but that's not enough. So we would have to figure out =
where to
> > store it - we could possibly abuse i_block to store it along with t=
he extent
> > nodes.
>=20
> I think(?) your purpose in using either a special inode or a btree to=
 store the
> checksums is to avoid wasting checksum blocks on things that are alre=
ady
> checksummed?  I'm not sure that we'd save enough space to justify the=
 extra
> processing.
>=20
> --D
>=20
> > File system scrub
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> > While this is certainly a feature which we want to have in both use=
rspace
> > e2fsprogs and kernel I do not have any design notes at this stage.
> >=20
> >=20
> >=20
> >=20
> > I am sure that there are other possibilities and variants of those =
design
> > ideas, but I think that this should be enough to have a discussion =
started.
> > As I is not I think that the most viable option is d) that is, per =
block
> > group checksum tree, which gives us enough flexibility while not be=
ing too
> > complex solution.
> >=20
> > I'll try to update this description as it will be getting more conc=
rete
> > structure and I hope that we will have some productive discussion a=
bout
> > this at LSF.
> >=20
> > Thanks!
> > -Lukas
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
