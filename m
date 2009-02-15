From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 not currently doing (much) multi-block allocation?
Date: Sun, 15 Feb 2009 13:37:14 -0600
Message-ID: <49986EEA.1020405@redhat.com>
References: <20090215053206.GA4803@mini-me.lan> <20090215110528.GE22585@skywalker> <20090215133618.GE10706@mini-me.lan> <20090215173629.GF22585@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51323 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZBOTh7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2009 14:37:59 -0500
In-Reply-To: <20090215173629.GF22585@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Sun, Feb 15, 2009 at 08:36:18AM -0500, Theodore Tso wrote:
>> On Sun, Feb 15, 2009 at 04:35:28PM +0530, Aneesh Kumar K.V wrote:
>>> Here is how it works. During writepages we loop through the dirty pages
>>> and build largest contiguous block extent (mpage_add_bh_to_extent). Then we call
>>> mpage_da_map_blocks. mpage_da_map_blocks does the mutli block request.
>>> Once we have the blocks allocated we map these blocks to the pages. And
>>> then we writeback one page at a time using writepage callback.
>> mpage_da_map_blocks() calls mpd->get_block, which is set to
>> ext4_da_get_block_write(), which allocates a single block at a time
>> (max_blocks is set to bh->b_size >> inode->i_blkbits).
> 
> 
> That bh>b_size indicate multiple blocks. 

I never did like this overloading of a buffer head for this sort of
purpose, for this (sometimes confusing) reason, but it's done throughout
the kernel... :)

But, maybe a comment would be in order just to make it clear  "This is a
mapping BH" or something.

-Eric

> we do the below in mpage_add_bh_to_extent
> 
> 2024         if (logical == next && (bh->b_state & BH_FLAGS) == lbh->b_state) {
> 2025                 lbh->b_size += b_size;
> 2026                 return;
> 2027         }
> 
>> Put another way, where is the call to ext4_get_blocks_wrap() which
>> does the multi-block request?  I don't see it...
>>
> 

