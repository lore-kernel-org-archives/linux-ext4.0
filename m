From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 not currently doing (much) multi-block allocation?
Date: Sun, 15 Feb 2009 16:35:28 +0530
Message-ID: <20090215110528.GE22585@skywalker>
References: <20090215053206.GA4803@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37310 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZBOLG0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Feb 2009 06:06:26 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1FB6Oqv011361
	for <linux-ext4@vger.kernel.org>; Sun, 15 Feb 2009 22:06:24 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1FB6Lhk426020
	for <linux-ext4@vger.kernel.org>; Sun, 15 Feb 2009 22:06:24 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1FB6LUb032673
	for <linux-ext4@vger.kernel.org>; Sun, 15 Feb 2009 22:06:21 +1100
Content-Disposition: inline
In-Reply-To: <20090215053206.GA4803@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 15, 2009 at 12:32:06AM -0500, Theodore Tso wrote:
> So I was looking at the ext4 code to see how hard it would be to add a
> function that would take a struct inode *, and make sure that all of
> the pages in the page cache had been allocated a physical block on
> disk (but not necessarily writing the I/O to disk).  The idea would be
> to do this on close if the file had been truncated or opened with
> O_TRUNC, and to also call this function if the inode had been renamed
> and in the process a destination inode was freed.  That way if we have
> data=ordered, the blocks would be allocated, and at the next commit,
> we would force the data blocks to disk.
> 
> While I was looking at the code, it looks to me like we are currently
> only allocating a page at a time; ext4_da_writepages() may end up
> allocating a number of pages, but it's doing it one page at a time,
> not an extent at a time.  So if the filesystem blocksize is 4k (and
> the page size is 4k), the only time we will ever call the mballoc with
> an allocation request greater than 1 is in the fallocate() system call
> handler.   This seems... non-optimal.   Am I missing something?
> 

Here is how it works. During writepages we loop through the dirty pages
and build largest contiguous block extent (mpage_add_bh_to_extent). Then we call
mpage_da_map_blocks. mpage_da_map_blocks does the mutli block request.
Once we have the blocks allocated we map these blocks to the pages. And
then we writeback one page at a time using writepage callback.

-aneesh
