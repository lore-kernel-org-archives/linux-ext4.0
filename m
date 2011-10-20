From: Aditya Kali <adityakali@google.com>
Subject: Re: [RFC] Metadata Replication for Ext4
Date: Thu, 20 Oct 2011 16:28:55 -0700
Message-ID: <CAGr1F2F8D4GZTe2HP8Zy-_fX8N=AA=iu-GLJ49M8KFsDOiFrjw@mail.gmail.com>
References: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com>
 <CAGBYx2a4jMAfn6mCunzb+JnR_sNPNR1v7gSfPi6FTdaH+U50gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Nauman Rafique <nauman@google.com>,
	Theodore Tso <tytso@google.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:28171 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1JTX3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 19:29:18 -0400
Received: from hpaq13.eem.corp.google.com (hpaq13.eem.corp.google.com [172.25.149.13])
	by smtp-out.google.com with ESMTP id p9KNTGPR021918
	for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 16:29:16 -0700
Received: from pzk4 (pzk4.prod.google.com [10.243.19.132])
	by hpaq13.eem.corp.google.com with ESMTP id p9KNQDRk005258
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 16:29:15 -0700
Received: by pzk4 with SMTP id 4so10377653pzk.10
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 16:29:15 -0700 (PDT)
In-Reply-To: <CAGBYx2a4jMAfn6mCunzb+JnR_sNPNR1v7gSfPi6FTdaH+U50gQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Yongqiang,

