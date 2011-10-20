From: Aditya Kali <adityakali@google.com>
Subject: Re: [RFC] Metadata Replication for Ext4
Date: Thu, 20 Oct 2011 15:45:52 -0700
Message-ID: <CAGr1F2GWXd=pfb3JECDwwzd70AczBHb3_yimaRRxmRAe9du_CQ@mail.gmail.com>
References: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com>
 <alpine.LFD.2.00.1110191553500.29698@dhcp-27-109.brq.redhat.com> <FF85E3C6-8AB3-4A63-9E3D-06D06C778CEC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Nauman Rafique <nauman@google.com>,
	TheodoreTso <tytso@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"Alasdair G.Kergon" <agk@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:8560 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1JTWqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 18:46:16 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id p9KMkDnn007047
	for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 15:46:14 -0700
Received: from pzk2 (pzk2.prod.google.com [10.243.19.130])
	by wpaz1.hot.corp.google.com with ESMTP id p9KMX5Om019330
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 15:46:12 -0700
Received: by pzk2 with SMTP id 2so10025225pzk.0
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 15:46:12 -0700 (PDT)
In-Reply-To: <FF85E3C6-8AB3-4A63-9E3D-06D06C778CEC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2011 at 9:19 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-10-19, at 8:10 AM, Lukas Czerner <lczerner@redhat.com> wrote:
>> On Tue, 18 Oct 2011, Aditya Kali wrote:
>>
>>> This is a proposal for new ext4 feature that replicates ext4 metada=
ta
>>> and provides recovery in case where device blocks storing filesyste=
m
>>> metadata goes bad. When the filesystem encounters a bad block durin=
g
>>> read, it returns EIO to the user. If this is a data block for some
>>> inode then the user application can handle this error in many
>>> different ways. But if we fail reading a filesystem metadata block
>>> (bitmap block, inode table block, directory block, etc.), we could
>>> potentially lose access to much larger amount of data and render th=
e
>>> filesystem unusable. It is difficult (and not expected) for the use=
r
>>> application to recover from such filesystem metadata loss. This
>>> problem is observed to be much more severe on SSDs which tend to sh=
ow
>>> more frequent read errors when compared to disks over the same
>>> duration.
>>>
>>> There are different ways in which block read errors in different
>>> metadata could be handled. For example, if the filesystem is unable=
 to
>>> read a block/inode allocation bitmap then we could just assume that
>>> all the blocks/inodes in that block group are allocated and let fsc=
k
>>> fix this later. For inode table and directory blocks, we could play
>>> some (possibly unreliable) tricks with fsck. In either case, the
>>> filesystem will be fully usable only after it=E2=80=99s fsck=E2=80=99=
d (which is a
>>> disruptive process on production systems). Darrick Wong=E2=80=99s r=
ecent
>>> patches for metadata checksumming will detect even more non-hardwar=
e
>>> failure related problems, but they don=E2=80=99t offer any recovery=
 mechanism
>>> from the checksum failures.
>>>
>>> Metadata replication is another approach that can allow the filesys=
tem
>>> to recover from the device read errors or checksumming errors at
>>> runtime and allow continued usage of the filesystem. In case of rea=
d
>>> failures or checksum failures, reading from the replica can allow l=
ive
>>> recovery of the lost metadata. This document gives some details abo=
ut
>>> how the Ext4 metadata could be replicated and used by the filesyste=
m.
>>
>> Hi Aditya,
>>
>> While reading those three paragraphs I found the idea interesting,
>> however it would be just great to have more generic solution for thi=
s
>> problem. One, which comes immediately to mind, is mirroring, however
>> this will, of course, mirror all data, not just metadata.
>>
>> But, we are already marking metadata-read bios (REQ_META), so it has
>> better priority. What about doing the same thing on write side and
>> having metadata-mirroring dm target which will mirror only those ?
>
> While I like the idea of metadata mirroring, I share Lukaz's concern =
about the added complexity to the code.
>
> I've already done a bunch of experimentation with formatting the file=
system with flex_bg and storing the metadata in the first block group o=
f every 256 block groups, and then allocating these block groups on fla=
sh via DM, and the other 255 block groups in the flex_bg are on RAID-6.
>
> This locates all of the static metadata in 1 of 256 block groups, and=
 ext4 will already prefer to allocate the dynamic metadata in the first=
 group of a flex_bg.
