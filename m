From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH, RFC 00/12] bigalloc patchset
Date: Tue, 22 Mar 2011 00:42:22 +0100
Message-ID: <339E9721-23DE-4B37-8AB4-A252CCE32C50@whamcloud.com>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu> <5427513F-76B9-4315-AC17-4BF35B290B18@dilger.ca> <20110321132415.GI4135@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8F190)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62925 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1CVHEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2011 03:04:52 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so6432066wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Mar 2011 00:04:51 -0700 (PDT)
In-Reply-To: <20110321132415.GI4135@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-21, at 2:24 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Mar 21, 2011 at 09:55:07AM +0100, Andreas Dilger wrote:
>> It would be a shame to waste another MB of space just to allocate
>> 4kB for the next index block...  I guess it isn't clear to me why
>> the index blocks need to be treated differently from file data
>> blocks or directory blocks in this regard, since they both can use
>> multiple blocks from the same cluster.  Being able to use the full
>> cluster would allow 256 * 344 = 88064 extents, or 11TB to be
>> addressed by the cluster of index blocks, which should be plenty.
> 
> There's a reason why I'm explicitly not supporting indirect blocks
> with bigalloc, at least initially.  :-)

To clarify, that means only extent-mapped files with bigalloc?  I was actually referring to the extent index cluster allocations.  I'd assume that at least a single index block needs to be handled, otherwise the maximum file size would be 4 * 128MB = 512MB. 

> The reason why this gets difficult with metadata blocks (directory
> blocks excepted) is the problem of determining whether or not a block
> in a cluster is in use or not at allocation time, and whether all of
> the blocks in a cluster are no longer in use when deciding whether or
> not to free a cluster. For data blocks we rely on the extent tree to
> determine this, since clusters are aligned with respect to logical
> block numbers --- that is, a physical cluster which is 1M starts on a
> 1M logical block boundary, and covers the logical blocks in that 1M
> region.  So if you have a file which has a 4k sparse block at offset
> 4, and another 4k sparse block located at offset 1M+42, that file will
> consume _two_ clusters, not one.

Will the actual file allocation be pointing to the cluster or the blocks within the cluster?  Pointing at the individual blocks is probably best (allows FIEMAP to return the actual used blocks, punch/truncate of the real blocks will free the cluster), so long as later allocation of adjacent blocks will first consume the unused blocks in that cluster instead of allocating new clusters. 

> But for file system metadata blocks, such as extent tree blocks, if we
> want to allocate multiple blocks from the same cluster, we would need
> some way of determining which blocks from that cluster have been
> allocated so far.  I could add a bitmap to the first block in the
> cluster, but that adds a lot of complexity.

Given that the number of index blocks for a single inode will be tiny, doing a list walk to see which blocks in the cluster are used would be pretty reasonable. Contrast that with the need to allocate a new cluster on disk, and later to seek to read the new index block from a different cluster, I think it is better to just do the full search. 

> One thing which I've thought about doing is to initialize a bitmap in
> the first block of a cluster (and then use the second block), but to
> only use one block per cluster for extent tree blocks --- at least for
> now.  That would allow a future read-only extension to use multiple
> blocks/cluster, and if I also implement checking the bitmap at free
> time, it could be a fully backwards compatible extension.

This is probably overkill. For e.g. a cluster size of 1MB means only 256 index blocks per cluster, all of which would fit into the first-level index block, if the second-level index blocks are needed. 

> 
>> Unfortunately, the overhead of allocating a whole cluster for every
>> index block and every directory is fairly high.  For Lustre it
>> matters very little, since there are only a handful of directories
>> (under 40) on the data filesystems where this would be used and the
>> real directory tree is located on a different metadata filesystem
>> which probably wouldn't use this feature, but for most "normal"
>> users this overhead may become prohibitive.  That is why I've been
>> trying to think of a way to allow sub-cluster allocations for these
>> uses.
> 
> I don't think it's that bad, if the cluster size is well chosen.  If
> you know that most of your files are 4-8M, and you are using a 1M
> cluster allocation size, most of the time you will be able to fit all
> of the extents you need into the inode.

Maybe I'm missing something, but isn't the direct-addressable extent size limit independent of the cluster size?  The extents are referencing blocks, so the extent size is still capped at 128MB. 

> It's only for highly
> fragmented file systems that you'll need more than 3 extents to store
> 8 clusters, no?  And for very large files, say 256M, an extra 1M
> extent would be unfortunate, if it is needed, but as a percentage of
> the file space used, it's not a complete deal breaker.

Well, it's true that with bigalloc it will be more likely to have contiguous extents (guaranteed to have at least extents of the cluster size :-) but it isn't clear whether this will avoid the need for multiple extents at a larger scale. 

>>> Please comment!  I do not intend for these patches to be merged during
>>> the 2.6.39 merge window.  I am targetting 2.6.40, 3 months from now,
>>> since these patches are quite extensive.
>> 
>> Is that before or after e2fsck support for this will be done?  I'm
>> rather reluctant to commit anything to the kernel that doesn't have
>> e2fsck support in a released e2fsprogs.
> 
> I think getting the e2fsck changes done in 3 months really ought not
> to be a problem...

Will that release include the 64bit feature, or will it be based off 1.41?

Cheers, Andreas
