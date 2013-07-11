From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Beginner questions about ext4
Date: Thu, 11 Jul 2013 11:23:38 -0400
Message-ID: <20130711152338.GA9530@thunk.org>
References: <loom.20130612T140739-743@post.gmane.org>
 <loom.20130623T082353-563@post.gmane.org>
 <20130623115953.GA16193@thunk.org>
 <CACyNnZNQ00D=hKHZ_wvfwJx3CWt7iELrbgUf_41AzzSAJmxGUw@mail.gmail.com>
 <20130701165524.GB23896@thunk.org>
 <CACyNnZPoAt2VNgGfRwzcvVdJHF8xKhE93zS7dGrmodg9Lm=cNQ@mail.gmail.com>
 <20130710172409.GC28076@thunk.org>
 <CACyNnZPc8-r3Qa+_MWiwB+niMkpbpgSfH8MHEOY0tM0n66LFgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36893 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab3GKPXq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Jul 2013 11:23:46 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZPc8-r3Qa+_MWiwB+niMkpbpgSfH8MHEOY0tM0n66LFgA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 11, 2013 at 09:37:05AM +0200, Felipe Monteiro de Carvalho wrote:
> Hello,
> 
> That would be great, but then how to explain that
> EXT4_FEATURE_INCOMPAT_FLEX_BG is present in
> superblock^.s_feature_incompat
> 
> Which indicates that knowledge of this feature is necessary in the reader

That was because originally the Linux kernel implementation would
check to make sure the inode table and allocation bitmaps for block
group N were in fact located in block group N.  If they were not, the
kernel would issue a lot of very scary warnings and mark the file
system as being corrupt when you tried to mount it.

But from a read-only implementation's perspective, the only thing you
need to know about the flex_bg feature is that inode table and
allocation bitmaps now have the __flexibility__ (hence the naming of
the file system feature "flex_bg") to be located outside of the block
group that they belong to.

The exact layout of how mke2fs and resize2fs will try to position the
inode tables is what is controlled by the flex_bg "size", where if the
flex_bg size is 16 block groups, we will try to locate the bg metadata
(i.e., inode tables plus allocation bitmaps) for blockgroups 0..15 in
bg 0, and the bg metadata for blockgroups 16..31 in bg 16, etc.  This
is a "best efforts" sort of thing, and there cases where this may not
be tree (for example, off-line resizing, in particular an off-line
shrink may change this).  So in the spirit of "be liberal in what you
accept, and conservative in what you receive", an implementation
should be prepared to deal with the inode table block and allocation
bitmaps being located anywhere in the file system.  It is _likely_
that the metadata block for a flex_bg will be located in a flex_bg,
but it is not guaranteed.

As used in the last sentence above, the term "flex_bg" is also
shorthand to refer to the collection of block groups 0 through 15 as a
"flex_bg" and blockgroups "15..31" as a flex_bg.  Yes, this is
confusing, although it's usually obvious from context whether
"flex_bg" is referring to the file system feature, or to a collection
of block groups.

The latter case is where where the allocation policy comes in, where
inodes which are located in the inode table corresponding to a flex_bg
consisting of block groups 0 through 15 will try to start allocating
directory blocks and extent tree blocks in block group 0, and data
blocks starting in block groups 1 and moving on through block group
15, and only then will we try to find another flex_bg to allocate the
data blocks.

The block allocation decisions and the layout of the inode table
blocks and allocation bitmaps only only matter if you are implementing
a read/write implementation of ext4, and they aren't even mandatory.
You could in theory create a read/write implementation that understood
the flex_bg feature, but used the layout and allocation algorithms
corresponding with ext3.  This will result in a much less performant
implementation, and cause greater file system fragmentation, but it
would be valid in terms of e2fsck passing judgement on whether the
file system is consistent.  Remember, the key word in "flex_bg" is
__flexibility__; it is what allows for more intelligent block
allocation algorithms and file system layouts.

Finally, can you please tell us what you are trying to do.  From what
I can tell, you are implementing some kind of propetiary read-only
library to read ext4 file systems?  Is this right?  If so, can I
pursuade you not to make it be proprietary, so you can use the
libext2fs library?  I've given you a lot of free advice and tutorials
in doing this, so it would be nice if you could reciprocate by telling
us what you are up to.  Maybe we can help you with more targetted
advice if we knew what you were doing.

Thanks, regards,

						- Ted
