From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recovering folder and files from ext4 partition
Date: Sun, 24 Jul 2016 17:31:50 -0400
Message-ID: <20160724213150.GF10966@thunk.org>
References: <114184338.3467667.1469315793830.JavaMail.yahoo.ref@mail.yahoo.com>
 <114184338.3467667.1469315793830.JavaMail.yahoo@mail.yahoo.com>
 <20160724021933.GD10966@thunk.org>
 <1347602750.3566292.1469347465293.JavaMail.yahoo@mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Bhatia Amit <amitbhatia@rocketmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58512 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbcGXVbz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Jul 2016 17:31:55 -0400
Content-Disposition: inline
In-Reply-To: <1347602750.3566292.1469347465293.JavaMail.yahoo@mail.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 24, 2016 at 08:04:25AM +0000, Bhatia Amit wrote:
> > But unless you can figure out how to get the blocks reconstructed in
> > the correct order, you're not going to be able to mount it or
> > otherwise get any data off of it using file system recovery tools....
> 
> I am not sure I understand this. So, can I write a program to
> reconstruct blocks in the correct order, in memory, and then write
> these correct blocks to a new disk? If so, can you suggest some
> existing code on how to get started in this direction? Are there
> tools to scan a disk for superblock locations and give them in
> sorted order? Also, how do I confirm whether this is an ext4 or ext3
> filesystem?

Given that the first (primary) superblock is near the *end* of the
disk, it means that the file systems blocks are arranged in some
arbitrary order.  e.g., in the normal course of events, you might
expect the blocks to be:

AAAAAAAAAAAAABBBBBBBBBBBBBCCCCCCCCCCCCCDDDDDDDDDDEEEEEEEEEEFFFFFFFFFF

but instead, the blocks might be arranged something like this:

DDDDDDDDDDBBBBBBBBBBBBBEEEEEEEEEEFFFFFFFFFFCCCCCCCCCCCCCAAAAAAAAAAAAA

This is just an example, but this is what I meant by the file system
blocks are not located sequentially across the disk.  The block group
number in the superblocks can help you a little bit, but it's not
enough necessarily to figure out where the boundaries are between
BBBBBBBBB and EEEEEE (for example).  So no, strictly speaking, you
can't just "reconstruct the blocks in the correct order".  It might be
possible for a human, doing a lot of forensics, to make some guess
about where the boundaries are, but it would require a lot of expert
human intuition.  It would probably be easier to try to see if you can
somehow extract the LVM metadata (if you can find it) which gives you
the mapping between the logical block numbers and the physical blocks
on disk.

Here is an example of an LVM map which is laid out completely
sequentially:

# lvdisplay -m /dev/lambda/library
  --- Logical volume ---
  LV Path                /dev/lambda/library
  LV Name                library
  VG Name                lambda
  LV UUID                KvM2gK-k9dQ-iB9z-kzdc-DhYq-L02J-MWC02l
  LV Write Access        read/write
  LV Creation host, time closure, 2015-07-13 23:27:41 -0400
  LV Status              available
  # open                 0
  LV Size                20.00 GiB
  Current LE             5120
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:13
   
  --- Segments ---
  Logical extents 0 to 5119:
    Type		linear
    Physical volume	/dev/sda4
    Physical extents	103680 to 108799
   
Unfortunately I don't have a fragmented LVM volume to show you, but if
I did, there would be multiple segments listed below, and you would
see (for example) maybe something that looked like this:

  Logical extents 0 to 1000:
    Type		linear
    Physical volume	/dev/sda4
    Physical extents	10368 to 11368
  Logical extents 1001 to 5119:
    Type		linear
    Physical volume	/dev/sda4
    Physical extents	100 to 4218

In this example, see how the physical extents for logical extents 1001
-- 5119 are lower than the physical extents for 0 -- 1000?  In this
particular case, my volume group has a physical extent of 4MB:

# vgdisplay lambda
  --- Volume group ---
  VG Name               lambda
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  25
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                5
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               701.51 GiB
  PE Size               4.00 MiB   <----------------
  Total PE              179587
  Alloc PE / Size       108800 / 425.00 GiB
  Free  PE / Size       70787 / 276.51 GiB
  VG UUID               5VlKAW-Yahk-fqJz-1eK9-jQ8P-4xt7-gofvh6
   
And so to get from an extent number to an lba number, you'd take the
physical extent number, multiply by 4MB, and then divide by 512 (the
sector size) to get the lba number.

The problem is knowing the mapping from logical extent to physical
extent.  And figuring out what the physical extent size might be.

And all of this is assuming that the WD Duo Live is using the stock
standard LVM system, as opposed to some proprietary cr*p....

	     	     		   		    - Ted
