From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Some thoughts about providing data block checksumming for ext4
Date: Tue, 4 Nov 2014 14:20:44 -0700
Message-ID: <40B6067C-099E-4665-834C-4EF98F4D5618@dilger.ca>
References: <20141103233308.GA27842@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_BFD45628-82B4-41EC-8F14-1762B85DC992"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, dm-devel@redhat.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56693 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaKDVUs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2014 16:20:48 -0500
Received: by mail-pa0-f47.google.com with SMTP id kx10so15103961pab.6
        for <linux-ext4@vger.kernel.org>; Tue, 04 Nov 2014 13:20:48 -0800 (PST)
In-Reply-To: <20141103233308.GA27842@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_BFD45628-82B4-41EC-8F14-1762B85DC992
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Nov 3, 2014, at 4:33 PM, Theodore Ts'o <tytso@mit.edu> wrote:

> I've been thinking a lot about the best way to provide data block
> checksumming for ext4 in an efficient way, and as I promised on
> today's ext4 concall, I want to detail them in the hopes that it will
> spark some more interest in actually implementing this feature,
> perhaps in a more general way than just for ext4.
>=20
> I've included in this writeup a strawman design to implement data
> block checksuming as a device mapper module.
>=20
> Comments appreciated!
>=20
> 						- Ted
>=20
> The checksum consistency problem
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Copy-on-write file systems such as btrfs and zfs have a big
> advantage when it comes to providing data block checksums because they
> never overwrite an existing data block.  In contrast, update-in-place
> file systems such as ext4 and xfs, if they want to provide data block
> checksums, must be able to update checksum and the data block
> atomically, or else if the system fails at an inconvenient point in
> time, the previously existing block in a file would have an
> inconsistent checksum and contents.  =20
>=20
> In the case of ext4, we can solve this by the data blocks through the
> journal, alongside the metadata block containing the checksum.
> However, this results in the performance cost of doing double writes
> as in data=3Djournal mode.  We can do slightly better by skipping this
> if the block in question is a newly allocated block, since there is no
> guarantee that data will be safe until an fsync() call, and in the
> case of a newly allocated block, there is no previous contents which
> is at risk.
>=20
> But there is a way we can do even better!  If we can manage to
> compress the block even by a tiny amount, so that 4k block can be
> stored in 4092 bytes (which means we need to be able to compress the
> block by 0.1%), we can store the checksum inline with the data, which
> can then be atomically updated assuming a modern drive with a 4k
> sector size (even a 512e disk will work fine, assuming the partition
> is properly 4k aligned).  If the block is not sufficiently
> compressible, then we will need to store the checksum out-of-line, but
> in practice, this should be relatively rare.  (The most common case of
> incompressible file formats are things like media files and
> already-compressed packages, and these files are generally not updated
> in a random-write workload.)

My main concern here would be the potential performance impact.  This
wouldn't ever reduce the amount of data actually written to any block
(presumably the end of the block would be zero-filled to avoid leaking
data), so the compress + checksum would mean every data block must have
every byte processed by the filesystem.

It's bad enough even having to do something once for each block (hence
mballoc and bios to allocate and submit many blocks at once), so if this
has to compress and checksum (or vice versa) every block it could get
expensive.  Ideally the compress+checksum operations would be combined,
so that only a single pass would be needed for all of the data.

