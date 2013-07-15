From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Beginner questions about ext4
Date: Mon, 15 Jul 2013 12:37:20 -0400
Message-ID: <20130715163720.GC26359@thunk.org>
References: <loom.20130612T140739-743@post.gmane.org>
 <loom.20130623T082353-563@post.gmane.org>
 <20130623115953.GA16193@thunk.org>
 <CACyNnZOkmpkTtDU_-6D9iC3aKOnP4n-XoO1_XJq=Hn2=BnEQYQ@mail.gmail.com>
 <20130715134357.GA26359@thunk.org>
 <CACyNnZPnzEbcFj69+fGjm1rkLay51WTXFMqr25AOzY3vtvegpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37994 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933394Ab3GOQhZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jul 2013 12:37:25 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZPnzEbcFj69+fGjm1rkLay51WTXFMqr25AOzY3vtvegpw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 15, 2013 at 06:09:03PM +0200, Felipe Monteiro de Carvalho wrote:
> Hello,
> 
> Thanks. Now I think that I am getting closer to something more concrete.
> 
> My superblock says:
> 
> superblock^.s_blocks_per_group = 32768
> superblock^.s_inodes_per_group = 8080
> superblock^.s_log_block_size = 2 -> so each block has 4k bytes
> 
> And when reading the root "/"  I obtain the following information for
> the directory /bin/ : inode=8081
> 
> So I calculate that it should have:
> groupnr=1 (because it is above 8080 inodes per group)
> offset for groupnr 1 --> 4k * 32768 = 0x8000000
> 
> But I have utilized a hex editor (oh boy, it was hard to find one that
> would read files over 4GB....) And the directory listing of /bin/ is
> located in aprox. near 0x21B0000
> 
> As if each block group would have a size of 0x2000000 .... but this
> size would be valid I would expect if
> superblock^.s_blocks_per_group=8192 ...
> 
> Any idea what I missed here that the calculations went wrong?

You're forgetting to read the inode structure.  So take the inode
number, determine that it's in the inode table fragment which belongs
to block group #1, then look up in the block group descriptors the
starting block of the inode table for bg #1, then look up the inode
size in the superblock, to determine the block number and offset to
read the inode structure.

Then you need to look at the inode structure to map logical block #0,
to the physical block number where the directory entries are located.

I suggest you RTFS in libext2fs....

					- Ted
