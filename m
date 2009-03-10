From: Theodore Tso <tytso@mit.edu>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Tue, 10 Mar 2009 18:48:10 -0400
Message-ID: <20090310224810.GA15229@mit.edu>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au> <49B5D71D.1030802@redhat.com> <1236655451.30280.29.camel@kulgan.wumi.org.au> <49B5EDFE.8060405@redhat.com> <1236661371.30280.33.camel@kulgan.wumi.org.au> <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu> <1236719691.16191.9.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35134 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbZCJWs0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Mar 2009 18:48:26 -0400
Content-Disposition: inline
In-Reply-To: <1236719691.16191.9.camel@kulgan.wumi.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 11, 2009 at 07:44:51AM +1030, Kevin Shanahan wrote:
> Thanks Ted. Just so I know what I'm doing if/when this comes up again, I
> guess the process would be:
> 
>   - debugfs /dev/some-filesystem
>   - debugfs:  stat "some/problem/file"
>   - get the inode number from the output above (867 in this case)
>   - debugfs dump 867 inode867.bin

Actually, it's a bit more complicated than that.  I should really add
a hook to debugfs to automate this, but... to find the block to grab,
you do this.   

1)  Grab the following fields from dumpe2fs (or debugfs's "stats" command)

Inodes per group:         8192
Block size:               4096
Inodes per group:         8192
Inode size:               256

2) To find out which block group the inode is located in, we calculate:

inode bg = inode_number / inodes_per_group
         = 867 / 8192 = block group 0

(everything done using integer division, rounding any fraction down to 0.)

3) To find where the inode table for block group in question can be
found, check out dumpe2fs.

Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
      ...
  Inode table at 65-576 (+65)
                 ^^^^^^

OK, we know it begins at block 65.

Now some more math:

inode_per_block = block_size / inode_size
		= 4096 / 256 = 16

offset_block = (inode_number % inodes_per_group) / inodes_per_block
             = (867 % 8192) / 16
	     = 54

So now we know that the block containing inode 867 is 65+54 = 119

Now to dump that block, we do:

    dd if=/dev/fs-device of=block-119.dump bs=4k skip=119 count=1


> Or perhaps running e2fsck -n first to see which inodes really look
> corrupted and get the numbers that way. 

Yep.  In general, when you get corruption like this, the bad inodes
comes in chunks of 16 (if you are using 256 byte inodes) or 32 (if you
are using 128 byte inodes).

						- Ted
