From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC 00/12] bigalloc patchset
Date: Mon, 21 Mar 2011 09:24:15 -0400
Message-ID: <20110321132415.GI4135@thunk.org>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
 <5427513F-76B9-4315-AC17-4BF35B290B18@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34068 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1CUNYU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2011 09:24:20 -0400
Content-Disposition: inline
In-Reply-To: <5427513F-76B9-4315-AC17-4BF35B290B18@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2011 at 09:55:07AM +0100, Andreas Dilger wrote:
> > 
> > The cost is increased disk space efficiency.  Directories will consume
> > 1T, as will extent tree blocks.
>
> Presumably you mean "1M" here and not "1T"?

Yes; or more accurately, one allocation cluster (no matter what size
it might be).


> It would be a shame to waste another MB of space just to allocate
> 4kB for the next indirect block...  I guess it isn't clear to me why
> the index blocks need to be treated differently from file data
> blocks or directory blocks in this regard, since they both can use
> multiple blocks from the same cluster.  Being able to use the full
> cluster would allow 256 * 344 = 88064 extents, or 11TB to be
> addressed by the cluster of index blocks, which should be plenty.

There's a reason why I'm explicitly not supporting indirect blocks
with bigalloc, at least initially.  :-)

The reason why this gets difficult with metadata blocks (directory
blocks excepted) is the problem of determining whether or not a block
in a cluster is in use or not at allocation time, and whether all of
the blocks in a cluster are no longer in use when deciding whether or
not to free a cluster.  For data blocks we rely on the extent tree to
determine this, since clusters are aligned with respect to logical
block numbers --- that is, a physical cluster which is 1M starts on a
1M logical block boundary, and covers the logical blocks in that 1M
region.  So if you have a file which has a 4k sparse block at offset
4, and another 4k sparse block located at offset 1M+42, that file will
consume _two_ clusters, not one.

But for file system metadata blocks, such as extent tree blocks, if we
want to allocate multiple blocks from the same cluster, we would need
some way of determining which blocks from that cluster have been
allocated so far.  I could add a bitmap to the first block in the
cluster, but that adds a lot of complexity.

One thing which I've thought about doing is to initialize a bitmap in
the first block of a cluster (and then use the second block), but to
only use one block per cluster for extent tree blocks --- at least for
now.  That would allow a future read-only extension to use multiple
blocks/cluster, and if I also implement checking the bitmap at free
time, it could be a fully backwards compatible extension.

> Unfortunately, the overhead of allocating a whole cluster for every
> index block and every directory is fairly high.  For Lustre it
> matters very little, since there are only a handful of directories
> (under 40) on the data filesystems where this would be used and the
> real directory tree is located on a different metadata filesystem
> which probably wouldn't use this feature, but for most "normal"
> users this overhead may become prohibitive.  That is why I've been
> trying to think of a way to allow sub-cluster allocations for these
> uses.

I don't think it's that bad, if the cluster size is well chosen.  If
you know that most of your files are 4-8M, and you are using a 1M
cluster allocation size, most of the time you will be able to fit all
of the extents you need into the inode.  It's only for highly
fragmented file systems that you'll need more than 3 extents to store
8 clusters, no?  And for very large files, say 256M, an extra 1M
extent would be unfortunate, if it is needed, but as a percentage of
the file space used, it's not a complete deal breaker.

> > Please comment!  I do not intend for these patches to be merged during
> > the 2.6.39 merge window.  I am targetting 2.6.40, 3 months from now,
> > since these patches are quite extensive.
> 
> Is that before or after e2fsck support for this will be done?  I'm
> rather reluctant to commit anything to the kernel that doesn't have
> e2fsck support in a released e2fsprogs.

I think getting the e2fsck changes done in 3 months really ought not
to be a problem...

						- Ted
