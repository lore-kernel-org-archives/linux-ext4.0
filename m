From: Theodore Ts'o <tytso@mit.edu>
Subject: A proposal for making ext4's journal more SMR (and flash) friendly
Date: Wed, 08 Jan 2014 00:31:05 -0500
Message-ID: <nsxfvozavl2.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46756 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaAHFbH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jan 2014 00:31:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is something I've discussed on our weekly conference calls, but I
think it's time that try to get it written down.

                     SMR-Friendly Journal for Ext4
                              Version 0.10
                            January 8, 2014

Goal
====

The goal is to make the write patterns used by the ext4 journal and its
metadata more friendly for hard drives using Shingled Magnetic Recording
(SMR) by significantly reducing random writes seen by the SMR drive.  It
is primarily targetting drives which are providing either Drive-Managed
or Cooperatively Managed SMR.

By removing the need for random writes, this proposal can also improve
the performance of ext4 on more flash storage devices that have a more
simplistic Flash Translation Layer (FTL), such as those found on SD and
eMMC devices.

Non-Goals
---------

This proposal does not address how data blocks are allocated.

Nor does it address files which are modified they are first created
(i.e., a random read/write workload); we assume here that for many use
cases, the use of files which are modified after they are first created
using a random write pattern is rarer than the use case where files
which are written once and then not modified until they are replaced or
deleted.

Background
==========

Singled Magnetic Recording
--------------------------

Drives using SMR technology (sometimes called shingled drives) are
broken up into zones or bands, which will typically be 32-256 MB in
size[1].  Each band has a write pointer, and it is possible to write to
each band by appending to it, but once written, it can not be rewritten,
except by resetting the write pointer to the beginning at the band and
erasing the contents of the entire band.

[1] Storage systems for Shingled Disks, Garth Gibson, SDC 2012
presentation.

For more details about why drive vendors are moving to SMR, and details
regarding the different access models that have proposed for SMR drives,
please see [2].

[2] Shingled Magentic Recording: Areal Density Increase Requires New
Data Management, by Tim Feldman and Garth Bigson, ; login:, June 2013.
Vol 38, No. 3., pg 22.

The Ext4 Journal
----------------

The ext4 file system uses a physical block journal.  This means when a
metadata block is modified, the entire metadata block is written to the
journal before the transaction is committed.  Before the transaction is
commmited, the block may not be written to the final location on disk.
Once the commit block is written, then dirty metadata blocks may get
written back to disk by Linux's buffer cache, which manages the
writeback of dirty buffers.

The journal is treated sa a circular buffer, with modified metadata
blocks and commit blocks appeneded to the end of the circular buffer.
When the all of the blocks associated with the commit at the end of the
journal have been written back to disk, the commit can be retired, and
the journal superblock can be updated to move pointer to the head of the
journal to first commit that still has dirty buffers associated with it
which are pending writeback.  (The process of retiring the oldest
commits is called "checkpointing" in the ext4 journal implementation.)

To recover from a system crash, the kernel or the file system
consistency check program starts from the beginning of the journal,
writing blocks found in the journal to their appropriate location on
disk.

For more information about the ext4 journal, please see [3].

[3]  "Journaling the Linux ext2fs Filesystem," by Stephen Tweedie, in
the Proceeding of Linux Expo '98.

Design
======

The key insight in making the ext4's metadata updates more friendly is
that the writes to the journal are ideal from the perspective of writes
to a shingled disk --- or for a flash device with a simplistic FTL, such
as those found on many eMMC devices found in mobile handsets.  It is
after the journal commit, when the updates to the allocation bitmaps,
the inode table, directory blocks, which are random writes that are less
optimal from the perspective of a Flash Translation Layer or the SMR
drive's management layer.  So we apply the Smith and Dale technique[4]:

        Patient: Doctor, it hurts when I do _this_.
        Doctor Kronkheit: Don't _do_ that.

[4] Doctor Kronkheit and His Only Living Patient, Joe Smith and
Charlie Dale, 1920's American vaudeville comedy team.


The simplest implementation of this design does not require making any
on-disk format changes.  We simply suppress the writeback of the dirty
metadata block to the file system.  Instead we keep a journal map in
memory, which maps metadata block numbers (or data block numbers if data
journalling is enabled) to a block number in the journal.

The journal is not truncated when the file system is unmounted, and so
there is no difference between mounting a file system which has been
cleanly unmounted or after a system crash.  In both case, the ext4 file
system will scan the journal, and create an in-memory data structure
which maps metadata block locations to their location in the journal.
When a metadata block (or a data block, if data journalling is enabled)
needs to be read, if the block number is found in the journal map, the
block is read from the journal instead of from its "real" location on
disk.

Eventually, we will run out of room in the journal, and so we will need
to retire commits from the head of the journal.  For each block
referenced in the commit at the head of the journal, if it is has since
been updated in a newer commit, then no action will be needed.  For a
block that has not been updated in a newer commit, there are two
choices.   The checkpoint operation could either copy the block to the
tail of the journal, or write the block back to its final / "permanent"
location on disk.   The latter is preferable if it is unlikely that the
block will needed again, or if space is needed in the journal for other
metadata blocks.   On the other hand, writing the block to the final
location on disk will entail a random write, which will be especially
expensive on SMR disks.  Some experimentation may be needed to determine
the best hueristics to use.


Avoiding Updating the Journal Superblock
----------------------------------------

The basic scheme described above has does not require any format
changes.   However, while it eliminates most of the random writes
associated with the file system metadata, the journal superblock must be
updated each time the journal layer performs a "checkpoint" operation to
retire the oldest commits from the head of the journal, so that the
starting point of the journal can be identified.

This can be avoided by modifying the commit block to include the head of
the journal at the time of the commit, and then by requiring that first
block of each zone must be a jbd2 control block.  Since each control
block contains the sequence number, the mount operation simply needs to
scan the first block in each zone to find the control block with the
highest commit ID, and then parse the journal until the last valid
commit block is found.  Once the tail of the journal has been
identified, the last commit block will contain a pointer to the head of
the journal.

Applicability to other storage technologies
===========================================

This design was originally designed to improve ext4's performance on SMR
devices.  However, it it may be helpful for flash based devices, since
it reduces the write load caused by metadata blocks, since very often
the a particular metadata block will be updated in multiple commits.
Even on a hard drive, the reduction in writes and seek traffic may be
worthwhile.

Although we will need to benchmark this new scheme, this modified
journalling scheme should be at least as efficient as the current
mechanism used in the ext4/jbd2 implementation.  If this is true, it may
make sense to this be the default.




