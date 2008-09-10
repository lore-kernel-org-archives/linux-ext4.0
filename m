From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Fiemap, an extent mapping ioctl
Date: Wed, 10 Sep 2008 09:47:27 -0400
Message-ID: <20080910134727.GA17498@infradead.org>
References: <20080825202250.GY3392@webber.adilger.int> <20080910124005.GA4563@wotan.suse.de> <20080910124934.GB4563@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYIJNrc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 09:47:32 -0400
Content-Disposition: inline
In-Reply-To: <20080910124934.GB4563@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2008 at 05:49:34AM -0700, Mark Fasheh wrote:
> * FIEMAP_FLAG_XATTR
> If this flag is set, the extents returned will describe the inodes
> extended attribute lookup tree, instead of it's data tree.

So does this actually make sense for any filesystem but XFS?  Still
seems like a not too useful option for a highlevel generic interface.

> 	__u32	fe_device;   /* device number for extent */

As sayd before please kill thise one.  It doesn't make any sense at all
for any merged or near mainline FS.  It'd be an utterly stupid
lustre-specific hack that still doesn't make much sense.

> * FIEMAP_EXTENT_NO_BYPASS
> Direct access to the data in this extent is illegal or will have
> undefined results.

Huh?  What is direct access?  Direct access as in bypassing the
filesystem and writing to the blockdev directly always has undefined
results.

> * FIEMAP_EXTENT_SECONDARY
> The data for this extent is in secondary storage (e.g. HSM).  If the
> data is not also in the filesystem, then FIEMAP_EXTENT_NO_BYPASS
> should also be set.

No HSM in mainline, so please drop it.  We can add it once we get HSM
support.

> * FIEMAP_EXTENT_NET
>   - This will also set FIEMAP_EXTENT_NO_BYPASS
> The data for this extent is not stored in a locally-accessible device.

Doesn't make any sense currently, please drop.

> * FIEMAP_EXTENT_DATA_COMPRESSED
>   - This will also set FIEMAP_EXTENT_NO_BYPASS
> The data in this extent has been compressed by the file system.

Add once we have users for it.

> * FIEMAP_EXTENT_DATA_ENCRYPTED
>   - This will also set FIEMAP_EXTENT_NO_BYPASS
> The data in this extent has been encrypted by the file system.
> 
> * FIEMAP_EXTENT_NOT_ALIGNED
> Extent offsets and length are not guaranteed to be block aligned.
> 
> * FIEMAP_EXTENT_DATA_INLINE
>   This will also set FIEMAP_EXTENT_NOT_ALIGNED
> Data is located within a meta data block.
> 
> * FIEMAP_EXTENT_DATA_TAIL
>   This will also set FIEMAP_EXTENT_NOT_ALIGNED
> Data is packed into a block with data from other files.
> 
> * FIEMAP_EXTENT_UNWRITTEN
> Unwritten extent - the extent is allocated but it's data has not been
> initialized.  This indicates the extent's data will be all zero if read
> through the filesystem but the contents are undefined if read directly from
> the device.
> 
> * FIEMAP_EXTENT_MERGED
> This will be set when a file does not support extents, i.e., it uses a block
> based addressing scheme.  Since returning an extent for each block back to
> userspace would be highly inefficient, the kernel will try to merge most
> adjacent blocks into 'extents'.