On Wed, Oct 19, 2011 at 1:43 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> On Wed, Oct 19, 2011 at 9:12 AM, Aditya Kali <adityakali@google.com> =
wrote:
>> This is a proposal for new ext4 feature that replicates ext4 metadat=
a
>> and provides recovery in case where device blocks storing filesystem
>> metadata goes bad. When the filesystem encounters a bad block during
>> read, it returns EIO to the user. If this is a data block for some
>> inode then the user application can handle this error in many
>> different ways. But if we fail reading a filesystem metadata block
>> (bitmap block, inode table block, directory block, etc.), we could
>> potentially lose access to much larger amount of data and render the
>> filesystem unusable. It is difficult (and not expected) for the user
>> application to recover from such filesystem metadata loss. This
>> problem is observed to be much more severe on SSDs which tend to sho=
w
>> more frequent read errors when compared to disks over the same
>> duration.
>>
>> There are different ways in which block read errors in different
>> metadata could be handled. For example, if the filesystem is unable =
to
>> read a block/inode allocation bitmap then we could just assume that
>> all the blocks/inodes in that block group are allocated and let fsck
>> fix this later. For inode table and directory blocks, we could play
>> some (possibly unreliable) tricks with fsck. In either case, the
>> filesystem will be fully usable only after it=E2=80=99s fsck=E2=80=99=
d (which is a
>> disruptive process on production systems). Darrick Wong=E2=80=99s re=
cent
>> patches for metadata checksumming will detect even more non-hardware
>> failure related problems, but they don=E2=80=99t offer any recovery =
mechanism
>> from the checksum failures.
>>
>> Metadata replication is another approach that can allow the filesyst=
em
>> to recover from the device read errors or checksumming errors at
>> runtime and allow continued usage of the filesystem. In case of read
>> failures or checksum failures, reading from the replica can allow li=
ve
>> recovery of the lost metadata. This document gives some details abou=
t
>> how the Ext4 metadata could be replicated and used by the filesystem=
=2E
>>
>> We can categorize the filesystem metadata into two main types:
>>
>> * Static metadata: Metadata that gets allocated at mkfs time and tak=
es
>> fixed amount of space on disk (which is known upfront). This include=
s
>> block & inode allocation bitmaps and inode tables. (We don=E2=80=99t=
 count
>> superblock and group descriptors here because they are already
>> replicated on the filesystem). On a 1Tb drive using bigalloc with
>> cluster size of 1Mb, this amounts to around 128Mb. Without bigalloc,
>> static metadata for the same 1Tb drive is around 6Gb assuming
>> =E2=80=9Cbytes-per-inode=E2=80=9D is 20Kb.
>>
>> * Dynamic metadata: Metadata that gets created and deleted as the
>> filesystem is used. This includes directory blocks, extent tree
>> blocks, etc. The size of this metadata varies depending on the
>> filesystem usage.
>> In order to reduce some complexity, we consider only directory block=
s
>> for replication in this category. This is because directory block
>> failures affects access to more number of inodes and replicating
>> extent tree blocks is likely to make replication expensive (both in
>> terms of performance and space used).
>>
>> The new ext4 =E2=80=98replica=E2=80=99 feature introduces a new rese=
rved inode,
>> referred in rest of this document as the replica inode, for storing
>> the replicated blocks for static and dynamic metadata. The replica
>> inode is created at mke2fs time when =E2=80=98replica=E2=80=99 featu=
re is set. The
>> replica inode will contain:
>> * replica superblock in the first block
>> * replicated static metadata
>> * index blocks for dynamic metadata (We will need a mapping from
>> original-block-number to replica-block-number for dynamic metadata.
>> The =E2=80=98index blocks=E2=80=99 will store this mapping. This is =
explained below in
>> more detail).
>> * replicated dynamic metadata blocks
>>
>> The superblock structure is as follows:
>>
>> struct ext4_replica_sb {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 =C2=A0r_wtime; =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Write time. */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 =C2=A0r_static_offset; =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* Logical block number of the first
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
* static block replica. */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 =C2=A0r_index_offset; /* Logical b=
lock number of the first
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
* index block for dynamic metadata replica. */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 =C2=A0r_magic; =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Magic signature */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__u8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0r_log_groups_per_index; /* Number of block-groups
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
* represented by each index block. */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__u8 r_reserved_pad; =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0/* Unused padding */
>> };
>>
>> The replica could be stored on an external device or on the same
>> device (makes sense in case of SSDs). The replica superblock will be
>> read and initialized at mount time.
>>
>>
>> Replicating Static Metadata:
>>
>> The replica superblock contains the position (=E2=80=98r_static_offs=
et=E2=80=99)
>> within the replica inode from where static metadata replica starts.
>> The length of static metadata is fixed and known at mke2fs time.
>> Mke2fs will place the replica of static metadata after replica
>> superblock and set the r_static_offset value in superblock. This
>> section in inode will contain all static metadata (block bitmap, ino=
de
>> bitmap & inode table) for group 0, then all static metadata for grou=
p
>> 1, and so on. Given a filesystem block number (ext4_fsblk_t), it is
>> possible to efficiently compute the group number and the location of
>> the replicated block in the replica inode. Not needing a separate
>> index to map from original to replica is the main advantage of
>> handling static metadata separately from the dynamic metadata.
>> On metadata read failure, the filesystem can overwrite the original
>> block with a copy from replica. The overwriting will cause the bad
>> sector to be remapped and we don=E2=80=99t need to mark the filesyst=
em as
>> having errors.
>>
>>
>> Replicating Dynamic Metadata:
>>
>> Replicating dynamic metadata will be more complicated compared to
>> static metadata. Since the locations of dynamic metadata on filesyst=
em
>> is not fixed, we don=E2=80=99t have an implicit mapping from origina=
l to
>> replica for it. Thus we need additional =E2=80=98index blocks=E2=80=99=
 to store this
