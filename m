From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 v3] ext4: fix xfstests 75, 112, 127 punch hole
 failure
Date: Thu, 4 Aug 2011 11:25:19 -0400
Message-ID: <20110804152519.GJ3150@thunk.org>
References: <4E396744.2030003@linux.vnet.ibm.com>
 <20110804005001.GI3150@thunk.org>
 <4E3A48D2.3070905@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57831 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab1HDPZZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2011 11:25:25 -0400
Content-Disposition: inline
In-Reply-To: <4E3A48D2.3070905@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 04, 2011 at 12:22:58AM -0700, Allison Henderson wrote:
> 
> Oh, I think we do avoid calling the unmap for this last condition
> though.  The first and last page offsets are calculated earlier for
> calling truncate_inode_pages_range to release all the pages in the
> hole. The idea is that everything from first_page_offset to
> last_page_offset covers all the page aligned pages in the hole.  So
> then if offset and length are aligned, we basically end up with
> first_page_offset = offset and last_page_offset = offset + length,
> and the page_len will turn out to be zero.  Right math?  Maybe we
> can add some comments or something to help clarify.

Yeah, sorry, I wasn't clear enough about the condition.  Consider the
situation where we punch the region:

   4092 -- 8197

In the previous section of code, we would zero out the byte ranges
4092--4095 and 8192--8197.  What's left is a completely page-aligned
range, which would have already been taken care of already.  But since
we're calculating based on offsets, I believe there will be an
unnecessary call to ext4_unmap_page_range().  

BTW, the name ext4_unmap_page_range() is a bit confusing; maybe we
should rename it to ext4_unmap_partial_page_buffers()?

I know you were copying from the ext4_block_zero_page_range() function
and its calling sequence (but in my opinion that function wasn't named
well and the comments in that code aren't good either).

I also wonder why we can't fold the functionality found in
ext4_unmap_page_range() into ext4_block_zero_page_range().  Did you
look into that option?

Regards,

						- Ted
