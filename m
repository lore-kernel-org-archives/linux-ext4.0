From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC] Metadata Replication for Ext4
Date: Wed, 19 Oct 2011 16:43:12 +0800
Message-ID: <CAGBYx2a4jMAfn6mCunzb+JnR_sNPNR1v7gSfPi6FTdaH+U50gQ@mail.gmail.com>
References: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Nauman Rafique <nauman@google.com>,
	Theodore Tso <tytso@google.com>
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62984 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab1JSInN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 04:43:13 -0400
Received: by iaek3 with SMTP id k3so1860887iae.19
        for <linux-ext4@vger.kernel.org>; Wed, 19 Oct 2011 01:43:12 -0700 (PDT)
In-Reply-To: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2011 at 9:12 AM, Aditya Kali <adityakali@google.com> wr=
ote:
> This is a proposal for new ext4 feature that replicates ext4 metadata
> and provides recovery in case where device blocks storing filesystem
> metadata goes bad. When the filesystem encounters a bad block during
> read, it returns EIO to the user. If this is a data block for some
> inode then the user application can handle this error in many
> different ways. But if we fail reading a filesystem metadata block
> (bitmap block, inode table block, directory block, etc.), we could
> potentially lose access to much larger amount of data and render the
> filesystem unusable. It is difficult (and not expected) for the user
> application to recover from such filesystem metadata loss. This
> problem is observed to be much more severe on SSDs which tend to show
> more frequent read errors when compared to disks over the same
> duration.
>
> There are different ways in which block read errors in different
> metadata could be handled. For example, if the filesystem is unable t=
o
> read a block/inode allocation bitmap then we could just assume that
> all the blocks/inodes in that block group are allocated and let fsck
> fix this later. For inode table and directory blocks, we could play
> some (possibly unreliable) tricks with fsck. In either case, the
> filesystem will be fully usable only after it=92s fsck=92d (which is =
a
> disruptive process on production systems). Darrick Wong=92s recent
> patches for metadata checksumming will detect even more non-hardware
> failure related problems, but they don=92t offer any recovery mechani=
sm
> from the checksum failures.
>
> Metadata replication is another approach that can allow the filesyste=
m
> to recover from the device read errors or checksumming errors at
> runtime and allow continued usage of the filesystem. In case of read
> failures or checksum failures, reading from the replica can allow liv=
e
> recovery of the lost metadata. This document gives some details about
> how the Ext4 metadata could be replicated and used by the filesystem.
>
> We can categorize the filesystem metadata into two main types:
>
> * Static metadata: Metadata that gets allocated at mkfs time and take=
s
> fixed amount of space on disk (which is known upfront). This includes
> block & inode allocation bitmaps and inode tables. (We don=92t count
> superblock and group descriptors here because they are already
> replicated on the filesystem). On a 1Tb drive using bigalloc with
> cluster size of 1Mb, this amounts to around 128Mb. Without bigalloc,
> static metadata for the same 1Tb drive is around 6Gb assuming
> =93bytes-per-inode=94 is 20Kb.
>
> * Dynamic metadata: Metadata that gets created and deleted as the
> filesystem is used. This includes directory blocks, extent tree
> blocks, etc. The size of this metadata varies depending on the
> filesystem usage.
> In order to reduce some complexity, we consider only directory blocks
> for replication in this category. This is because directory block
> failures affects access to more number of inodes and replicating
> extent tree blocks is likely to make replication expensive (both in
> terms of performance and space used).
>
> The new ext4 =91replica=92 feature introduces a new reserved inode,
> referred in rest of this document as the replica inode, for storing
> the replicated blocks for static and dynamic metadata. The replica
> inode is created at mke2fs time when =91replica=92 feature is set. Th=
e
> replica inode will contain:
> * replica superblock in the first block
> * replicated static metadata
> * index blocks for dynamic metadata (We will need a mapping from
> original-block-number to replica-block-number for dynamic metadata.
> The =91index blocks=92 will store this mapping. This is explained bel=
ow in
> more detail).
> * replicated dynamic metadata blocks
>
> The superblock structure is as follows:
>
> struct ext4_replica_sb {
> =A0 =A0 =A0 =A0__le32 =A0r_wtime; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* W=
rite time. */
> =A0 =A0 =A0 =A0__le32 =A0r_static_offset; =A0 =A0 =A0 =A0/* Logical b=
lock number of the first
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 * static block replica. */
> =A0 =A0 =A0 =A0__le32 =A0r_index_offset; /* Logical block number of t=
he first
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 * index block for dynamic metadata replica. */
> =A0 =A0 =A0 =A0__le16 =A0r_magic; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* M=
agic signature */
> =A0 =A0 =A0 =A0__u8 =A0 =A0 =A0 =A0 =A0 =A0r_log_groups_per_index; /*=
 Number of block-groups
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 * represented by each index block. */
> =A0 =A0 =A0 =A0__u8 r_reserved_pad; =A0 =A0 =A0 =A0 =A0 =A0/* Unused =
padding */
> };
>
> The replica could be stored on an external device or on the same
> device (makes sense in case of SSDs). The replica superblock will be
> read and initialized at mount time.
>
>
> Replicating Static Metadata:
>
> The replica superblock contains the position (=91r_static_offset=92)
> within the replica inode from where static metadata replica starts.
> The length of static metadata is fixed and known at mke2fs time.
> Mke2fs will place the replica of static metadata after replica
> superblock and set the r_static_offset value in superblock. This
> section in inode will contain all static metadata (block bitmap, inod=
e
> bitmap & inode table) for group 0, then all static metadata for group
> 1, and so on. Given a filesystem block number (ext4_fsblk_t), it is
> possible to efficiently compute the group number and the location of
> the replicated block in the replica inode. Not needing a separate
> index to map from original to replica is the main advantage of
> handling static metadata separately from the dynamic metadata.
> On metadata read failure, the filesystem can overwrite the original
> block with a copy from replica. The overwriting will cause the bad
> sector to be remapped and we don=92t need to mark the filesystem as
> having errors.
>
>
> Replicating Dynamic Metadata:
>
> Replicating dynamic metadata will be more complicated compared to
> static metadata. Since the locations of dynamic metadata on filesyste=
m
> is not fixed, we don=92t have an implicit mapping from original to
> replica for it. Thus we need additional =91index blocks=92 to store t=
his
> mapping. Moreover, the amount of dynamic metadata on a filesystem wil=
l
> vary depending on its usage and it cannot be determined at mke2fs
> time. Thus, the replica inode will have to be extended as new metadat=
a
> gets allocated on the filesystem.
>
> Here is what we would like to propose for dynamic metadata:
> * Let =93(1 << r_log_groups_per_index)=94 be the number of groups for
> which we will have one index block. This means that any replicated
> dynamic metadata block residing in these block-groups will have an
> entry in the same single index block. By default, we will keep
> r_log_groups_per_index same as s_log_groups_per_flex. Thus we will
> have one index block per flex block group.
> * Store these index blocks starting immediately after the static
> metadata replica blocks. 'r_index_offset' points to the first index
> block.
Hi Aditya,