>> mapping. Moreover, the amount of dynamic metadata on a filesystem wi=
ll
>> vary depending on its usage and it cannot be determined at mke2fs
>> time. Thus, the replica inode will have to be extended as new metada=
ta
>> gets allocated on the filesystem.
>>
>> Here is what we would like to propose for dynamic metadata:
>> * Let =E2=80=9C(1 << r_log_groups_per_index)=E2=80=9D be the number =
of groups for
>> which we will have one index block. This means that any replicated
>> dynamic metadata block residing in these block-groups will have an
>> entry in the same single index block. By default, we will keep
>> r_log_groups_per_index same as s_log_groups_per_flex. Thus we will
>> have one index block per flex block group.
>> * Store these index blocks starting immediately after the static
>> metadata replica blocks. 'r_index_offset' points to the first index
>> block.
> Hi Aditya,
>
> Do you consider resize operation? =C2=A0 We need to reserve space in
> replica inode for resize. =C2=A0But when meta_bg is used, it seems th=
at it
> is hard to do so.
>

I haven't thought about this in detail, but it should be possible to
fix the replica inode after a resize my moving the index blocks.

>> * Each of these index blocks will have the following structure:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_replica_index {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 ri_mag=
ic;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 ri_num=
_entries;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 ri_res=
erved[3]; =C2=A0// reserved for future use
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__le32 orig_fsblk_lo;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__le32 orig_fsblk_hi;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__le32 replica_lblk; =C2=A0// ext4_lblk_t - logical offse=
t into replica inode.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} ri_entries[=
];
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> I have a suggestion about reusing deleted block in replica inode. =C2=
=A0We
> store logical block number of deleted blocks in some blocks called
> recycle blocks. =C2=A0 We can add a deleted_block in replica_sb, whic=
h is
> first logical block number of recycle blocks. =C2=A0Besides we need a
> deleted_block_offset pointing to first unused entry in the recycle
> blocks.
>
> Recycle blocks resides in the ending blocks of replica inode. =C2=A0I=
f
> current recycle blocks is used up, then last unused block of replica
> inode is used, meaning that deleted_block--.
>

It seems you want to store all the deleted blocks' in a central
location (in recycled blocks). I am sorry, but I am not sure I
understand the advantage of this approach.

>>
>> Each of the 'ri_entries' is a map from the original block number to
>> its replicated block in the replica inode:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0[(orig_fsblk_hi << 32 | orig_fsblk_lo) : =
replica_lblk]
>>
>> There are 4 operations that accesses these dynamic metadata index bl=
ocks:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0* Lookup/Update replica for given block n=
umber
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- This is a b=
inary search over 'ri_entries' (O(lg N))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0* Remove replica for given block number
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- Lookup (as =
above).
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- Set the =E2=
=80=98orig_fsblk_lo=E2=80=99 & =E2=80=98orig_fsblk_hi=E2=80=99 to 0 and=
 leave the
>> =E2=80=98replica_lblk=E2=80=99 value unchanged.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- memmove the=
 0=E2=80=99ed entry at the top or ri_entries.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- write=
 replica_lblk into recycle blocks, write
> position could be get by deleted_block_offset and deleted_block, and
> also increases deleted_block_offset. =C2=A0If recycle blocks are full=
, we
> need to allocate a new block for recycle blocks just before current
> recycle blocks.
>
How do we allocate new recycle blocks 'before' current recycle blocks?
Does this involve shifting the data in recycle blocks ?

>> =C2=A0 =C2=A0 =C2=A0 =C2=A0* Add replica for given block number
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- First check=
 if there is a =E2=80=98deleted=E2=80=99 entry at the top with valid
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0operati=
on above is not needed any more.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- decre=
ase deleted_block_offset and use
> corresponding entry. =C2=A0If the 1st block of recycle blocks is empt=
y, we
> free it and set deleted_block_offset and deleted_block to right value=
=2E
>
=46reeing blocks in between the replica inode is not really useful as i=
t
would simply create fragmentation of the inode.

At any time, we are going to have at the most 340 values in
'ri_entries'. Some of the entries could be unused, but I don't see the
advantage of moving these unused entries to separate 'recycled
blocks'.
If the 'memmove' operations mentioned above are a concern, then we can
avoid them by using a better data structure (say a BST or min-heap) to
avoid it. The description in this document is only for a
proof-of-concept.

