From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH for 2.6.31] ext4: Mark the unwritten buffer_head mapped
	during write_begin
Date: Mon, 11 May 2009 07:49:13 -0400
Message-ID: <20090511114913.GA6347@mit.edu>
References: <1241693429-27588-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56789 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098AbZEKLtO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 07:49:14 -0400
Content-Disposition: inline
In-Reply-To: <1241693429-27588-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 07, 2009 at 04:20:29PM +0530, Aneesh Kumar K.V wrote:
> This avoid multiple get_block calls during write. Now that we have
> unwritten buffer marked as mapped, we need to make sure writepages
> will handle unwritten buffer_heads also.
> 
> With this patch we have the below:
> 
> ext4_ext_get_block returns unmapped, unwritten, buffer head when called with
> create = 0 for prealloc space. This make sure we handle the read path and non
> delalloc case correctly.  Even though the buffer head is marked unmapped we
> have valid b_blocknr and b_bdev values in the buffer_head.
> 
> ext4_da_get_block_prep called for block resrevation will now return mapped,
> unwritten, new buffer_head for prealloc space. This make sure we don't do
> multiple get_block calls for write to same offset. Also marking it new make
> sure sub-block zeroing of buffered writes happen correctly.

Can you clarify this patch description.  Is this only about avoiding
multiple calls to get_block_*(), or does this also fix some potential
filesystem corruption bugs?  And how does this fit in with the other
patches you've submitted?

Thanks,

							- Ted

