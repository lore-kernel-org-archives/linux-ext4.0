From: Jan Kara <jack@suse.cz>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
Date: Thu, 13 May 2010 17:12:46 +0200
Message-ID: <20100513151245.GA21251@quack.suse.cz>
References: <1273569821.21352.19.camel@pasglop>
 <1273575478.21352.29.camel@pasglop>
 <20100512150057.GA29867@atrey.karlin.mff.cuni.cz>
 <1273709714.21352.138.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Saeed Bishara <saeed@marvell.com>,
	Nicolas Pitre <nico@marvell.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50135 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab0EMPM6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 May 2010 11:12:58 -0400
Content-Disposition: inline
In-Reply-To: <1273709714.21352.138.camel@pasglop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 13-05-10 10:15:14, Benjamin Herrenschmidt wrote:
> On Wed, 2010-05-12 at 17:00 +0200, Jan Kara wrote:
> 
> >  Could you get the filesystem image with: e2image -r /dev/sdb2 buggy-image
> > bzip2 it and make it available somewhere? Maybe I could guess something
> > from the way the filesystem gets corrupted.
> >  Oh, and also overwrite the partition with zeros before calling mkfs to make
> > the analysis simpler.
> 
> Here we go.
> 
> Created a smaller partition (100MB). dd'ed /dev/zero to it, dd'ed it off
> to NFS host to locally cmp it with /dev/zero to make sure it's nice and
> clean. It is. Then mkfs.ext3, mount, rsync over /usr/lib of my test
> root, unmount, and dd it off to the NFS host again.
> 
> The result shows the same errors with fsck.ext3 -n -f ./test.img
> 
> I uploaded it at:
> 
> http://gate.crashing.org/~benh/test.img.bz2
  Thanks. I had a look at it. It seems that it's really the HTREE code
that's causing problems. When a directory is using HTREEs, it should contain
directory entries in some hash range in each block. Say entries with hash
0-0xabcd1234 in block 0, entries with hash 0xabcd1235-0xffffffff in block
1. But the corrupted directories do not obey this rule. In particular e.g.
block 1 should contain entries with hashes 0-0x2fac6780 but it contains
lots of entries with hash larger than 0x2fac6780. I've spent quite some
time looking into the code and I'm not yet sure how that could happen.
  My first suspect would be code splitting blocks when a block gets full.
The code allocates new block for a directory, then inside the buffer
creates an array of

struct dx_map_entry
{
        u32 hash;
        u16 offs;
        u16 size;
};

entries describing entries in the block to split. Then this array is
sorted, we find a place to split and copy appropriate entries to the new
block and compact the old block.
  In the binary dump of one of corrupted directories, I've found the built
array:
000e70 00 00 00 00 00 00 00 00 16 bd f8 01 f0 03 10 00
000e80 7a b1 0d 05 e0 03 10 00 2e 19 bb 08 cc 03 14 00
000e90 60 bd bf 09 e0 03 10 00 a6 79 5d 0a b0 03 0c 00
000ea0 08 5a 1b 0b a0 03 10 00 ac b6 15 0d a0 03 10 00
000eb0 d8 3e cc 0f 84 03 10 00 8c 0f f1 27 74 03 10 00
000ec0 24 09 85 2f 60 03 14 00 b8 61 c3 35 60 03 14 00
000ed0 c4 27 62 37 60 03 14 00 7c d9 07 39 60 03 14 00
000ee0 80 d6 70 3a 60 03 14 00 28 49 0e 3b 94 03 0c 00
000ef0 fe c6 81 3f 94 03 0c 00 78 b8 1e 40 b0 03 0c 00
000f00 2a 3e 04 42 b0 03 0c 00 82 0a 81 46 b0 03 0c 00
000f10 bc 2a 87 47 b0 03 0c 00 ea 9e f3 47 b0 03 0c 00
000f20 20 ac 28 48 bc 02 18 00 ac 20 f2 4c 5c 02 18 00
000f30 62 10 1d 54 bc 02 18 00 5e f9 f6 57 b0 03 0c 00
000f40 78 d4 58 5e 5c 02 18 00 da ab 8f 62 5c 02 18 00
000f50 b0 15 98 68 e4 01 18 00 2e a4 15 79 5c 02 18 00
000f60 b2 d9 16 79 bc 02 18 00 3e eb fe 7a a0 01 18 00
000f70 40 fa c2 81 a0 01 18 00 a0 c3 79 84 a0 01 18 00
000f80 3a cc a8 85 a0 01 18 00 aa 10 53 87 44 01 18 00
000f90 78 33 b0 8a 44 01 18 00 f4 da a1 8b 8c 02 18 00
000fa0 3e 6a d6 8c 10 02 1c 00 2a 27 17 8e 44 01 18 00
000fb0 c0 4a 91 90 10 02 1c 00 b2 61 6c 9a 70 01 14 00
000fc0 e0 ef eb a3 8c 02 18 00 c2 e3 00 a5 8c 02 18 00
000fd0 c0 5d 6e b6 5c 02 18 00 a8 1c 6e b7 5c 02 18 00
000fe0 fc 45 ea ba 40 00 14 00 52 d5 21 be a0 01 18 00
000ff0 4e 66 55 d1 a0 01 18 00 b0 35 b4 d3 8c 02 18 00
<next directory block starts>

If you look at the array more in detail, you'll notice that 'offs' part of
structure is sometimes identical. That should never happen because 'offs'
contains offset of the corresponding directory entry in a block. So when
offsets are identical in this array, subsequent move will copy some entries
several times and leave entries that should be moved in the old block,
resulting in a corruption we see.
  The question is, how could offsets be the same? dx_make_map seems to get
it right and dx_sort_map as well. Maybe I'd peek into disassembly of
dx_sort_map to see whether swap() macro does what it should... If that
looks OK, you could try adding some debug checks into dx_sort_map and try
to catch the moment when duplicate offsets are created...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
