From: "Amir G." <amir73il@users.sourceforge.net>
Subject: [RFC] Ext4 snapshots design challenges
Date: Mon, 25 Oct 2010 14:34:53 +0200
Message-ID: <AANLkTim=4-uyczhhLOA79gsj7oHh=7O8f7ZiLMj3q3sB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: next3-devel@lists.sourceforge.net, Theodore Tso <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57005 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab0JYMex (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 08:34:53 -0400
Received: by qyk12 with SMTP id 12so1460481qyk.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Oct 2010 05:34:53 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

In April this year , I introduces the Next3 snapshots feature on this list:
http://lwn.net/Articles/383934/

The main criticism I got was concerning the choice of forking from Ext3,
rather than developing for Ext4. To those critics I replied, that the Ext4
merge is on the roadmap, but it may take a while before we get there.

In the mean while, Ted has been very supportive and has already merged
the (minor) on-disk changes of the snapshot feature to mainline and libext2.

In these days, a group of 4 students is preparing to start the porting of
the Next3 snapshots feature to Ext4, with my assistance and following
some guide lines that were drawn by Ted.

I will be attending the Linux Plumbers Conference and will try to initiate a
discussion around some design issues regarding Ext4 snapshots:
http://www.linuxplumbersconf.org/2010/ocw/proposals/1191

If you are attending LPC, you are most welcome to join the discussion
(We, Nov 3, 17:30) and contribute to Ext4 snapshots design.

For those of you who didn't get the chance to catch up with Next3 snapshots
design, I have prepared this 'quick' overview:
http://sf.net/apps/mediawiki/next3/index.php?title=Technical_overview

A draft of design challenges and proposed solutions can be found here:
http://sf.net/apps/mediawiki/next3/index.php?title=Ext4_snapshots_TODO

Here inlined, for your convenience, is the first and biggest challenge of
the merge - the implementation of extent mapped file data block re-write.

Your comments will be appreciated,
Amir.


https://sourceforge.net/apps/mediawiki/next3/index.php?
title=Ext4_snapshots_TODO#Ext4_snapshots_design_challenges:

=                     Ext4 snapshots design challenges                     =

The following issues require special attention when merging the snapshots
feature to ext4.

Ext4 developers are encouraged to comment on these issues and suggest
solutions other than the ones proposed here.

== Extent mapped file data block re-write ==

The term re-write refers to a non first write to a file's data block.
The first write allocates a new block for that file and requires no special
snapshot block operations. If a snapshot was taken after a block was
allocated, that block is protected by the snapshot's COW bitmap. Any attempt
to re-write that block should result in a snapshot block operation, which
either copies the original data to the snapshot file or moves the original
block to the snapshot file and allocates a new block for the new data.

Current implementation moves data blocks of indirect mapped files to
snapshot on re-write. The move-on-write method is more efficient than the
copy-on-write method, but it may cause a file to get fragmented in a use
case of re-writes to many random locations.

For extent mapped files re-write, there are 2 possible solutions.
Ted T'so has wrote about this choice:

''Technically speaking, it's possible to do it both ways, yes?''
''I'm not sure why you consider this such an important design decision.''
''We can even play games where for some files we might do copy-on-write,''
''and for some files, we do move-on-write. It's always possible to check''
''the COW bitmaps to decide what had happened.''

=== Move-on-write ===

Besides the mentioned file fragmentation problem, every move-on-write
operation may need to split up a data extent into 2 extents of existing
blocks and a third extent for blocks allocated for the new data.
The metadata overhead of such a split operation is more significant than
that of an indirect mapped file move-on-write operation and these extra
metadata updates will have to be accounted for in advance when starting a
block re-write transaction. Extent spliting may also degrade re-write
performance to extent mapped files.

In general, delayed allocation, or delayed move-on-write for our purpose,
should be used to avoid extent splitting as much as possible.

Perhaps the file fragmentation problem can be solved by online
de-fragmentation. After all, the original file's blocks are kept safely
inside the snapshot file, so a background task can simply copy the snapshot
moved blocks to new locations and then copy the file's new data into its
original blocks and map them back into the file.

=== Copy-on-write ===

Copying the re-written block to snapshot may seem like the "easy way out"
of the file fragmentation problem, but the problems it causes in return
are not to be disregarded.

The first and obvious problem is write performance, because every data
block re-write involves reading the content of the existing block from
storage, before proceeding with the re-write. This read I/O can be avoided
when using the move-on-write method. Though the write performance seems
like a big limitation, it can be tagged as a trade-off between random write
performance and sequential read performance and the choice can be left at
the hands of the user.

The second issue with data blocks copy-on-write is the snapshot reserved
blocks count. On snapshot take, the file system reserves a certain amount of
blocks for snapshot use. The reservation is calculated from the estimated
count of metadata blocks that may need to be copied to snapshot at some
point in the future. Move-on-write uses much less snapshot reserved blocks
than copy-on-write, so the data blocks count doesn't need to be accounted
for. When choosing to do copy-on-write on data blocks re-write, the re-write
operation should first verify that there is enough disk space for allocating
the snapshot copied data blocks without using snapshot reserved blocks.
If there is not enough disk space, the operation should return ENOSPC.

The last and most challenging issue has to do with I/O ordering within a
single snapshot COW operation. The rule is very simple:
To keep the snapshot data safe, the snapshot copy has to secured in storage
before the new data is allowed to be written to storage.

With metadata copy-on-write, this ordering is provided as a by product from
the journaling sub-system. All snapshot COW'ed blocks are marked as ordered
data, which is always written to storage before transaction commit starts
and metadata blocks are always written to storage during transaction commit.

When COW'ing a data block, which may be "ordered" or "writeback", there is
no mechanism in place to help order the async writes of the snapshot COW'ed
blocks before the async writes of the re-written data blocks. Even worse,
when COW'ing an "ordered" data block, the journal will force it to storage
before transaction commit starts and the snapshot COW'ed block mapping into
the snapshot file will only be written during transaction commit.

One possible solution is to implement a "holdback" list of blocks that
should not be written before the current transaction commits. Naturally, a
block must not be on both the "ordered" and "holdback" lists, but when
re-writing an allocated data block, there is no sense in making this block
"ordered", because this kind of data modification is directly related to any
metadata modification (except change of inode's mtime, but who cares).

....
