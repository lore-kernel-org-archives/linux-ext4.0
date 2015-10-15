From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/6] ext4: Fix races between page faults and hole punching
Date: Wed, 14 Oct 2015 21:00:59 -0600
Message-ID: <20151015030059.GB31087@linux.intel.com>
References: <1444822227-29984-1-git-send-email-jack@suse.com>
 <1444822227-29984-2-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:21596 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbbJODBB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Oct 2015 23:01:01 -0400
Content-Disposition: inline
In-Reply-To: <1444822227-29984-2-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 14, 2015 at 01:30:22PM +0200, Jan Kara wrote:
> Currently, page faults and hole punching are completely unsynchronized.
> This can result in page fault faulting in a page into a range that we
> are punching after truncate_pagecache_range() has been called and thus
> we can end up with a page mapped to disk blocks that will be shortly
> freed. Filesystem corruption will shortly follow. Note that the same
> race is avoided for truncate by checking page fault offset against
> i_size but there isn't similar mechanism available for punching holes.
> 
> Fix the problem by creating new rw semaphore i_mmap_sem in inode and
> grab it for writing over truncate and hole punching and for read over
> page faults. We cannot easily use i_data_sem for this since that ranks
> below transaction start and we need something ranking above it so that
> it can be held over the whole truncate / hole punching operation.
> 
> Signed-off-by: Jan Kara <jack@suse.com>
> ---
>  fs/ext4/ext4.h  | 10 +++++++++
>  fs/ext4/file.c  | 66 +++++++++++++++++++++++++++++++++++++++++++++++++--------
>  fs/ext4/inode.c | 27 +++++++++++++++++++----
>  fs/ext4/super.c |  1 +
>  4 files changed, 91 insertions(+), 13 deletions(-)

I wonder if there are a few other operations in ext4_fallocate() that
we may need to protect in addition to ext4_punch_hole()?

Do ext4_collapse_range(), ext4_insert_range() and maybe even ext4_zero_range()
need protection?

For what it's worth the rest of the locking looks good to me.  The lock
ordering is the same as with ext2 and XFS, and all the DAX fault handlers look
correct to me.