>
> It wouldn't be very difficult to set up the metadata groups as RAID-1=
 mirrors.
>
>> This way we'll get generic solution for all file systems, the only t=
hing
>> that file system should do in order to take an advantage of this is =
to
>> mark its metadata writes accordingly.
>>
>> However there is one glitch, which is that we currently do not have =
an
>> fs - dm(or raid, or whatever) interface, which would allow file syst=
em
>> to ask for mirrored data (or fixed by error correction codes) in cas=
e
>> that the original data are corrupted. But that is something which ha=
s to
>> be done anyway, so we just have one more reason to do this sooner
>> that later.
>
> Right, there needs to be some way for the upper layer to know which c=
opy was read, so that in case of a checksum failure it can request the =
other copy. =C2=A0For RAID-5/6 it would need to know which disks were u=
sed for parity (if any) and then request parity reconstruction with a d=
ifferent disk until it matches the checksum.
>

A generic block-replication mechanism would certainly be good to have.
But I am not sure if doing it this way is easy or even the best way
(wouldn't it break the abstraction if filesystem was to know about the
raid layout underneath?). Even after adding support to raid layer to
rebuild corrupted blocks at runtime (which probably won't be easy), we
still need higher level setup (partitioning and dm setup) to make it
work. This adds prohibitive management cost for using raid and device
mapper setup on large number of machines in production.

We mainly came up with this approach to add resiliency at filesystem
level irrespective of what (unreliable) hardware lies beneath.
Moreover, we are planing to use this approach on SSDs (where the
problem is observed to be more severe) with the replica stored on the
same device. Having this as a filesystem feature provides simplicity
in management and avoids overhead of going through more layers of
code. The replica code will hook into just one or two places in the
ext4 and the overhead introduced by it will be predictable and
measurable.

What do you think ?

Thanks,

>> It might require a bit more investigation to see how doable is that,=
 but
>> I think it is very much possible. And it would NOT require yet anoth=
er
>> complexity and ext4 on-disk format compatibility problems.
>>
>> What do you think about that ? Do you think it is possible ? Will th=
at
>> be better alternative to ext4 specific solution ?
>>
>> Thanks!
>> -Lukas
>>
>>
>>>
>>> We can categorize the filesystem metadata into two main types:
>>>
>>> * Static metadata: Metadata that gets allocated at mkfs time and ta=
kes
>>> fixed amount of space on disk (which is known upfront). This includ=
es
>>> block & inode allocation bitmaps and inode tables. (We don=E2=80=99=
t count
>>> superblock and group descriptors here because they are already
>>> replicated on the filesystem). On a 1Tb drive using bigalloc with
>>> cluster size of 1Mb, this amounts to around 128Mb. Without bigalloc=
,
>>> static metadata for the same 1Tb drive is around 6Gb assuming
>>> =E2=80=9Cbytes-per-inode=E2=80=9D is 20Kb.
>>>
>>> * Dynamic metadata: Metadata that gets created and deleted as the
>>> filesystem is used. This includes directory blocks, extent tree
>>> blocks, etc. The size of this metadata varies depending on the
>>> filesystem usage.
>>> In order to reduce some complexity, we consider only directory bloc=
ks
>>> for replication in this category. This is because directory block
>>> failures affects access to more number of inodes and replicating
>>> extent tree blocks is likely to make replication expensive (both in
>>> terms of performance and space used).
>>>
>>> The new ext4 =E2=80=98replica=E2=80=99 feature introduces a new res=
erved inode,
>>> referred in rest of this document as the replica inode, for storing
>>> the replicated blocks for static and dynamic metadata. The replica
>>> inode is created at mke2fs time when =E2=80=98replica=E2=80=99 feat=
ure is set. The
>>> replica inode will contain:
>>> * replica superblock in the first block
>>> * replicated static metadata
>>> * index blocks for dynamic metadata (We will need a mapping from
>>> original-block-number to replica-block-number for dynamic metadata.
>>> The =E2=80=98index blocks=E2=80=99 will store this mapping. This is=
 explained below in
>>> more detail).
>>> * replicated dynamic metadata blocks
>>>
>>> The superblock structure is as follows:
>>>
>>> struct ext4_replica_sb {
>>> =C2=A0 =C2=A0__le32 =C2=A0 =C2=A0r_wtime; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
/* Write time. */
>>> =C2=A0 =C2=A0__le32 =C2=A0 =C2=A0r_static_offset; =C2=A0 =C2=A0/* L=
ogical block number of the first
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 * static block replica. */
>>> =C2=A0 =C2=A0__le32 =C2=A0 =C2=A0r_index_offset; =C2=A0 =C2=A0/* Lo=
gical block number of the first
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 * index block for dynamic metadata replica. */
>>> =C2=A0 =C2=A0__le16 =C2=A0 =C2=A0r_magic; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
/* Magic signature */
>>> =C2=A0 =C2=A0__u8 =C2=A0 =C2=A0 =C2=A0 =C2=A0r_log_groups_per_index=
; =C2=A0 =C2=A0/* Number of block-groups
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 * represented by each index block. */
>>> =C2=A0 =C2=A0__u8 r_reserved_pad; =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Unu=
sed padding */
>>> };
>>>
>>> The replica could be stored on an external device or on the same
>>> device (makes sense in case of SSDs). The replica superblock will b=
e
>>> read and initialized at mount time.
>>>
>>>
>>> Replicating Static Metadata:
>>>
>>> The replica superblock contains the position (=E2=80=98r_static_off=
set=E2=80=99)
>>> within the replica inode from where static metadata replica starts.
>>> The length of static metadata is fixed and known at mke2fs time.
>>> Mke2fs will place the replica of static metadata after replica
>>> superblock and set the r_static_offset value in superblock. This
>>> section in inode will contain all static metadata (block bitmap, in=
ode
>>> bitmap & inode table) for group 0, then all static metadata for gro=
up
>>> 1, and so on. Given a filesystem block number (ext4_fsblk_t), it is
>>> possible to efficiently compute the group number and the location o=
f
>>> the replicated block in the replica inode. Not needing a separate
>>> index to map from original to replica is the main advantage of
>>> handling static metadata separately from the dynamic metadata.
>>> On metadata read failure, the filesystem can overwrite the original
>>> block with a copy from replica. The overwriting will cause the bad
>>> sector to be remapped and we don=E2=80=99t need to mark the filesys=
tem as
>>> having errors.
>>>
>>>
>>> Replicating Dynamic Metadata:
>>>
>>> Replicating dynamic metadata will be more complicated compared to
>>> static metadata. Since the locations of dynamic metadata on filesys=
tem
>>> is not fixed, we don=E2=80=99t have an implicit mapping from origin=
al to
>>> replica for it. Thus we need additional =E2=80=98index blocks=E2=80=
=99 to store this
>>> mapping. Moreover, the amount of dynamic metadata on a filesystem w=
ill
>>> vary depending on its usage and it cannot be determined at mke2fs
>>> time. Thus, the replica inode will have to be extended as new metad=
ata
>>> gets allocated on the filesystem.
>>>
>>> Here is what we would like to propose for dynamic metadata:
>>> * Let =E2=80=9C(1 << r_log_groups_per_index)=E2=80=9D be the number=
 of groups for
>>> which we will have one index block. This means that any replicated
>>> dynamic metadata block residing in these block-groups will have an
>>> entry in the same single index block. By default, we will keep
>>> r_log_groups_per_index same as s_log_groups_per_flex. Thus we will
>>> have one index block per flex block group.
>>> * Store these index blocks starting immediately after the static
>>> metadata replica blocks. 'r_index_offset' points to the first index
>>> block.
>>> * Each of these index blocks will have the following structure:
>>> =C2=A0 =C2=A0struct ext4_replica_index {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 ri_magic;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 ri_num_entries;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 ri_reserved[3]; =C2=A0// reserved=
 for future use
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 orig_fsblk_lo;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 orig_fsblk_hi;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 replica_lblk; =C2=A0=
// ext4_lblk_t - logical offset into replica inode.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0} ri_entries[];
>>> =C2=A0 =C2=A0}
>>>
>>> Each of the 'ri_entries' is a map from the original block number to
>>> its replicated block in the replica inode:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0[(orig_fsblk_hi << 32 | orig_fsblk_lo) :=
 replica_lblk]
>>>
>>> There are 4 operations that accesses these dynamic metadata index b=
locks:
>>> =C2=A0 =C2=A0* Lookup/Update replica for given block number
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0- This is a binary search over 'ri_entri=
es' (O(lg N))
>>> =C2=A0 =C2=A0* Remove replica for given block number
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0- Lookup (as above).
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0- Set the =E2=80=98orig_fsblk_lo=E2=80=99=
 & =E2=80=98orig_fsblk_hi=E2=80=99 to 0 and leave the
>>> =E2=80=98replica_lblk=E2=80=99 value unchanged.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0- memmove the 0=E2=80=99ed entry at the =
top or ri_entries.
>>> =C2=A0 =C2=A0* Add replica for given block number
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0- First check if there is a =E2=80=98del=
eted=E2=80=99 entry at the top with valid
>>> =E2=80=98replica_lblk=E2=80=99 value. If available, then set its =E2=
=80=98orig_fsblk_lo=E2=80=99 &
>>> =E2=80=98orig_fsblk_hi=E2=80=99. If not, allocate a new block at th=
e end of the
>>> replica inode and create an entry for mapping this block.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0- memmove to insert the new entry in app=
ropriate location in =E2=80=98ri_entries=E2=80=99.
>>>
>>> The idea above is that we maintain the =E2=80=98ri_entries=E2=80=99=
 on sorted order so
>>> that the most frequent operation (index lookup) is efficient while
>>> keeping the initial implementation simple. The index blocks will be
>>> pinned in memory at mount time. We can explore other more efficient
>>> approaches (like a BST or other structures) for managing ri_entries=
 in
>>> future.
>>>
>>> If the index block is full and we need to add an entry, we can:
>>> * simply stop replicating unless some blocks are freed
>>> * start replacing entries from the beginning in the index.
>>> * add another index block (specifying its location in the
>>> =E2=80=98ri_reserved=E2=80=99) and add the entry
>>> =C2=A0 in it after replication
>>> In the first version of replica implementation, we will simply stop
>>> replicating if there is no more space in the index block or if it i=
s
>>> not possible to extend the inode. Given above =E2=80=98struct
>>> ext4_replica_index=E2=80=99 and a filesystem block size of 4Kb, we =
will be
>>> able to store 340 entries within each index block. This means that =
we
>>> can replicate up to 340 directory blocks per flex-bg.
>>> In case of metadata block being removed, we will have to remove its
>>> entry from the index. It will be inefficient to free random blocks
>>> from the replica inode, so we will keep the =E2=80=98replica_blk=E2=
=80=99 value as it
>>> is in the index while zeroing out the orig_block_* values. (We can
>>> reuse this block for replicating some other metadata block in the
>>> future.) The effect of this is that the replica inode=E2=80=99s siz=
e will
>>> increase with more metadata being created but it will never decreas=
e
>>> if metadata is freed.
>>>
>>>
>>> Replica overhead considerations:
>>>
>>> Maintaining the replica requires us to pay some cost. Here are some
>>> concerns and possible mitigation strategies:
>>> 1) All metadata updates requires corresponding replica updates. Her=
e
>>> we simply copy the original into buffer_head for replica and mark t=
he
>>> buffer dirty without actually reading the block first. The actual
>>> writeout of replica buffer will happen alongwith background writeou=
t.
>>> 2) Pinning the index blocks in memory is necessary for efficiency.
>>> Assuming flex-bg size of 16 and blocksize of 4Kb on a 1Tb drive, th=
is
>>> overhead will be 2 index blocks (4Kb) for a 1Tb bigalloc system wit=
h
>>> cluster size of 1MB and 512 index blocks (2Mb) for regular ext4
>>> (assuming "inode-size" to be 128bytes and "bytes-per-inode" to be
>>> 20Kb).
>>> 3) Memory overhead beause of replica buffer_heads.
>>> 4) The replica inode won=E2=80=99t shrink at runtime even if the or=
iginal
>>> metadata is removed. Thus the disk space used by replica will be
>>> unrecoverable. We can possibly compact the replica at e2fsck time.
>>>
>>> I have a working prototype for the static metadata part (replicated=
 on
>>> the same device). The dynamic metadata part is still work in progre=
ss.
>>> I needed couple of additional kernel changes to make all the metada=
ta
>>> IO go through a single function in ext4. This allows us to have a
>>> single place as an entry point for the replica code.
>>>
>>> Comments and feedback appreciated.
>>>
>>> Credits for ideas and suggestions:
>>> Nauman Rafique (nauman@google.com)
>>> Ted Ts'o (tytso@google.com)
>>>
>>> --
>>> Aditya
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>> --
>



--=20
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
