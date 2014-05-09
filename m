From: mingming cao <mingming.cao@oracle.com>
Subject: proposed draft for ext4 reflink
Date: Fri, 09 May 2014 16:40:48 -0700
Message-ID: <536D6780.2050007@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42377 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaEIXix (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2014 19:38:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have been thinking about adding reflink support to ext4 filesystem.
=46ile reflink supports multiple files share the same data blocks. This=
 is=20
very useful to take snapshots and doing backups.  When reflink command=20
is called, a new file/inode is created, but the new file points to the=20
same data blocks from the original file.  When there is need to change=20
the new file data, copy on write is triggered. Currently there are othe=
r=20
filesystem like btrfs and OCFS has reflink support. And it seems=20
interesting to add this feature to ext4 as well.


Here is the first draft of ext reflink design text. I am sending out in=
=20
hope I could get more feedbacks and suggestions. Thanks!

Mingming


ext4 reflink overview
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

In current ext4 filesystem, one data block could only be used to one=20
inode at a time. After reflink, we break this rule, same data block=20
could be shared by multiple files.  The key issue here is how to avoid=20
freeing up blocks still used by other inode (reflinked files).  We need=
=20
to keep track of the usage of data blocks using counters.

Using the refcount to track block usage is pretty straightforward.  Whe=
n=20
reflink is called,  shared data block refcount are increased. Upon read=
,=20
there is no action needed, but if one inode start to write to the share=
d=20
data block, copy on write will happen first. The refcount of the=20
original data block will be decreased correspondingly and a new data=20
block is allocated to for the modified data. refcount will be decreased=
=20
whenever one of the inode free its data, and and only when the refcount=
=20
drop to zero could the filesystem safely claim this data block back.

The key question is where to store the refcount for each shared data=20
blocks. Current ext4 block bitmaps only used for if the block is free o=
r=20
not. We need to store the refcount somewhere else.

There are multiple options. I started to think about option 1) at the=20
beginning  then option 2) came out when data checksumming feature is=20
planned.  Option 2) sounds more straignt forward and I will list both s=
o=20
we could have some discussions about which would be better solution.

Option 1) Dynamic per-reflinked files refcount

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Based on reflink file groups, we could have a dynamically allocated=20
shared  refcount tree. This tree is hanging out from the inodes that=20
sharing the same set of blocks. The tree is indexed by physical block=20
numbers. The files sharing blocks will to use this tree as reference to=
=20
look up the reference counter to determine if the block is safe to free=
,=20
or need a copy-on-write.

COW (Copy On Write) and refcount tree
-------------------------------------

We would need an extent like structure to store the {physical block=20
number, len, refcount} refcount record  in refcount tree.

When reflink is called, a new inode is created, and the extent tree is=20
copied from the original inode to the new inode.  If the original inode=
=20
already have a refcount tree, then the refcount for the extent will be=20
increased.  If not, then refcount tree is created  and  the two inodes=20
all point to the same refcount tree.  Every extent will have a refcount=
=20
record and will be inserted into the refcount tree.  At that very=20
beginning time, the refcount record is 1:1 map to the extent structure.=
=20
This will change as inode starts to write. When inode wants to overwrit=
e=20
to a shared block,  copy on write happens --  new block be allocated=20
before the write and the original extent data are remain untouched.  Th=
e=20
original refcount record need to be updated accordingly after COW.   If=
=20
the inode only overwrite part of extent, the refcount record need to=20
split and decrease refcount for the portion of the change extent.  The=20
refcount for the portion that still shared by the inodes remain the sam=
e.

In worse case refcount tree becomes very fragmented if inode keep=20
rewriting after reflink. Imagining one inode rewrite every 4k after=20
being reflinked by other inode. At certain point, we may need to allow=20
larger chunk of COW, or even a whole file data copy would be triggered=20
if fragmentation getting worse.

The refcount tree could be a btree that easy to insert, search etc=20
operate. Since this tree is shared by reflinked files, we would need a=20
lock to guard access this tree operations.

Since this is important metadata, we would want to add checksums for=20
refcount index and leaf blocks where the refcount records are stored.


Link refcount tree to inodes
-----------------------------------

The root of refcount tree are pointed from inodes that are reflinked.=20
At the time of the reflink, the address of root refcount tree would be=20
linked from inodes. To store the location of the refcount tree,  one wa=
y=20
is to use extended attributes. Extended attributes have to be copied to=
=20
the new reflinked file first. The location of the reflink root block is=
=20
stored as two extended attributes (32 bits). We also could store the=20
address of refcount tree into inode size extra_isize.

Liu zheng's proposal of project quota also looks for space in ext4 inod=
e=20
to store project id. Expanding inode size extra_isize impact all files=20
so this is not optimal.

I haven=92t thought much about what we need to do in the e2fsprogs side=
,=20
but that would require teach fsck to understand refcount tree.





Option 2 ) Static filesystem-wide per-block refcount

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The most straightforward way is to create refcount record for every dat=
a=20
block in the filesystem.  Similar to data checksumming feature proposed=
=20
earlier, along with other blockgroup metadata, we could have a per-bloc=
k=20
metadata record, to store refcounts, back reference, data checksumming.=
=20
The per for the blocks in that blockgroup.

This works well if the data checksumming feature plans to go this=20
direction (adding per data block metadata), and we could just add two=20
bytes for block refcount. Getting the block refcount will only take O(1=
)=20
time if the per-data metadata are allocated statically,  and there is=20
basically very little impact to performance.

The downside  is the extra space cost for the blocks not shared.  Unlik=
e=20
data checksumming feature, refcount only matters to those blocks being=20
shared in the reflinked inodes. And secondly, it would not as efficient=
=20
as per-extent refcount as we would need to track per-block refcount=20
instead of larger extent granularity.



Overall, this is just a draft to show the thoughts about implement=20
reflink for ext4 filesystem. I am sure there are lots of other things=20
that I might missed or havent thought through. I am looking for many=20
suggestions, critics and discussion,  and hopefully this could be a goo=
d=20
start.

Mingming
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
