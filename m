From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	00000000 [ext4_new_meta_blocks+0x7c/0xb7]
Date: Wed, 17 Dec 2008 13:26:35 +0530
Message-ID: <20081217075635.GA7685@skywalker>
References: <20081209104121.GA7572@skywalker> <20081212145609.GA26085@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:48953 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760192AbYLQIBT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 03:01:19 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id mBH7xtcw004421
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 18:59:55 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mBH7vU1P192104
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 18:57:30 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mBH7vUvI026933
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 18:57:30 +1100
Content-Disposition: inline
In-Reply-To: <20081212145609.GA26085@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 12, 2008 at 09:56:09AM -0500, Theodore Tso wrote:
> On Tue, Dec 09, 2008 at 04:11:22PM +0530, Aneesh Kumar K.V wrote:
> > The problem is due to remove-do_blk_alloc patch.
> > 
> > The patch below should fix the crash. 
> > 
> > -		EXT4_I(inode)->i_allocated_meta_blocks += *count;
> > +		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
> 
> 
> Good catch, thanks.  I'll add it to the patch queue.
> 
> > I have one question regarding the patch. What about blocks allocated for
> > directories for the  ext3 format.  With extent format we are not
> > setting EXT4_MB_HINT_DATA for non regular files. So i guess we also
> > need the below patch .
> 
> One of the good things about getting rid of too many layers of
> abstractions is that it makes bugs like this easier to spot.  We've
> been sending allocating directory and symlinks using EXT4_MB_HINT_DATA
> if extents haven't been enabled, and no one noticed before we
> simplified out things....

We had always sent the directory allocation request with
EXT4_MB_HINT_DATA not set.  With Linus kernel I have this

671 static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
.....
....
686         if (S_ISREG(inode->i_mode) && !(flags & EXT4_META_BLOCK))
687                 /* enable in-core preallocation for data block allocation */
688                 ar.flags = EXT4_MB_HINT_DATA;
689         else
690                 /* disable in-core preallocation for non-regular files */
691                 ar.flags = 0;


That means if the request for block allocation is not on regular files
set ar.flags = 0; For regular files if the request is for meta-data
blocks set ar.glags = 0.



> 
> Actually, I wonder if maybe we should set EXT4_MB_HINT_DATA for
> directories as well.  Making directories contiguous does speed up
> certain workloads, and it does speed up fsck.  It may be though that
> the mballoc algorithms should be tuned specifically for directories,
> and what we should do is to define a new flag, EXT4_MB_HINT_DIRECTORY,
> and pass it in for that case. 
> 
> Some experimentation is clearly called for, here....
> 

True. But with the changes to do do_blk_alloc I guess we need to make
sure we request directories with EXT4_MB_HINT_DATA not set.

-aneesh