Do you consider resize operation?   We need to reserve space in
replica inode for resize.  But when meta_bg is used, it seems that it
is hard to do so.

> * Each of these index blocks will have the following structure:
> =A0 =A0 =A0 =A0struct ext4_replica_index {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__le16 ri_magic;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__le16 ri_num_entries;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__le32 ri_reserved[3]; =A0// reserved =
for future use
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__le32 orig_fsblk_lo;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__le32 orig_fsblk_hi;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__le32 replica_lblk; =A0=
// ext4_lblk_t - logical offset into replica inode.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} ri_entries[];
> =A0 =A0 =A0 =A0}

I have a suggestion about reusing deleted block in replica inode.  We
store logical block number of deleted blocks in some blocks called
recycle blocks.   We can add a deleted_block in replica_sb, which is
first logical block number of recycle blocks.  Besides we need a
deleted_block_offset pointing to first unused entry in the recycle
blocks.

Recycle blocks resides in the ending blocks of replica inode.  If
current recycle blocks is used up, then last unused block of replica
inode is used, meaning that deleted_block--.

>
> Each of the 'ri_entries' is a map from the original block number to
> its replicated block in the replica inode:
> =A0 =A0 =A0 =A0[(orig_fsblk_hi << 32 | orig_fsblk_lo) : replica_lblk]
>
> There are 4 operations that accesses these dynamic metadata index blo=
cks:
> =A0 =A0 =A0 =A0* Lookup/Update replica for given block number
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- This is a binary search over 'ri_ent=
ries' (O(lg N))
> =A0 =A0 =A0 =A0* Remove replica for given block number
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Lookup (as above).
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Set the =91orig_fsblk_lo=92 & =91ori=
g_fsblk_hi=92 to 0 and leave the
> =91replica_lblk=92 value unchanged.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- memmove the 0=92ed entry at the top =
or ri_entries.
                  - write replica_lblk into recycle blocks, write
