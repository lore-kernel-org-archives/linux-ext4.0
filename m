From: Theodore Tso <tytso@mit.edu>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	00000000 [ext4_new_meta_blocks+0x7c/0xb7]
Date: Fri, 12 Dec 2008 09:56:09 -0500
Message-ID: <20081212145609.GA26085@mit.edu>
References: <20081209104121.GA7572@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33170 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754885AbYLLO4O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 09:56:14 -0500
Content-Disposition: inline
In-Reply-To: <20081209104121.GA7572@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 09, 2008 at 04:11:22PM +0530, Aneesh Kumar K.V wrote:
> The problem is due to remove-do_blk_alloc patch.
> 
> The patch below should fix the crash. 
> 
> -		EXT4_I(inode)->i_allocated_meta_blocks += *count;
> +		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;


Good catch, thanks.  I'll add it to the patch queue.

> I have one question regarding the patch. What about blocks allocated for
> directories for the  ext3 format.  With extent format we are not
> setting EXT4_MB_HINT_DATA for non regular files. So i guess we also
> need the below patch .

One of the good things about getting rid of too many layers of
abstractions is that it makes bugs like this easier to spot.  We've
been sending allocating directory and symlinks using EXT4_MB_HINT_DATA
if extents haven't been enabled, and no one noticed before we
simplified out things....

Actually, I wonder if maybe we should set EXT4_MB_HINT_DATA for
directories as well.  Making directories contiguous does speed up
certain workloads, and it does speed up fsck.  It may be though that
the mballoc algorithms should be tuned specifically for directories,
and what we should do is to define a new flag, EXT4_MB_HINT_DIRECTORY,
and pass it in for that case. 

Some experimentation is clearly called for, here....

						- Ted
