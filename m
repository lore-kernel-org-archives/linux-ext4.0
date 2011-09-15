From: Ted Ts'o <tytso@mit.edu>
Subject: Re: On-disk field assignments for metadata checksum and snapshots
Date: Thu, 15 Sep 2011 13:56:49 -0400
Message-ID: <20110915175649.GJ15782@thunk.org>
References: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com>
 <20110915165512.GA12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40434 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934305Ab1IOR4x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 13:56:53 -0400
Content-Disposition: inline
In-Reply-To: <20110915165512.GA12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 09:55:12AM -0700, Darrick J. Wong wrote:
> On the other hand, you can set inode_size = block_size, which means
> that with a 4k inode + 32-bit inode number + 16-byte UUID you
> actually could run afoul of that degradation.  But that seems like
> an extreme argument for an infrequent case.

Yeah, that's an extremely infrequent case; in fact, I doubt it would
occur much besides testing, and as I've said, the main interest I have
for doing checksums is to detect gross defects, not subtle ones.  (One
and two bit errors will be caught by disk drive.)

> <shrug> Do you anticipate a need to add more fields to 128-byte inode
> filesystems?  I think most of those would be former ext2/3 filesystems,
> floppies, and "small" filesystems, correct?

Actually, at $WORK we're still using 128 byte inodes.  If you don't
need the high resolution timestamps or fast access to extended
attributes, there's no real point to using 256 byte inodes.  And 128
byte inodes allow you to pack more inodes per block, which can make
for a noticeable performance difference.  It's just since Fedora turns
on SELinux by default, the per-inode labels stored in xattrs suck so
much performance if you don't use 256 byte inods that most people
don't notice the performance degredation going from 128->256 byte
inodes.

> Actually, I've started wondering if we could split the 4 bytes of the crc32c
> among the first few inodes of the block, and compute the checksums at block
> size granularity.  Though that would make inode updates particularly more
> expensive... but if I'm going to shift the write-time checksum to a journal
> callback then it's not going to matter (for the journal-using users, anyway).

Yeah, I'd like to keep things cheap for the non-journal case; it's not
just at Google; anyone using ext4 where data reliability is being
handled via replication or reed-solomon encoding at the cluster file
system level (and Hadoopfs does this) is very likely going to be
interested in ext4 w/o a journal.

> Though with that scheme, you'd probably lose more inodes for any given
> integrity error.  It also means that the checksum size in each inode becomes
> variable (32 bits if inode=blocksize, 16 if inode=blocksize/2, and 8
> otherwise), which is a somewhat confusing schema.

On a disk drive, in practice the unit of data getting garbled is on a
per-sector basis.  It's highly, highly unlikely that that the first
128 bytes will be garbaged, and the second 128 bytes will be OK.  I
suppose that could happen if things got corrupted in memory, but
that's what ECC memory is for, right?  :-)

					- Ted
