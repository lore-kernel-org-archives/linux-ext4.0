From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] Some thoughts about providing data block checksumming
 for ext4
Date: Tue, 4 Nov 2014 16:39:55 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1411041622490.30941@file01.intranet.prod.int.rdu2.redhat.com>
References: <20141103233308.GA27842@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, dm-devel@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaKDVj7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 16:39:59 -0500
In-Reply-To: <20141103233308.GA27842@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, 3 Nov 2014, Theodore Ts'o wrote:

> But there is a way we can do even better!  If we can manage to
> compress the block even by a tiny amount, so that 4k block can be
> stored in 4092 bytes (which means we need to be able to compress the
> block by 0.1%), we can store the checksum inline with the data, which
> can then be atomically updated assuming a modern drive with a 4k
> sector size (even a 512e disk will work fine, assuming the partition
> is properly 4k aligned).  If the block is not sufficiently

There is still large number of drives with 512-byte sectors in use. So 
we'd rather use 512-byte block?

> If the data block is not compressible, and the write is not marked as
> non-critcal, then we need to worry about making sure the data block(s)
> and the checksum block are written out transactionally.  To do this, we
> write the current contents of the checksum block to a free block in
> the Active Area (AA) using FUA, which is 64 block area which is used to
> store a copy of checksum blocks for which their blocks are actively
> being modified.  We then calculate the checksum for the modified data
> blocks in the checksum group, and update the checksum block in memory,
> but we do not allow any of the data blocks to be written out until one
> of the following has happened and we need to trigger a commit of the
> checksum group:
> 
>    *) a 5 second timer has expired
>    *) we have run out of free slots in the Active Area
>    *) we are under significant memory pressure and we need to release some of
>          the pinned buffers for the data blocks in the checksum group
>    *) the file system has requested a FLUSH CACHE operation
> 
> A commit of the checksum group consists of the following:
> 
> 1) An update of the checksum block using a FUA write
> 2) Writing all of the pinned data blocks in the checksum group to disk
> 3) Sending a FLUSH CACHE request to the underlying storage
> 4) Allowing the slot in the Active Area to be used for some other checksum block

Filesystems assume that 512-byte write is performed atomically. If you 
split the sector to 4-bit nibble and the rest and write them to different 
locations, you must make sure that both are modified or none is modified.

I don't see how are you going to do that - other than writing the full 
sector to the active area - but that results in double writing, just like 
data=journal.

Note that the checksum function can have collisions, so the checksum value 
doesn't tell you which 4-bit nibble belongs to the data that is in the 
sector.

You could use cryptographic hash as the checksum function, you can 
reasonably assume that there are no collisions, but cryptographic hash is 
too slow to calculate.

> Recovery after a power fail
> ---------------------------
> 
> If the dm-protected device was not cleanly shut down, then we need to
> examine all of the checksum blocks in the Active Area.  For each
> checksum block in the AA, the checksums for all of their data blocks
> should machine either the checksum found in the AA, or the checksum
> found in the checksum block in the checksum group.

... and if the checksum of the block matches BOTH the checksum in the AA 
and the checksum in the checksum group (because of checksum function 
collision), you don't know which 4-bit nibble belongs to the data in the 
block.

> Once we have which
> checksum corresponds to the data block after the unclean shutdown, we
> can update the checksum block and clear the copy found in the AA.
> 
> On a clean shutdown of the dm-protected device, we can clear the
> Active Area, and so the recovery procedure will not be needed the next
> time the dm-protected device is initialized.

Mikulas