> In order to distinguish between these a compressed+checksum and
> non-compressed+out-of-line checksum block, we can use a CRC-24
> checksum.  In the compressed+checksum case, we store a zero in the
> first byte of the block, followed by a 3 byte checksum, followed by
> the compressed contents of the block.  In the case where block can not
> be compressed, we save the high nibble of the block plus the 3 byte
> CRC-24 checksum in the out-of-line metadata block, and then we set the
> high nibble of the block to be 0xF so that there is no possibility
> that a block with an original initial byte of zero will be confused
> with a compressed+checksum block.  (Why the high nibble and not the
> just the first byte of the block?  We have other planned uses for
> those 4 bits; more later in this paper.)
>=20
> Storing the data block checksums in ext4
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> There are two ways that have been discussed for storing data block
> checksums in ext4.  The first approach is to dedicate every a checksum
> block every 1024 blocks, which would be sufficient to store a 4 byte
> checksum (assuming a 4k block).  This approach has the advantage of
> being very simple.  However, it becomes very difficult to upgrade an
> existing file system to one that supports data block checksums without
> doing the equivalet of a backup/restore operation.
>=20
> The second approach is to store the checksums in a per-inode structure
> which is indexed by logical block number.  This approach makes is much
> simpler to upgrade an existing file system.  In addition, if not all
> files need to be data integrity protected, it is less efficient.  The

s/less efficient/more efficient/ to checksum only some of the files?

> case where this might become important is in the case where we are
> using a cryptographic Message Authentication Code (MAC) instead of a
> checksum.  This is because a MAC is significantly larger than 4 byte
> checksum, and not all of the files in the file system might be
> encrypted and thus need cryptographic data integrity protection in
> order to protect against certain chosen plaintext attacks.  In that
> case, only using a per-inode structure in those cases for those file
> blocks which require protection might make a lot of sense.  (And if we
> pursue cryptographic data integrity guarantees for the ext4 encryption
> project, we will probably need to go down this route).  The massive
> disadvantage of this scheme is that it is significantly more
> complicated to implement.

If e.g. SHA-256 is needed, then compress-by-32-bytes with the
inline checksum might be a lot harder than compress-by-4-bytes, but
not necessarily impossible for 4KB blocks unless they are already
compressed files. =20

> However, if we are going to simply intersperse the metadata blocks
> alongside the data blocks, there is no real need to do this work in
> the file system.  Instead, we can actually do this work in a device
> mapper plugin instead.  This has the advantage that it moves the
> complexity outside of the file system, and allows any update-in-place
> file system (including xfs, jfs, etc.) to gain the benefits data block
> checksumming.  So in the next section of this paper I will outline a
> strawman design of such a dm plugin.

I think it is easier to determine at the filesystem level if the data
blocks are overwriting existing blocks or not, without the overhead
of having to send per-unlink/truncate trim commands down to a DM device.
Having this implemented in ext4 allows a lot more flexibility in how
and when to store the checksum (e.g. per-file checksum flags that are
inherited, store the checksum for small incompressible files in the =
inode
or in extent blocks, etc).

