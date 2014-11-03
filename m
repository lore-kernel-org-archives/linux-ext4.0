From: Theodore Ts'o <tytso@mit.edu>
Subject: Some thoughts about providing data block checksumming for ext4
Date: Mon, 3 Nov 2014 18:33:08 -0500
Message-ID: <20141103233308.GA27842@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36609 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbaKCXdN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Nov 2014 18:33:13 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been thinking a lot about the best way to provide data block
checksumming for ext4 in an efficient way, and as I promised on
today's ext4 concall, I want to detail them in the hopes that it will
spark some more interest in actually implementing this feature,
perhaps in a more general way than just for ext4.

I've included in this writeup a strawman design to implement data
block checksuming as a device mapper module.

Comments appreciated!

						- Ted

The checksum consistency problem
=================================

Copy-on-write file systems such as btrfs and zfs have a big
advantage when it comes to providing data block checksums because they
never overwrite an existing data block.  In contrast, update-in-place
file systems such as ext4 and xfs, if they want to provide data block
checksums, must be able to update checksum and the data block
atomically, or else if the system fails at an inconvenient point in
time, the previously existing block in a file would have an
inconsistent checksum and contents.   

In the case of ext4, we can solve this by the data blocks through the
journal, alongside the metadata block containing the checksum.
However, this results in the performance cost of doing double writes
as in data=journal mode.  We can do slightly better by skipping this
if the block in question is a newly allocated block, since there is no
guarantee that data will be safe until an fsync() call, and in the
case of a newly allocated block, there is no previous contents which
is at risk.

But there is a way we can do even better!  If we can manage to
compress the block even by a tiny amount, so that 4k block can be
stored in 4092 bytes (which means we need to be able to compress the
block by 0.1%), we can store the checksum inline with the data, which
can then be atomically updated assuming a modern drive with a 4k
sector size (even a 512e disk will work fine, assuming the partition
is properly 4k aligned).  If the block is not sufficiently
compressible, then we will need to store the checksum out-of-line, but
in practice, this should be relatively rare.  (The most common case of
incompressible file formats are things like media files and
already-compressed packages, and these files are generally not updated
in a random-write workload.)

In order to distinguish between these a compressed+checksum and
non-compressed+out-of-line checksum block, we can use a CRC-24
checksum.  In the compressed+checksum case, we store a zero in the
first byte of the block, followed by a 3 byte checksum, followed by
the compressed contents of the block.  In the case where block can not
be compressed, we save the high nibble of the block plus the 3 byte
CRC-24 checksum in the out-of-line metadata block, and then we set the
high nibble of the block to be 0xF so that there is no possibility
that a block with an original initial byte of zero will be confused
with a compressed+checksum block.  (Why the high nibble and not the
just the first byte of the block?  We have other planned uses for
those 4 bits; more later in this paper.)

Storing the data block checksums in ext4
========================================

There are two ways that have been discussed for storing data block
checksums in ext4.  The first approach is to dedicate every a checksum
block every 1024 blocks, which would be sufficient to store a 4 byte
checksum (assuming a 4k block).  This approach has the advantage of
being very simple.  However, it becomes very difficult to upgrade an
existing file system to one that supports data block checksums without
doing the equivalet of a backup/restore operation.

The second approach is to store the checksums in a per-inode structure
which is indexed by logical block number.  This approach makes is much
simpler to upgrade an existing file system.  In addition, if not all
files need to be data integrity protected, it is less efficient.  The
case where this might become important is in the case where we are
using a cryptographic Message Authentication Code (MAC) instead of a
checksum.  This is because a MAC is significantly larger than 4 byte
checksum, and not all of the files in the file system might be
encrypted and thus need cryptographic data integrity protection in
order to protect against certain chosen plaintext attacks.  In that
case, only using a per-inode structure in those cases for those file
blocks which require protection might make a lot of sense.  (And if we
pursue cryptographic data integrity guarantees for the ext4 encryption
project, we will probably need to go down this route).  The massive
disadvantage of this scheme is that it is significantly more
complicated to implement.

However, if we are going to simply intersperse the metadata blocks
alongside the data blocks, there is no real need to do this work in
the file system.  Instead, we can actually do this work in a device
mapper plugin instead.  This has the advantage that it moves the
complexity outside of the file system, and allows any update-in-place
file system (including xfs, jfs, etc.) to gain the benefits data block
checksumming.  So in the next section of this paper I will outline a
strawman design of such a dm plugin.

Doing data block checksumming as a device-mapper plugin
=======================================================