Please let me know if I have misunderstood your suggestion.

Thanks,

> Yongqiang.
>
>
>> =E2=80=98replica_lblk=E2=80=99 value. If available, then set its =E2=
=80=98orig_fsblk_lo=E2=80=99 &
>> =E2=80=98orig_fsblk_hi=E2=80=99. If not, allocate a new block at the=
 end of the
>> replica inode and create an entry for mapping this block.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- memmove to =
insert the new entry in appropriate location in =E2=80=98ri_entries=E2=80=
=99.
>>
>> The idea above is that we maintain the =E2=80=98ri_entries=E2=80=99 =
on sorted order so
>> that the most frequent operation (index lookup) is efficient while
>> keeping the initial implementation simple. The index blocks will be
>> pinned in memory at mount time. We can explore other more efficient
>> approaches (like a BST or other structures) for managing ri_entries =
in
>> future.
>>
>> If the index block is full and we need to add an entry, we can:
>> * simply stop replicating unless some blocks are freed
>> * start replacing entries from the beginning in the index.
>> * add another index block (specifying its location in the
>> =E2=80=98ri_reserved=E2=80=99) and add the entry
>> =C2=A0 in it after replication
>> In the first version of replica implementation, we will simply stop
>> replicating if there is no more space in the index block or if it is
>> not possible to extend the inode. Given above =E2=80=98struct
>> ext4_replica_index=E2=80=99 and a filesystem block size of 4Kb, we w=
ill be
>> able to store 340 entries within each index block. This means that w=
e
>> can replicate up to 340 directory blocks per flex-bg.
>> In case of metadata block being removed, we will have to remove its
>> entry from the index. It will be inefficient to free random blocks
>> from the replica inode, so we will keep the =E2=80=98replica_blk=E2=80=
=99 value as it
>> is in the index while zeroing out the orig_block_* values. (We can
>> reuse this block for replicating some other metadata block in the
>> future.) The effect of this is that the replica inode=E2=80=99s size=
 will
>> increase with more metadata being created but it will never decrease
>> if metadata is freed.
>>
>>
>> Replica overhead considerations:
>>
>> Maintaining the replica requires us to pay some cost. Here are some
>> concerns and possible mitigation strategies:
>> 1) All metadata updates requires corresponding replica updates. Here
>> we simply copy the original into buffer_head for replica and mark th=
e
>> buffer dirty without actually reading the block first. The actual
>> writeout of replica buffer will happen alongwith background writeout=
=2E
>> 2) Pinning the index blocks in memory is necessary for efficiency.
>> Assuming flex-bg size of 16 and blocksize of 4Kb on a 1Tb drive, thi=
s
>> overhead will be 2 index blocks (4Kb) for a 1Tb bigalloc system with
>> cluster size of 1MB and 512 index blocks (2Mb) for regular ext4
>> (assuming "inode-size" to be 128bytes and "bytes-per-inode" to be
>> 20Kb).
>> 3) Memory overhead beause of replica buffer_heads.
>> 4) The replica inode won=E2=80=99t shrink at runtime even if the ori=
ginal
>> metadata is removed. Thus the disk space used by replica will be
>> unrecoverable. We can possibly compact the replica at e2fsck time.
>>
>> I have a working prototype for the static metadata part (replicated =
on
>> the same device). The dynamic metadata part is still work in progres=
s.
>> I needed couple of additional kernel changes to make all the metadat=
a
>> IO go through a single function in ext4. This allows us to have a
>> single place as an entry point for the replica code.
>>
>> Comments and feedback appreciated.
>>
>> Credits for ideas and suggestions:
>> Nauman Rafique (nauman@google.com)
>> Ted Ts'o (tytso@google.com)
>>
>> --
>> Aditya
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang
>



--=20
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