> Doing data block checksumming as a device-mapper plugin
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>=20
> Since we need to give this a name, for now I'm going to call this
> proposed plugin "dm-protected".  (If anyone would like to suggest a
> better name, I'm all ears.)

"dm-checksum" would be better, since "protected" falsely implies that
the data is somehow protected against loss or corruption, when it only
really allows detecting the corruption and not fixing it.

> The Non-Critical Write flag
> ---------------------------
>=20
> First, let us define an optional extension to the Linux block layer
> which allows to provide a certain optimization when writing
> non-compressible files such as audio/video media files, which are
> typically written in a streaming fashion and which are generally not
> updated in place after they are initially written.  As this
> optimization is purely optional, this feature might not be implemented
> initially, and a file system does not have to take advantage of this
> extension if it is implemented.
>=20
> If present, this extension allows the file system to pass a hint to
> the block device that a particular data block write is the first time
> that a newly allocated block is being written.  As such, it is not
> critically important that the checksum be atomically updated when the
> data block is written, in the case where the data block can not be
> compressed such that the checksum can fit inline with the compressed
> data.
>=20
> XXX I'm not sure "non-critical" is the best name for this flag.  It
> may be renamed if we can think of a better describe name.

Something like "write-once" or "idempotent" or similar, since that
makes it clear how this is used.  I think anyone who is checksumming
their data would consider that it is "critical".

> Layout of the pm-protected device
> ---------------------------------
>=20
> The layout of the the dm-protected device is a 4k checksum block
> followed by 1024 data blocks.  Hence, given a logical 4k block number
> (LBN) L, the checksum block associated with that LBN is located at
> physical block number (PBN):
>=20
> 	PBN_checksum =3D (L + 1) / 1024
>=20
> where '/' is an C-style integer division operation.

>=20
> The PBN where the data for stored at LBN can be calculated as follows:
>=20
> 	PBN_L =3D L + (L / 1024) + 1
>=20
> The checksum block is used when we need to store an out-of-line
> checksum for a particular block in its "checksum group", where we
> treat the contents of checksum block as a 4 byte integer array, and
> where the entry for a particular LBN can be found by indexing into (L
> % 1024).
>=20
> For redundancy purposes we calculate the metadata checksum of the
> checksum block assuming that low nibble of the first byte in each
> entry is entry, and we use the low nibbles of first byte in each entry

s/each entry is entry/each entry is zero/ ?

> to store store the first LBN for which this block is used plus the
> metdata checksum of the checksum block.  We encoding the first LBN for
> the checksum block so we can identify the checksum block when it is
> copied into the Active Area (described below).
>=20
>=20
> Writing to the dm-protected device
> -----------------------------------
>=20
> As described earlier, when we write to the dm-protected device, the
> plugin will attempt to compress the contents of the data block.  If it
> is successful at reducing the required storage size by 4 bytes, then
> it will write the block in place.
>=20
> If the data block is not compressible, and this is a non-critical
> write, then we update the checksum in the checksum block for that
> particular LBN range, and we write out the data block immediately, and
> then after a 5 second delay (in case there are subsequent
> non-compressible, non-critial writes, as there will probably be when
> large media file is written), we write out the modified checksum
> block.

The good news is that (IMHO) these two uses are largely exclusive.
Files that are incompressible (e.g. media) are typically write-once,
while databases and other apps that overwrite files in place do not
typically compress the data blocks.

> If the data block is not compressible, and the write is not marked as
> non-critcal, then we need to worry about making sure the data block(s)
> and the checksum block are written out transactionally.  To do this, =
we
> write the current contents of the checksum block to a free block in
> the Active Area (AA) using FUA, which is 64 block area which is used =
to
> store a copy of checksum blocks for which their blocks are actively
> being modified.  We then calculate the checksum for the modified data
> blocks in the checksum group, and update the checksum block in memory,
> but we do not allow any of the data blocks to be written out until one
> of the following has happened and we need to trigger a commit of the
> checksum group:
>=20
>   *) a 5 second timer has expired
>   *) we have run out of free slots in the Active Area
>   *) we are under significant memory pressure and we need to release =
some of
>         the pinned buffers for the data blocks in the checksum group
>   *) the file system has requested a FLUSH CACHE operation

Why introduce a new mechanism when this could be done using data=3Djournal=

writes for incompressible data?  This is essentially just implementing
jbd2 journaling with a bunch of small journals (AAs), and we could save
a lot of code complexity by re-using the existing jbd2 code to do it.

Using data=3Djournal, if there is a crash after the commit to the =
journal,
the data blocks and checksums will be checkpointed to the filesystem
again if needed, or be discarded without modifying the original data
blocks if the transaction didn't commit.

The journal would only need to get involved if data blocks couldn't be
compressed, and if overwriting existing data (presumably a rare case,
but this couldn't be optimized in a dm-layer device unless it was sparse
and was tracking block usage/trim.

Using the existing jbd2 code in this case could also take advantage of
optimizations like putting the journal on a separate disk, or on flash
for fast write/commit and the checkpoint can be done in the background
asynchronously.  We could potentially allow multiple data journals per
device (multiple AAs) if there was a good reason to do so, since any
dependencies between blocks can be avoided, unlike with namespace ops.

> A commit of the checksum group consists of the following:
>=20
> 1) An update of the checksum block using a FUA write
> 2) Writing all of the pinned data blocks in the checksum group to disk
> 3) Sending a FLUSH CACHE request to the underlying storage
> 4) Allowing the slot in the Active Area to be used for some other =
checksum block
>=20
> Recovery after a power fail
> ---------------------------
>=20
> If the dm-protected device was not cleanly shut down, then we need to
> examine all of the checksum blocks in the Active Area.  For each
> checksum block in the AA, the checksums for all of their data blocks
> should machine either the checksum found in the AA, or the checksum

