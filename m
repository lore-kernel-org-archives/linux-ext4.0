From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
Date: Tue, 11 May 2010 19:23:41 +1000
Message-ID: <1273569821.21352.19.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
	Saeed Bishara <saeed@marvell.com>,
	Nicolas Pitre <nico@marvell.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:41705 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab0EKJ1Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 May 2010 05:27:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks !

So I've been adapting upstream to my little D-Link DNS323 NAS box, which
is based on a Marvell 88f5182 chipset, ie, orion5 family) and started
hitting a problem with both ext3 and ext4 (on top of md/raid1). 

First, the setup: This is a VIVT cache ARM CPU (so it -could- be some
cache issues though it's a bit weird as I would expect metadata to be
normal kernel pages and thus not hit cache aliases but then I'm no
specialist of how we deal with those critters).

Linux version 2.6.34-rc7-00019-g6c4f192-dirty (benh@pasglop) (gcc version 4.4.0 (GCC) ) #6 PREEMPT Tue May 11 17:02:04 EST 2010
CPU: Feroceon [41069260] revision 0 (ARMv5TEJ), cr=a0053177
CPU: VIVT data cache, VIVT instruction cache

There's two 1T disk using the built-in SATA chipset. There's an almost-1T
partition on each (sda1 and sdb1) which are setup as a raid1 md.

Then, I create a filesystem (I started with ext4 and mkfs'ed it back to ext3
after I started having problems but things persist).

I'm booted off an nfs root and basically the problem happens when I rsync over
a pre-made root to the disks.

On a freshly mkfs'ed ext3 or 4, mounted in /mnt/raid, I rsync the thing over,
used it a bit and generally observe the first symptoms in the form of a few

EXT3-fs (md0): warning: ext3_rename: Deleting old file (34103297), 2, error=-2
EXT3-fs (md0): warning: ext3_rename: Deleting old file (34113314), 2, error=-2
EXT3-fs (md0): warning: ext3_rename: Deleting old file (34127945), 2, error=-2

in my kernel log. I had a very similar message with ext4 iirc.

I unmount the filesystem and fsck it (it takes almost 1h) and I then get
a bunch of:

Problem in HTREE directory inode 5005385: node (12) has bad max hash
Problem in HTREE directory inode 5005385: node (13) has bad max hash
Problem in HTREE directory inode 5005385: node (14) has bad max hash
Invalid HTREE directory inode 5005385 (/raid-foo/var/lib/dpkg/info).  Clear HTree index<y>? yes

followed by a bunch of

Inode 4981405 ref count is 1, should be 2.  Fix<y>? yes                        

This is reasonably reproducable, as I have re-done it twice and I get similar
errors.

Tomorrow, if time permits, I'll see if I can reproduce on a smaller partition
without md, and eventually narrow it to a smaller and more predictible set of
operations.

Since I doubt ext3 is busted so dramatically in mainline for "normal" machines,
I tend to suspect things could be related to the infamous vivt caches. On the
other hand, it's pretty clearly metadata or journal corruption and I'm not
sure we ever do things that could cause aliases (such as vmap etc..) on
these things, and they shouldn't be mapped into userspace... unless it's fsck
itself that causes aliases to occur at the block device level ? (I do unmount
though before I run fsck).

On the other hand, it could also be a busticated marvell SATA driver :-)

I have no problem with the vendor kernel, but it's ancient (2.6.12) and based
on an out of tree variant of a Marvell originated BSP, so everything is
completely different, especially in the area of drivers for the chipset.

Anyways, I'll see if I can gather more data tomorrow as time, viruses and sick
kids permits.

In the meantime, any hint appreciated.

Cheers,
Ben.


