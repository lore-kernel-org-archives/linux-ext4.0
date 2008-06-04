From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Wed, 4 Jun 2008 09:31:01 +0530
Message-ID: <20080604040101.GA22348@skywalker>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080604022356.GA7094@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:49883 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYFDEBQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 00:01:16 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5440eWC010187
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 14:00:40 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m5445OTN207474
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 14:05:24 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5441DRm005285
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 14:01:13 +1000
Content-Disposition: inline
In-Reply-To: <20080604022356.GA7094@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 03, 2008 at 10:23:56PM -0400, Theodore Tso wrote:
> On Tue, May 20, 2008 at 02:04:22AM +0530, Aneesh Kumar K.V wrote:
> > When mouting ext4 with -o noextents, request for
> > file data blocks from inode prealloc space.
> 
> Aneesh, can you expand on this patch set?  Why is this important?
> What was it doing beforehand?  Is this to replace the use of the block
> reservations code that had been introduced by Mingming in ext3?  Or is
> that a long-term goal?
> 
> Also, it would be nice to add some comments at the beginning of the
> changed functions, explaining what the functions do, what they are
> intended for, what they assumptions they make (i.e., do they assume
> that certain locks are taken), any side effects they make (i.e., this
> function calls get_bh or put_bh to change the refcount on a passed-in
> buffer head).   
> 
> I assume there was a good reason that you renamed the function
> ext4_new_block() to ext4_fsblk_t ext4_new_meta_block(), but why?  Some
> comments would really be useful.
> 
> I asked Mingming what this patch did when I was reviewing it this
> afternoon, since we were both in New Hampshire at the btrfs
> conference.  I couldn't parse the english for the comments, and after
> looking at the patch, it wasn't at all obvious what the patch was
> trying to accomplish.  Even though Mingming had reviewed it maybe two
> weeks ago, she couldn't figure it out completely after looking over
> the patch.  Consider how a someone who isn't intimately familiar with
> the code would be able to figure out either (a) the code, or (b)
> looking over the changeset.  Good code has to be long-term
> maintainable, and some comments would really help in this department.
> 
> Since neither of us couldn't figure it out what the motivation of this
> patch, we've decided to move it to the unstable portion of the patch
> since without some better comments, it's probably not a good idea to
> push it to Linus in this form.
> 
> 						- Ted

When we mount the filesystem with -o noextents currently the block
allocation requests are not using the preallocation feature of mballoc.
mballoc consider the allocation request that doesn't have
ar.flags = EXT4_MB_HINT_DATA set as meta-data allocation and force
them to get the blocks via regular allocator ext4_mb_regular_allocator.
In order to make sure -o noextents (or ext3 format) block allocation
use the preallocation feature we need to set the EXT4_MB_HINT_DATA
while requesting for the blocks. mballoc also needs the
logical block number of the requested block so that it call nicely place
it in the inode prealloc space. This means that we need to differentiate
between data allocation request and meta-data allocation request. The
meta-data allocation is done without setting EXT4_MB_HINT_DATA flag
and they would use the regular allocator where as the data blocks
are requested with EXT4_MB_HINT_DATA set and along with logical block
number so that they can allocate the blocks nicely from the inode prealloc
space. Now with -o noextents we request for blocks via
ext4_alloc_blocks.  Earlier we request for both the data and meta-block
together. Now we can't do that since the data-blocks are allocated based
on the logical block number of the request. So the changes was to split
it such that we first request for meta-data blocks and then request
for data-blocks with the logical block number.


-aneesh