Since we need to give this a name, for now I'm going to call this
proposed plugin "dm-protected".  (If anyone would like to suggest a
better name, I'm all ears.)

The Non-Critical Write flag
---------------------------

First, let us define an optional extension to the Linux block layer
which allows to provide a certain optimization when writing
non-compressible files such as audio/video media files, which are
typically written in a streaming fashion and which are generally not
updated in place after they are initially written.  As this
optimization is purely optional, this feature might not be implemented
initially, and a file system does not have to take advantage of this
extension if it is implemented.

If present, this extension allows the file system to pass a hint to
the block device that a particular data block write is the first time
that a newly allocated block is being written.  As such, it is not
critically important that the checksum be atomically updated when the
data block is written, in the case where the data block can not be
compressed such that the checksum can fit inline with the compressed
data.

XXX I'm not sure "non-critical" is the best name for this flag.  It
may be renamed if we can think of a better describe name.

Layout of the pm-protected device
---------------------------------

The layout of the the dm-protected device is a 4k checksum block
followed by 1024 data blocks.  Hence, given a logical 4k block number
(LBN) L, the checksum block associated with that LBN is located at
physical block number (PBN):

	PBN_checksum = (L + 1) / 1024

where '/' is an C-style integer division operation.

The PBN where the data for stored at LBN can be calculated as follows:

	PBN_L = L + (L / 1024) + 1

The checksum block is used when we need to store an out-of-line
checksum for a particular block in its "checksum group", where we
treat the contents of checksum block as a 4 byte integer array, and
where the entry for a particular LBN can be found by indexing into (L
% 1024).

For redundancy purposes we calculate the metadata checksum of the
checksum block assuming that low nibble of the first byte in each
entry is entry, and we use the low nibbles of first byte in each entry
to store store the first LBN for which this block is used plus the
metdata checksum of the checksum block.  We encoding the first LBN for
the checksum block so we can identify the checksum block when it is
copied into the Active Area (described below).


Writing to the dm-protected device
-----------------------------------

As described earlier, when we write to the dm-protected device, the
plugin will attempt to compress the contents of the data block.  If it
is successful at reducing the required storage size by 4 bytes, then
it will write the block in place.

If the data block is not compressible, and this is a non-critical
write, then we update the checksum in the checksum block for that
particular LBN range, and we write out the data block immediately, and
then after a 5 second delay (in case there are subsequent
non-compressible, non-critial writes, as there will probably be when
large media file is written), we write out the modified checksum
block.

If the data block is not compressible, and the write is not marked as
non-critcal, then we need to worry about making sure the data block(s)
and the checksum block are written out transactionally.  To do this, we
write the current contents of the checksum block to a free block in
the Active Area (AA) using FUA, which is 64 block area which is used to
store a copy of checksum blocks for which their blocks are actively
being modified.  We then calculate the checksum for the modified data
blocks in the checksum group, and update the checksum block in memory,
but we do not allow any of the data blocks to be written out until one
of the following has happened and we need to trigger a commit of the
checksum group:

   *) a 5 second timer has expired
   *) we have run out of free slots in the Active Area
   *) we are under significant memory pressure and we need to release some of
         the pinned buffers for the data blocks in the checksum group
   *) the file system has requested a FLUSH CACHE operation

A commit of the checksum group consists of the following:

1) An update of the checksum block using a FUA write
2) Writing all of the pinned data blocks in the checksum group to disk
3) Sending a FLUSH CACHE request to the underlying storage
4) Allowing the slot in the Active Area to be used for some other checksum block

Recovery after a power fail
---------------------------

If the dm-protected device was not cleanly shut down, then we need to
examine all of the checksum blocks in the Active Area.  For each
checksum block in the AA, the checksums for all of their data blocks
should machine either the checksum found in the AA, or the checksum
found in the checksum block in the checksum group.  Once we have which
checksum corresponds to the data block after the unclean shutdown, we
can update the checksum block and clear the copy found in the AA.

On a clean shutdown of the dm-protected device, we can clear the
Active Area, and so the recovery procedure will not be needed the next
time the dm-protected device is initialized.

Integration with other DM modules
=================================

If the dm-protected device is layered on dm-raid 1 setup, then if
there is a checksum failure the dm-protected device should attempt to
fetch the alternate copy of the device.

Of course, the the dm-protected module could be layered on top of a
dm-crypt, dm-thin module, or LVM setup.

Conclution
==========

In this paper, we have examined some of the problems of providing data
block checksumming in ext4, and have proposed a solution which
implements this functionality as a device-mapper plugin.  For many
file types, it is expected that using a very fast compression
algorithm (we only need to compress the block by less than 0.1%) will
allow us to provide data block checksumming with almost no I/O
overhead and only a very modest amount of CPU overhead.

For those file types which contain a large number of incompressible
block, if they do not need to be updated-in-place, we can also
minimize the overhead by avoiding the need to do a transactional
update of the data block and the checksum block.

In those cases where we do need to do a transactional update of the
checksum block relative to the data blocks, we have outlined a very
simple logging scheme which is both efficient and relatively easy to
implement.


