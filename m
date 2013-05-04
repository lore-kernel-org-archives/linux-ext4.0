From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Two questions regarding ext4_fallocate()
Date: Sat, 4 May 2013 13:33:26 -0400
Message-ID: <20130504173326.GA5948@thunk.org>
References: <5185222A.20801@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Ji Wu <wu_ji2012@163.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46325 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758393Ab3EDS3T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 14:29:19 -0400
Content-Disposition: inline
In-Reply-To: <5185222A.20801@163.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 04, 2013 at 10:58:50PM +0800, Ji Wu wrote:
> Hi,
>    I have two questions regarding ext4_fallocate(),
> 
>    (1) The first is the FALLOC_FL_PUNCH_HOLE support, I am wondering
> what is the usage for it? The only use case comes to my mind is
> while ext4 being used for virtual machine image file storage. When
> VMM is aware of the file deleting operation in guest os, it can
> invoke host file system's fallocate() on the virtual machine image
> file to punch a hole to free host storage, so that save host
> space. But how can VMM being aware of guest file deleting? Simulate
> a virtual SSD-like block device to guest os, then capture the TRIM
> instruction issued by guest file system? That seems too tricky.  So
> basically, where and how to benefit from hole punching?

It's not too tricky; all of the hypervisors, whether it's KVM, or Xen,
or VMWare, are already simulating a SATA device to the guest OS.
Implementing support for the TRIM request is not that hard, and most
of the hypervisors are doing this already.  Implementing the punch
hole functionality was indeed primarily motivated for this use case.

The other historical use of this was for digital video recorders, but
that's a much more specialized use case.

>    (2) At the beginning of the function ext4_ext_punch_hole(), the
> codes are as follows,
> 
>         /* write out all dirty pages to avoid race condition */
>         filemap_write_and_wait_range(mapping, offset, offset+length-1);
>         mutex_lock(&inode->i_mutex);
>         truncate_page_cache_range();
> 
>     Why does it need synchronously write back the dirty pages fit
> into the hole, the data on the disk responding to those pages are to
> be deleted, why not directly release those pages, no matter they are
> dirty or not.  And furthermore, this is done before the inode lock is
> held, so it seems it may happen that after the pages are written
> back, and before the lock is held, those pages are dirtied again.
> So basically, why does it need call filemap_write_and_wait_range()
> before releasing those pages?

That's a good a question.  Looking at it, I'm not sure we do.  I
suspect this was put in originally to avoid races with setting the
EOFBLOCKS_FL flag, but as you point out, there's no way we can prevent
writes to sneak in before we grab the i_mutex.  As a result, we ended
up dropping the need for EOFBLOCKS_FL entirely.

Maybe one of the ext4 developers will see something that I'm missing,
but I think we can drop this, which indeed will have a significant
performance improvement for systems that use the punch hole
functionality.

Cheers,

						- Ted