position could be get by deleted_block_offset and deleted_block, and
also increases deleted_block_offset.  If recycle blocks are full, we
need to allocate a new block for recycle blocks just before current
recycle blocks.

> =A0 =A0 =A0 =A0* Add replica for given block number
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- First check if there is a =91deleted=
=92 entry at the top with valid
                  operation above is not needed any more.
                  - decrease deleted_block_offset and use
corresponding entry.  If the 1st block of recycle blocks is empty, we
free it and set deleted_block_offset and deleted_block to right value.

Yongqiang.


> =91replica_lblk=92 value. If available, then set its =91orig_fsblk_lo=
=92 &
> =91orig_fsblk_hi=92. If not, allocate a new block at the end of the
> replica inode and create an entry for mapping this block.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- memmove to insert the new entry in a=
ppropriate location in =91ri_entries=92.
>
> The idea above is that we maintain the =91ri_entries=92 on sorted ord=
er so
> that the most frequent operation (index lookup) is efficient while
> keeping the initial implementation simple. The index blocks will be
> pinned in memory at mount time. We can explore other more efficient
> approaches (like a BST or other structures) for managing ri_entries i=
n
> future.
>
> If the index block is full and we need to add an entry, we can:
> * simply stop replicating unless some blocks are freed
> * start replacing entries from the beginning in the index.
> * add another index block (specifying its location in the
> =91ri_reserved=92) and add the entry
> =A0 in it after replication
> In the first version of replica implementation, we will simply stop
> replicating if there is no more space in the index block or if it is
> not possible to extend the inode. Given above =91struct
> ext4_replica_index=92 and a filesystem block size of 4Kb, we will be
> able to store 340 entries within each index block. This means that we
> can replicate up to 340 directory blocks per flex-bg.
> In case of metadata block being removed, we will have to remove its
> entry from the index. It will be inefficient to free random blocks
> from the replica inode, so we will keep the =91replica_blk=92 value a=
s it
> is in the index while zeroing out the orig_block_* values. (We can
> reuse this block for replicating some other metadata block in the
> future.) The effect of this is that the replica inode=92s size will
> increase with more metadata being created but it will never decrease
> if metadata is freed.
>
>
> Replica overhead considerations:
>
> Maintaining the replica requires us to pay some cost. Here are some
> concerns and possible mitigation strategies:
> 1) All metadata updates requires corresponding replica updates. Here
> we simply copy the original into buffer_head for replica and mark the
> buffer dirty without actually reading the block first. The actual
> writeout of replica buffer will happen alongwith background writeout.
> 2) Pinning the index blocks in memory is necessary for efficiency.
> Assuming flex-bg size of 16 and blocksize of 4Kb on a 1Tb drive, this
> overhead will be 2 index blocks (4Kb) for a 1Tb bigalloc system with
> cluster size of 1MB and 512 index blocks (2Mb) for regular ext4
> (assuming "inode-size" to be 128bytes and "bytes-per-inode" to be
> 20Kb).
> 3) Memory overhead beause of replica buffer_heads.
> 4) The replica inode won=92t shrink at runtime even if the original
> metadata is removed. Thus the disk space used by replica will be
> unrecoverable. We can possibly compact the replica at e2fsck time.
>
> I have a working prototype for the static metadata part (replicated o=
n
> the same device). The dynamic metadata part is still work in progress=
=2E
> I needed couple of additional kernel changes to make all the metadata
> IO go through a single function in ext4. This allows us to have a
> single place as an entry point for the replica code.
>
> Comments and feedback appreciated.
>
> Credits for ideas and suggestions:
> Nauman Rafique (nauman@google.com)
> Ted Ts'o (tytso@google.com)
>
> --
> Aditya
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
