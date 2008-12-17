From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	00000000 [ext4_new_meta_blocks+0x7c/0xb7]
Date: Wed, 17 Dec 2008 21:55:54 +0530
Message-ID: <20081217162554.GA6863@skywalker>
References: <20081209104121.GA7572@skywalker> <20081212145609.GA26085@mit.edu> <20081217075635.GA7685@skywalker> <20081217114711.GL10590@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:34159 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYLQQaD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 11:30:03 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id mBHGScLj008325
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 03:28:38 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mBHGQDQP246628
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 03:26:13 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mBHGQDNN016045
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 03:26:13 +1100
Content-Disposition: inline
In-Reply-To: <20081217114711.GL10590@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 17, 2008 at 06:47:11AM -0500, Theodore Tso wrote:
> On Wed, Dec 17, 2008 at 01:26:35PM +0530, Aneesh Kumar K.V wrote:
> > > One of the good things about getting rid of too many layers of
> > > abstractions is that it makes bugs like this easier to spot.  We've
> > > been sending allocating directory and symlinks using EXT4_MB_HINT_DATA
> > > if extents haven't been enabled, and no one noticed before we
> > > simplified out things....
> > 
> > We had always sent the directory allocation request with
> > EXT4_MB_HINT_DATA not set.
> 
> With extents, yes.  With normal indirect block-based files, no.  I
> agree that for consistency's sake, it should be the same, but at the
> moment, it isn't.

Hmm. May be I am missing something. This is the call chain i followed
with the Linus tree.
ext4_get_block
 ext4_get_blocks_wrap
  ext4_get_blocks_handle
   ext4_alloc_branch
    ext4_alloc_blocks
     ext4_new_meta_blocks
      do_blk_alloc -> which set ar.flags = 0 for meta data.
     ext4_new_blocks
      do_blk_alloc -> which set ar.flags = 0 for !S_ISREG(inode->i_mode)

So the current Linus kernel using mballoc for non extent format doesn't
set EXT4_MB_HINT_DATA for directories.


-aneesh
