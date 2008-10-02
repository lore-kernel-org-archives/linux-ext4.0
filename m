From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Thu, 2 Oct 2008 23:38:21 +0530
Message-ID: <20081002180821.GA29613@skywalker>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:48151 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753730AbYJBSIc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2008 14:08:32 -0400
Content-Disposition: inline
In-Reply-To: <1222886451.9158.34.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 01, 2008 at 02:40:51PM -0400, Chris Mason wrote:
> Hello everyone,
> 
> write_cache_pages can use the address space writeback_index field to
> try and pick up where it left off between calls.  pdflush and
> balance_dirty_pages both enable this mode in hopes of having writeback
> evenly walk down the file instead of just servicing pages at the
> start of the address space.
> 
> But, there is no locking around this field, and concurrent callers of
> write_cache_pages on the same inode can get some very strange results.
> pdflush uses writeback_acquire function to make sure that only one
> pdflush process is servicing a given backing device, but
> balance_dirty_pages does not.
> 
> When there are a small number of dirty inodes in the system,
> balance_dirty_pages is likely to run in parallel with pdflush on one or
> two of them, leading to somewhat random updates of the writeback_index
> field in struct address space.
> 
> The end result is very seeky writeback during streaming IO.  A 4 drive
> hardware raid0 array here can do 317MB/s streaming O_DIRECT writes on
> ext4.  This is creating a new file, so O_DIRECT is really just a way to
> bypass write_cache_pages.
> 
> If I do buffered writes instead, XFS does 205MB/s, and ext4 clocks in at
> 81.7MB/s.  Looking at the buffered IO traces for each one, we can see a
> lot of seeks.
> 
> http://oss.oracle.com/~mason/bugs/writeback_ordering/ext4-nopatch.png
> 
> http://oss.oracle.com/~mason/bugs/writeback_ordering/xfs-nopatch.png
> 
> The patch below changes write_cache_pages to only use writeback_index
> when current_is_pdflush().  The basic idea is that pdflush is the only
> one who has concurrency control against the bdi, so it is the only one
> who can safely use and update writeback_index.
> 
> The performance changes quite a bit:
> 
>         patched        unpatched
> XFS     247MB/s        205MB/s
> Ext4    246MB/s        81.7MB/s


That is nice.

> 
> The graphs after the patch:
> 
> http://oss.oracle.com/~mason/bugs/writeback_ordering/ext4-patched.png
> 
> http://oss.oracle.com/~mason/bugs/writeback_ordering/xfs-patched.png
> 
> The ext4 graph really does look strange.  What's happening there is the
> lazy inode table init has dirtied a whole bunch of pages on the block
> device inode.  I don't have much of an answer for why my patch makes all
> of this writeback happen up front, other then writeback_index is no
> longer bouncing all over the address space.
> 
> It is also worth noting that before the patch, filefrag shows ext4 using
> about 4000 extents on the file.  After the patch it is around 400.  XFS
> uses 2 extents both patched and unpatched.
> 

Ext4 do block allocation in ext4_da_writepages. So if we are feeding the
block allocation with different(highly bouncing) index values we may end up with larger
number of extents. Although the new mballoc block allocator should
perform better because it reserve space based on logical block number
in the file.

-aneesh
