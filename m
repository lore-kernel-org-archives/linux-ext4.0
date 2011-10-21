From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC] Metadata Replication for Ext4
Date: Fri, 21 Oct 2011 09:50:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110210934510.12314@dhcp-27-109.brq.redhat.com>
References: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com> <alpine.LFD.2.00.1110191553500.29698@dhcp-27-109.brq.redhat.com> <FF85E3C6-8AB3-4A63-9E3D-06D06C778CEC@dilger.ca>
 <CAGr1F2GWXd=pfb3JECDwwzd70AczBHb3_yimaRRxmRAe9du_CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-185245890-1319183450=:12314"
Cc: Andreas Dilger <adilger@dilger.ca>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Nauman Rafique <nauman@google.com>,
	TheodoreTso <tytso@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"Alasdair G.Kergon" <agk@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab1JUHvC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Oct 2011 03:51:02 -0400
In-Reply-To: <CAGr1F2GWXd=pfb3JECDwwzd70AczBHb3_yimaRRxmRAe9du_CQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-185245890-1319183450=:12314
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 20 Oct 2011, Aditya Kali wrote:

> On Wed, Oct 19, 2011 at 9:19 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> > On 2011-10-19, at 8:10 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> >> On Tue, 18 Oct 2011, Aditya Kali wrote:
> >>
> >>> This is a proposal for new ext4 feature that replicates ext4 metadata
> >>> and provides recovery in case where device blocks storing filesystem
> >>> metadata goes bad. When the filesystem encounters a bad block during
> >>> read, it returns EIO to the user. If this is a data block for some
> >>> inode then the user application can handle this error in many
> >>> different ways. But if we fail reading a filesystem metadata block
> >>> (bitmap block, inode table block, directory block, etc.), we could
> >>> potentially lose access to much larger amount of data and render the
> >>> filesystem unusable. It is difficult (and not expected) for the user
> >>> application to recover from such filesystem metadata loss. This
> >>> problem is observed to be much more severe on SSDs which tend to show
> >>> more frequent read errors when compared to disks over the same
> >>> duration.
> >>>
> >>> There are different ways in which block read errors in different
> >>> metadata could be handled. For example, if the filesystem is unable to
> >>> read a block/inode allocation bitmap then we could just assume that
> >>> all the blocks/inodes in that block group are allocated and let fsck
> >>> fix this later. For inode table and directory blocks, we could play
> >>> some (possibly unreliable) tricks with fsck. In either case, the
> >>> filesystem will be fully usable only after it’s fsck’d (which is a
> >>> disruptive process on production systems). Darrick Wong’s recent
> >>> patches for metadata checksumming will detect even more non-hardware
> >>> failure related problems, but they don’t offer any recovery mechanism
> >>> from the checksum failures.
> >>>
> >>> Metadata replication is another approach that can allow the filesystem
> >>> to recover from the device read errors or checksumming errors at
> >>> runtime and allow continued usage of the filesystem. In case of read
> >>> failures or checksum failures, reading from the replica can allow live
> >>> recovery of the lost metadata. This document gives some details about
> >>> how the Ext4 metadata could be replicated and used by the filesystem.
> >>
> >> Hi Aditya,
> >>
> >> While reading those three paragraphs I found the idea interesting,
> >> however it would be just great to have more generic solution for this
> >> problem. One, which comes immediately to mind, is mirroring, however
> >> this will, of course, mirror all data, not just metadata.
> >>
> >> But, we are already marking metadata-read bios (REQ_META), so it has
> >> better priority. What about doing the same thing on write side and
> >> having metadata-mirroring dm target which will mirror only those ?
> >
> > While I like the idea of metadata mirroring, I share Lukaz's concern about the added complexity to the code.
> >
> > I've already done a bunch of experimentation with formatting the filesystem with flex_bg and storing the metadata in the first block group of every 256 block groups, and then allocating these block groups on flash via DM, and the other 255 block groups in the flex_bg are on RAID-6.
> >
> > This locates all of the static metadata in 1 of 256 block groups, and ext4 will already prefer to allocate the dynamic metadata in the first group of a flex_bg.
> >
> > It wouldn't be very difficult to set up the metadata groups as RAID-1 mirrors.
> >
> >> This way we'll get generic solution for all file systems, the only thing
> >> that file system should do in order to take an advantage of this is to
> >> mark its metadata writes accordingly.
> >>
> >> However there is one glitch, which is that we currently do not have an
> >> fs - dm(or raid, or whatever) interface, which would allow file system
> >> to ask for mirrored data (or fixed by error correction codes) in case
> >> that the original data are corrupted. But that is something which has to
> >> be done anyway, so we just have one more reason to do this sooner
> >> that later.
> >
> > Right, there needs to be some way for the upper layer to know which copy was read, so that in case of a checksum failure it can request the other copy.  For RAID-5/6 it would need to know which disks were used for parity (if any) and then request parity reconstruction with a different disk until it matches the checksum.
> >
> 
> A generic block-replication mechanism would certainly be good to have.
> But I am not sure if doing it this way is easy or even the best way
> (wouldn't it break the abstraction if filesystem was to know about the
> raid layout underneath?). Even after adding support to raid layer to
> rebuild corrupted blocks at runtime (which probably won't be easy), we
> still need higher level setup (partitioning and dm setup) to make it
> work. This adds prohibitive management cost for using raid and device
> mapper setup on large number of machines in production.

It is not about breaking the abstraction. We need this interface to be
able to recover from disk failures without downtime in the case we are
protected by RAID. So as I said this is something people are actually
looking into already.

> 
> We mainly came up with this approach to add resiliency at filesystem
> level irrespective of what (unreliable) hardware lies beneath.
> Moreover, we are planing to use this approach on SSDs (where the
> problem is observed to be more severe) with the replica stored on the
> same device. Having this as a filesystem feature provides simplicity
> in management and avoids overhead of going through more layers of
> code. The replica code will hook into just one or two places in the
> ext4 and the overhead introduced by it will be predictable and
> measurable.

I almost got an impression that for your case would be better the full
device mirroring, since there is a lot more data then metadata, hence it
is more probable to hit data corruption, then metadata. And after all,
if you lose data, it is always bad. But I guess, that this is not what
you need.

However, back to the metadata replication. The management overhead of
this would be the same as having raid, so I do not thing this is that
bad. It is certainly worth avoiding complexity in the file system.
Moreover, talking about the overhead introduced by the dm level...again
this is no different than having any dm target (raid for example) and I
do not think it is so bad, also it would mirror metadata only, so all
the data writes will just go through unnoticed.

Lastly, there is a suggestion from Dave to have file system ability to
separate metadata into separate device and use mirroring on that device.
As Dave said, there is a lot more interesting stuff we can do with this
approach.

Thanks!

> 
> What do you think ?

I still think that there are more better solutions, generic solutions
with better flexibility, than doing it on file system level.

Thanks!
-Lukas

> 
> Thanks,
> 
> >> It might require a bit more investigation to see how doable is that, but
> >> I think it is very much possible. And it would NOT require yet another
> >> complexity and ext4 on-disk format compatibility problems.
> >>
> >> What do you think about that ? Do you think it is possible ? Will that
> >> be better alternative to ext4 specific solution ?
> >>
> >> Thanks!
> >> -Lukas
> >>
> >>
> >>>
> >>> We can categorize the filesystem metadata into two main types:
> >>>
> >>> * Static metadata: Metadata that gets allocated at mkfs time and takes
> >>> fixed amount of space on disk (which is known upfront). This includes
> >>> block & inode allocation bitmaps and inode tables. (We don’t count
> >>> superblock and group descriptors here because they are already
> >>> replicated on the filesystem). On a 1Tb drive using bigalloc with
> >>> cluster size of 1Mb, this amounts to around 128Mb. Without bigalloc,
> >>> static metadata for the same 1Tb drive is around 6Gb assuming
> >>> “bytes-per-inode” is 20Kb.
> >>>
> >>> * Dynamic metadata: Metadata that gets created and deleted as the
> >>> filesystem is used. This includes directory blocks, extent tree
> >>> blocks, etc. The size of this metadata varies depending on the
> >>> filesystem usage.
> >>> In order to reduce some complexity, we consider only directory blocks
> >>> for replication in this category. This is because directory block
> >>> failures affects access to more number of inodes and replicating
> >>> extent tree blocks is likely to make replication expensive (both in
> >>> terms of performance and space used).
> >>>
> >>> The new ext4 ‘replica’ feature introduces a new reserved inode,
> >>> referred in rest of this document as the replica inode, for storing
> >>> the replicated blocks for static and dynamic metadata. The replica
> >>> inode is created at mke2fs time when ‘replica’ feature is set. The
> >>> replica inode will contain:
> >>> * replica superblock in the first block
> >>> * replicated static metadata
> >>> * index blocks for dynamic metadata (We will need a mapping from
> >>> original-block-number to replica-block-number for dynamic metadata.
> >>> The ‘index blocks’ will store this mapping. This is explained below in
> >>> more detail).
> >>> * replicated dynamic metadata blocks
> >>>
> >>> The superblock structure is as follows:
> >>>
> >>> struct ext4_replica_sb {
> >>>    __le32    r_wtime;        /* Write time. */
> >>>    __le32    r_static_offset;    /* Logical block number of the first
> >>>                     * static block replica. */
> >>>    __le32    r_index_offset;    /* Logical block number of the first
> >>>                     * index block for dynamic metadata replica. */
> >>>    __le16    r_magic;        /* Magic signature */
> >>>    __u8        r_log_groups_per_index;    /* Number of block-groups
> >>>                     * represented by each index block. */
> >>>    __u8 r_reserved_pad;        /* Unused padding */
> >>> };
> >>>
> >>> The replica could be stored on an external device or on the same
> >>> device (makes sense in case of SSDs). The replica superblock will be
> >>> read and initialized at mount time.
> >>>
> >>>
> >>> Replicating Static Metadata:
> >>>
> >>> The replica superblock contains the position (‘r_static_offset’)
> >>> within the replica inode from where static metadata replica starts.
> >>> The length of static metadata is fixed and known at mke2fs time.
> >>> Mke2fs will place the replica of static metadata after replica
> >>> superblock and set the r_static_offset value in superblock. This
> >>> section in inode will contain all static metadata (block bitmap, inode
> >>> bitmap & inode table) for group 0, then all static metadata for group
> >>> 1, and so on. Given a filesystem block number (ext4_fsblk_t), it is
> >>> possible to efficiently compute the group number and the location of
> >>> the replicated block in the replica inode. Not needing a separate
> >>> index to map from original to replica is the main advantage of
> >>> handling static metadata separately from the dynamic metadata.
> >>> On metadata read failure, the filesystem can overwrite the original
> >>> block with a copy from replica. The overwriting will cause the bad
> >>> sector to be remapped and we don’t need to mark the filesystem as
> >>> having errors.
> >>>
> >>>
> >>> Replicating Dynamic Metadata:
> >>>
> >>> Replicating dynamic metadata will be more complicated compared to
> >>> static metadata. Since the locations of dynamic metadata on filesystem
> >>> is not fixed, we don’t have an implicit mapping from original to
> >>> replica for it. Thus we need additional ‘index blocks’ to store this
> >>> mapping. Moreover, the amount of dynamic metadata on a filesystem will
> >>> vary depending on its usage and it cannot be determined at mke2fs
> >>> time. Thus, the replica inode will have to be extended as new metadata
> >>> gets allocated on the filesystem.
> >>>
> >>> Here is what we would like to propose for dynamic metadata:
> >>> * Let “(1 << r_log_groups_per_index)” be the number of groups for
> >>> which we will have one index block. This means that any replicated
> >>> dynamic metadata block residing in these block-groups will have an
> >>> entry in the same single index block. By default, we will keep
> >>> r_log_groups_per_index same as s_log_groups_per_flex. Thus we will
> >>> have one index block per flex block group.
> >>> * Store these index blocks starting immediately after the static
> >>> metadata replica blocks. 'r_index_offset' points to the first index
> >>> block.
> >>> * Each of these index blocks will have the following structure:
> >>>    struct ext4_replica_index {
> >>>        __le16 ri_magic;
> >>>        __le16 ri_num_entries;
> >>>        __le32 ri_reserved[3];  // reserved for future use
> >>>        struct {
> >>>            __le32 orig_fsblk_lo;
> >>>            __le32 orig_fsblk_hi;
> >>>            __le32 replica_lblk;  // ext4_lblk_t - logical offset into replica inode.
> >>>        } ri_entries[];
> >>>    }
> >>>
> >>> Each of the 'ri_entries' is a map from the original block number to
> >>> its replicated block in the replica inode:
> >>>        [(orig_fsblk_hi << 32 | orig_fsblk_lo) : replica_lblk]
> >>>
> >>> There are 4 operations that accesses these dynamic metadata index blocks:
> >>>    * Lookup/Update replica for given block number
> >>>        - This is a binary search over 'ri_entries' (O(lg N))
> >>>    * Remove replica for given block number
> >>>        - Lookup (as above).
> >>>        - Set the ‘orig_fsblk_lo’ & ‘orig_fsblk_hi’ to 0 and leave the
> >>> ‘replica_lblk’ value unchanged.
> >>>        - memmove the 0’ed entry at the top or ri_entries.
> >>>    * Add replica for given block number
> >>>        - First check if there is a ‘deleted’ entry at the top with valid
> >>> ‘replica_lblk’ value. If available, then set its ‘orig_fsblk_lo’ &
> >>> ‘orig_fsblk_hi’. If not, allocate a new block at the end of the
> >>> replica inode and create an entry for mapping this block.
> >>>        - memmove to insert the new entry in appropriate location in ‘ri_entries’.
> >>>
> >>> The idea above is that we maintain the ‘ri_entries’ on sorted order so
> >>> that the most frequent operation (index lookup) is efficient while
> >>> keeping the initial implementation simple. The index blocks will be
> >>> pinned in memory at mount time. We can explore other more efficient
> >>> approaches (like a BST or other structures) for managing ri_entries in
> >>> future.
> >>>
> >>> If the index block is full and we need to add an entry, we can:
> >>> * simply stop replicating unless some blocks are freed
> >>> * start replacing entries from the beginning in the index.
> >>> * add another index block (specifying its location in the
> >>> ‘ri_reserved’) and add the entry
> >>>   in it after replication
> >>> In the first version of replica implementation, we will simply stop
> >>> replicating if there is no more space in the index block or if it is
> >>> not possible to extend the inode. Given above ‘struct
> >>> ext4_replica_index’ and a filesystem block size of 4Kb, we will be
> >>> able to store 340 entries within each index block. This means that we
> >>> can replicate up to 340 directory blocks per flex-bg.
> >>> In case of metadata block being removed, we will have to remove its
> >>> entry from the index. It will be inefficient to free random blocks
> >>> from the replica inode, so we will keep the ‘replica_blk’ value as it
> >>> is in the index while zeroing out the orig_block_* values. (We can
> >>> reuse this block for replicating some other metadata block in the
> >>> future.) The effect of this is that the replica inode’s size will
> >>> increase with more metadata being created but it will never decrease
> >>> if metadata is freed.
> >>>
> >>>
> >>> Replica overhead considerations:
> >>>
> >>> Maintaining the replica requires us to pay some cost. Here are some
> >>> concerns and possible mitigation strategies:
> >>> 1) All metadata updates requires corresponding replica updates. Here
> >>> we simply copy the original into buffer_head for replica and mark the
> >>> buffer dirty without actually reading the block first. The actual
> >>> writeout of replica buffer will happen alongwith background writeout.
> >>> 2) Pinning the index blocks in memory is necessary for efficiency.
> >>> Assuming flex-bg size of 16 and blocksize of 4Kb on a 1Tb drive, this
> >>> overhead will be 2 index blocks (4Kb) for a 1Tb bigalloc system with
> >>> cluster size of 1MB and 512 index blocks (2Mb) for regular ext4
> >>> (assuming "inode-size" to be 128bytes and "bytes-per-inode" to be
> >>> 20Kb).
> >>> 3) Memory overhead beause of replica buffer_heads.
> >>> 4) The replica inode won’t shrink at runtime even if the original
> >>> metadata is removed. Thus the disk space used by replica will be
> >>> unrecoverable. We can possibly compact the replica at e2fsck time.
> >>>
> >>> I have a working prototype for the static metadata part (replicated on
> >>> the same device). The dynamic metadata part is still work in progress.
> >>> I needed couple of additional kernel changes to make all the metadata
> >>> IO go through a single function in ext4. This allows us to have a
> >>> single place as an entry point for the replica code.
> >>>
> >>> Comments and feedback appreciated.
> >>>
> >>> Credits for ideas and suggestions:
> >>> Nauman Rafique (nauman@google.com)
> >>> Ted Ts'o (tytso@google.com)
> >>>
> >>> --
> >>> Aditya
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
> >> --
> >
> 
> 
> 
> 

-- 
--8323328-185245890-1319183450=:12314--
