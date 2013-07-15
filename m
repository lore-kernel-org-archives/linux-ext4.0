From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Beginner questions about ext4
Date: Mon, 15 Jul 2013 09:43:57 -0400
Message-ID: <20130715134357.GA26359@thunk.org>
References: <loom.20130612T140739-743@post.gmane.org>
 <loom.20130623T082353-563@post.gmane.org>
 <20130623115953.GA16193@thunk.org>
 <CACyNnZOkmpkTtDU_-6D9iC3aKOnP4n-XoO1_XJq=Hn2=BnEQYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37934 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab3GONoA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jul 2013 09:44:00 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZOkmpkTtDU_-6D9iC3aKOnP4n-XoO1_XJq=Hn2=BnEQYQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 15, 2013 at 12:20:01PM +0200, Felipe Monteiro de Carvalho wrote:
> On Sun, Jun 23, 2013 at 1:59 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > This had two difficulties.  The first is that every 128MB (assuming a
> > 4k blocksize and the default/maximum number of blocks per block
> > group), there would be file system metadata, thus breaking up the
> > maximum contiguous free space available for data blocks.
> 
> But the break up of contiguous free space still occurs, because each
> group has a group descriptor in it's beginning, right?

The sparse_super feature restricts the number of group descriptors to
those block groups which are multiples of the nth root of 3, 5, or 7.

So a 4T file system, only has 22 superblocks and group descriptors out
of 32768 blok groups (at block groups: 1, 3, 5, 7, 9, 25, 27, 49, 81,
125, 243, 343, 625, 729, 2187, 2401, 3125, 6561, 15625, 16807, and
19683).

There is also the meta_bg feature, which defines yet another concept,
a meta_bg group, which is the set of block groups which can fit in a
single block group descriptor block.  So for a 64-bit file system with
64-byte block group descriptors, you can fit 64 descriptors in a 4k
block.  So the size of a meta_bg group is 64 block groups.  (For a
file system w/o the 64-bit feature, the size of a meta_bg group is 128
block groups for file systems with 4k blocks.)  With a file system
with a meta_bg feature enabled, starting with the nth s_first_meta_bg
(i.e., block group s_first_meta_bg * bg_per_meta_bg), the block groups
are located at the first, second, and last block groups in a meta_bg
group.

The reason for the meta_bg feature is the resize_inode uses indirect
blocks, which only works for 32-bit block numbers.  So when we are
doing an online resize, once we expand the file system to the point
where we've run out of reserved bg descriptor blocks, or when we
expand beyond the 32-bit block number boundary, we enable the meta_bg
feature.  The advantage of the meta_bg feature is that it's no longer
required to reserved bg descriptor blocks, or to move the inode table
when doing off-line resizes.  The disadvantage of the meta_bg feature
is that the primary block groups are no longer contiguous, so it slows
down the time to mount a file system with a large number of bg
descriptor blocks which are laid out using the meta_bg feature.

Regards,

						- Ted

P.S.  And all of this is automatically handled by the ext2fs library.  :-P
