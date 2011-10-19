From: Aditya Kali <adityakali@google.com>
Subject: [RFC] Metadata Replication for Ext4
Date: Tue, 18 Oct 2011 18:12:48 -0700
Message-ID: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nauman Rafique <nauman@google.com>, Theodore Tso <tytso@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:62115 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1JSBNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Oct 2011 21:13:11 -0400
Received: from hpaq13.eem.corp.google.com (hpaq13.eem.corp.google.com [172.25.149.13])
	by smtp-out.google.com with ESMTP id p9J1DAuV032189
	for <linux-ext4@vger.kernel.org>; Tue, 18 Oct 2011 18:13:10 -0700
Received: from pzk36 (pzk36.prod.google.com [10.243.19.164])
	by hpaq13.eem.corp.google.com with ESMTP id p9J0nSCv027633
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 18 Oct 2011 18:13:08 -0700
Received: by pzk36 with SMTP id 36so4225458pzk.11
        for <linux-ext4@vger.kernel.org>; Tue, 18 Oct 2011 18:13:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a proposal for new ext4 feature that replicates ext4 metadata
and provides recovery in case where device blocks storing filesystem
metadata goes bad. When the filesystem encounters a bad block during
read, it returns EIO to the user. If this is a data block for some
inode then the user application can handle this error in many
different ways. But if we fail reading a filesystem metadata block
(bitmap block, inode table block, directory block, etc.), we could
potentially lose access to much larger amount of data and render the
filesystem unusable. It is difficult (and not expected) for the user
application to recover from such filesystem metadata loss. This
problem is observed to be much more severe on SSDs which tend to show
more frequent read errors when compared to disks over the same
duration.

There are different ways in which block read errors in different
metadata could be handled. For example, if the filesystem is unable to
read a block/inode allocation bitmap then we could just assume that
all the blocks/inodes in that block group are allocated and let fsck
fix this later. For inode table and directory blocks, we could play
some (possibly unreliable) tricks with fsck. In either case, the
filesystem will be fully usable only after it=E2=80=99s fsck=E2=80=99d =
(which is a
disruptive process on production systems). Darrick Wong=E2=80=99s recen=
t
patches for metadata checksumming will detect even more non-hardware
failure related problems, but they don=E2=80=99t offer any recovery mec=
hanism
from the checksum failures.

Metadata replication is another approach that can allow the filesystem
to recover from the device read errors or checksumming errors at
runtime and allow continued usage of the filesystem. In case of read
failures or checksum failures, reading from the replica can allow live
recovery of the lost metadata. This document gives some details about
how the Ext4 metadata could be replicated and used by the filesystem.

We can categorize the filesystem metadata into two main types:

* Static metadata: Metadata that gets allocated at mkfs time and takes
fixed amount of space on disk (which is known upfront). This includes
block & inode allocation bitmaps and inode tables. (We don=E2=80=99t co=
unt
superblock and group descriptors here because they are already
replicated on the filesystem). On a 1Tb drive using bigalloc with
cluster size of 1Mb, this amounts to around 128Mb. Without bigalloc,
static metadata for the same 1Tb drive is around 6Gb assuming
=E2=80=9Cbytes-per-inode=E2=80=9D is 20Kb.

* Dynamic metadata: Metadata that gets created and deleted as the
filesystem is used. This includes directory blocks, extent tree
blocks, etc. The size of this metadata varies depending on the
filesystem usage.
In order to reduce some complexity, we consider only directory blocks
for replication in this category. This is because directory block
failures affects access to more number of inodes and replicating
extent tree blocks is likely to make replication expensive (both in
terms of performance and space used).

The new ext4 =E2=80=98replica=E2=80=99 feature introduces a new reserve=
d inode,
referred in rest of this document as the replica inode, for storing
the replicated blocks for static and dynamic metadata. The replica
inode is created at mke2fs time when =E2=80=98replica=E2=80=99 feature =
is set. The
replica inode will contain:
* replica superblock in the first block
* replicated static metadata
* index blocks for dynamic metadata (We will need a mapping from
original-block-number to replica-block-number for dynamic metadata.
The =E2=80=98index blocks=E2=80=99 will store this mapping. This is exp=
lained below in
more detail).
* replicated dynamic metadata blocks

The superblock structure is as follows:

struct ext4_replica_sb {
	__le32	r_wtime;		/* Write time. */
	__le32	r_static_offset;	/* Logical block number of the first
					 * static block replica. */
	__le32	r_index_offset;	/* Logical block number of the first
					 * index block for dynamic metadata replica. */
	__le16	r_magic;		/* Magic signature */
	__u8		r_log_groups_per_index;	/* Number of block-groups
					 * represented by each index block. */
	__u8 r_reserved_pad;		/* Unused padding */
};

The replica could be stored on an external device or on the same
device (makes sense in case of SSDs). The replica superblock will be
read and initialized at mount time.


Replicating Static Metadata:

The replica superblock contains the position (=E2=80=98r_static_offset=E2=
=80=99)
within the replica inode from where static metadata replica starts.
The length of static metadata is fixed and known at mke2fs time.
Mke2fs will place the replica of static metadata after replica
superblock and set the r_static_offset value in superblock. This
section in inode will contain all static metadata (block bitmap, inode
bitmap & inode table) for group 0, then all static metadata for group
1, and so on. Given a filesystem block number (ext4_fsblk_t), it is
possible to efficiently compute the group number and the location of
the replicated block in the replica inode. Not needing a separate
index to map from original to replica is the main advantage of
handling static metadata separately from the dynamic metadata.
On metadata read failure, the filesystem can overwrite the original
block with a copy from replica. The overwriting will cause the bad
sector to be remapped and we don=E2=80=99t need to mark the filesystem =
as
having errors.