s/machine/match/ ?

> found in the checksum block in the checksum group.  Once we have which
> checksum corresponds to the data block after the unclean shutdown, we
> can update the checksum block and clear the copy found in the AA.

This is essentially journal checksums, which also already exist.

> On a clean shutdown of the dm-protected device, we can clear the
> Active Area, and so the recovery procedure will not be needed the next
> time the dm-protected device is initialized.

This is normal journal checkpoint and cleanup.

> Integration with other DM modules
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> If the dm-protected device is layered on dm-raid 1 setup, then if
> there is a checksum failure the dm-protected device should attempt to
> fetch the alternate copy of the device.
>=20
> Of course, the the dm-protected module could be layered on top of a
> dm-crypt, dm-thin module, or LVM setup.
>=20
> Conclution
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> In this paper, we have examined some of the problems of providing data
> block checksumming in ext4, and have proposed a solution which
> implements this functionality as a device-mapper plugin.  For many
> file types, it is expected that using a very fast compression
> algorithm (we only need to compress the block by less than 0.1%) will
> allow us to provide data block checksumming with almost no I/O
> overhead and only a very modest amount of CPU overhead.
>=20
> For those file types which contain a large number of incompressible
> block, if they do not need to be updated-in-place, we can also
> minimize the overhead by avoiding the need to do a transactional
> update of the data block and the checksum block.
>=20
> In those cases where we do need to do a transactional update of the
> checksum block relative to the data blocks, we have outlined a very
> simple logging scheme which is both efficient and relatively easy to
> implement.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_BFD45628-82B4-41EC-8F14-1762B85DC992
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVFlDLHKl2rkXzB/gAQKlyBAAgXGp7jjLvewQkQdvNrHCRDq6pgfDVRI5
vFanBlzoMPz3dNDdY/X7DG+g2PPF7ttKODeuf3DbZw12kR/cw4Px1pwOMh02CNCr
d+k4KxU03N3gKGAVPHAcNWkztpKhBRhe1GEwdd/u4oZmm4ZqiHSfKS27quTwsbt+
z3WHGL2tiyi5ty4yGOLaNSdpBZqy8IoZShtshfUPKR675JJoKtcTxx0YMCXgfAzL
8GnLAia6OfvXbNRKTOuFjehaO3csUQGhukEfMCxWmCXciFpSG7VFJvunR5/namEx
iKjhDoYA+5b4+Qz6ugFijR41/+wWPNo7Xs8MKAmF3Y0KxOfQRPzUgI3jHiuN51dS
aTel+28ArCJ1YGXbwBqPpNn2YuKDdN/w7Er4LDtFqbZEWwXbBPEojHngbz/dRKeY
Q4mMH6ehc8wevhiEhPO4R8O/+grJFQ9IFbjPMg2he9zD2k6mu0Qwa/TkYFcCqLS1
AQakzJaB9vMngyfHwXSFyYDYV0xhKFnTGkdjSTJAcZCnTa3hsF8Vc1vqPuoQWrKS
21f0fTlPYnKPL0MLB6h4T0faLbySPPYSaDD8LfNafhk2HovdjKXAmMZvSzLc4xU4
RaO9wsMmlSiGRvxp3PZc1FDVsnllNETuwEE3LPQPc97v3B3Z9MikNqorEcqZv6F0
9OqqUSF3XSE=
=s1Hv
-----END PGP SIGNATURE-----

--Apple-Mail=_BFD45628-82B4-41EC-8F14-1762B85DC992--
