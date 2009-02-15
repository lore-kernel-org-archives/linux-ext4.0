From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 not currently doing (much) multi-block allocation?
Date: Sun, 15 Feb 2009 23:06:29 +0530
Message-ID: <20090215173629.GF22585@skywalker>
References: <20090215053206.GA4803@mini-me.lan> <20090215110528.GE22585@skywalker> <20090215133618.GE10706@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39397 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbZBORhD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Feb 2009 12:37:03 -0500
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1FHb1PM029811
	for <linux-ext4@vger.kernel.org>; Mon, 16 Feb 2009 04:37:01 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1FHb0A01159262
	for <linux-ext4@vger.kernel.org>; Mon, 16 Feb 2009 04:37:00 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1FHb0K0029277
	for <linux-ext4@vger.kernel.org>; Mon, 16 Feb 2009 04:37:00 +1100
Content-Disposition: inline
In-Reply-To: <20090215133618.GE10706@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 15, 2009 at 08:36:18AM -0500, Theodore Tso wrote:
> On Sun, Feb 15, 2009 at 04:35:28PM +0530, Aneesh Kumar K.V wrote:
> > Here is how it works. During writepages we loop through the dirty pages
> > and build largest contiguous block extent (mpage_add_bh_to_extent). Then we call
> > mpage_da_map_blocks. mpage_da_map_blocks does the mutli block request.
> > Once we have the blocks allocated we map these blocks to the pages. And
> > then we writeback one page at a time using writepage callback.
> 
> mpage_da_map_blocks() calls mpd->get_block, which is set to
> ext4_da_get_block_write(), which allocates a single block at a time
> (max_blocks is set to bh->b_size >> inode->i_blkbits).


That bh>b_size indicate multiple blocks. 

we do the below in mpage_add_bh_to_extent

2024         if (logical == next && (bh->b_state & BH_FLAGS) == lbh->b_state) {
2025                 lbh->b_size += b_size;
2026                 return;
2027         }

> 
> Put another way, where is the call to ext4_get_blocks_wrap() which
> does the multi-block request?  I don't see it...
> 

-aneesh