Replicating Dynamic Metadata:

Replicating dynamic metadata will be more complicated compared to
static metadata. Since the locations of dynamic metadata on filesystem
is not fixed, we don=E2=80=99t have an implicit mapping from original t=
o
replica for it. Thus we need additional =E2=80=98index blocks=E2=80=99 =
to store this
mapping. Moreover, the amount of dynamic metadata on a filesystem will
vary depending on its usage and it cannot be determined at mke2fs
time. Thus, the replica inode will have to be extended as new metadata
gets allocated on the filesystem.

Here is what we would like to propose for dynamic metadata:
* Let =E2=80=9C(1 << r_log_groups_per_index)=E2=80=9D be the number of =
groups for
which we will have one index block. This means that any replicated
dynamic metadata block residing in these block-groups will have an
entry in the same single index block. By default, we will keep
r_log_groups_per_index same as s_log_groups_per_flex. Thus we will
have one index block per flex block group.
* Store these index blocks starting immediately after the static
metadata replica blocks. 'r_index_offset' points to the first index
block.
* Each of these index blocks will have the following structure:
	struct ext4_replica_index {
		__le16 ri_magic;
		__le16 ri_num_entries;
		__le32 ri_reserved[3];  // reserved for future use
		struct {
			__le32 orig_fsblk_lo;
			__le32 orig_fsblk_hi;
			__le32 replica_lblk;  // ext4_lblk_t - logical offset into replica i=
node.
		} ri_entries[];
	}

Each of the 'ri_entries' is a map from the original block number to
its replicated block in the replica inode:
        [(orig_fsblk_hi << 32 | orig_fsblk_lo) : replica_lblk]

There are 4 operations that accesses these dynamic metadata index block=
s:
	* Lookup/Update replica for given block number
		- This is a binary search over 'ri_entries' (O(lg N))
	* Remove replica for given block number
		- Lookup (as above).
		- Set the =E2=80=98orig_fsblk_lo=E2=80=99 & =E2=80=98orig_fsblk_hi=E2=
=80=99 to 0 and leave the
=E2=80=98replica_lblk=E2=80=99 value unchanged.
		- memmove the 0=E2=80=99ed entry at the top or ri_entries.
	* Add replica for given block number
		- First check if there is a =E2=80=98deleted=E2=80=99 entry at the to=
p with valid
=E2=80=98replica_lblk=E2=80=99 value. If available, then set its =E2=80=
=98orig_fsblk_lo=E2=80=99 &
=E2=80=98orig_fsblk_hi=E2=80=99. If not, allocate a new block at the en=
d of the
replica inode and create an entry for mapping this block.
		- memmove to insert the new entry in appropriate location in =E2=80=98=
ri_entries=E2=80=99.

The idea above is that we maintain the =E2=80=98ri_entries=E2=80=99 on =
sorted order so
that the most frequent operation (index lookup) is efficient while
keeping the initial implementation simple. The index blocks will be
pinned in memory at mount time. We can explore other more efficient
approaches (like a BST or other structures) for managing ri_entries in
future.

If the index block is full and we need to add an entry, we can:
* simply stop replicating unless some blocks are freed
* start replacing entries from the beginning in the index.
* add another index block (specifying its location in the
=E2=80=98ri_reserved=E2=80=99) and add the entry
   in it after replication
In the first version of replica implementation, we will simply stop
replicating if there is no more space in the index block or if it is
not possible to extend the inode. Given above =E2=80=98struct
ext4_replica_index=E2=80=99 and a filesystem block size of 4Kb, we will=
 be
able to store 340 entries within each index block. This means that we
can replicate up to 340 directory blocks per flex-bg.
In case of metadata block being removed, we will have to remove its
entry from the index. It will be inefficient to free random blocks
from the replica inode, so we will keep the =E2=80=98replica_blk=E2=80=99=
 value as it
is in the index while zeroing out the orig_block_* values. (We can
reuse this block for replicating some other metadata block in the
future.) The effect of this is that the replica inode=E2=80=99s size wi=
ll
increase with more metadata being created but it will never decrease
if metadata is freed.


Replica overhead considerations:

Maintaining the replica requires us to pay some cost. Here are some
concerns and possible mitigation strategies:
1) All metadata updates requires corresponding replica updates. Here
we simply copy the original into buffer_head for replica and mark the
buffer dirty without actually reading the block first. The actual
writeout of replica buffer will happen alongwith background writeout.
2) Pinning the index blocks in memory is necessary for efficiency.
Assuming flex-bg size of 16 and blocksize of 4Kb on a 1Tb drive, this
overhead will be 2 index blocks (4Kb) for a 1Tb bigalloc system with
cluster size of 1MB and 512 index blocks (2Mb) for regular ext4
(assuming "inode-size" to be 128bytes and "bytes-per-inode" to be
20Kb).
3) Memory overhead beause of replica buffer_heads.
4) The replica inode won=E2=80=99t shrink at runtime even if the origin=
al
metadata is removed. Thus the disk space used by replica will be
unrecoverable. We can possibly compact the replica at e2fsck time.

I have a working prototype for the static metadata part (replicated on
the same device). The dynamic metadata part is still work in progress.
I needed couple of additional kernel changes to make all the metadata
IO go through a single function in ext4. This allows us to have a
single place as an entry point for the replica code.

Comments and feedback appreciated.

Credits for ideas and suggestions:
Nauman Rafique (nauman@google.com)
Ted Ts'o (tytso@google.com)

--
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
