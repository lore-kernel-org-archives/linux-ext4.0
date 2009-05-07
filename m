From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Thu, 07 May 2009 10:36:49 -0500
Message-ID: <4A030011.7040901@redhat.com>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37883 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZEGPgx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 May 2009 11:36:53 -0400
In-Reply-To: <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> ext4_get_blocks_wrap does a block lookup requesting to
> allocate new blocks. A lookup of blocks in prealloc area
> result in setting the unwritten flag in buffer_head. So
> a write to an unwritten extent will cause the buffer_head
> to have unwritten and mapped flag set. Clear hte unwritten
> buffer_head flag before requesting to allocate blocks.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c3cd00f..f6d7e9b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1149,6 +1149,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
>  	int retval;
>  
>  	clear_buffer_mapped(bh);
> +	clear_buffer_unwritten(bh);
>  
>  	/*
>  	 * Try to see if we can get  the block without requesting
> @@ -1179,6 +1180,12 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
>  		return retval;
>  
>  	/*
> +	 * The above get_blocks can cause the buffer to be
> +	 * marked unwritten. So clear the same.
> +	 */
> +	clear_buffer_unwritten(bh);

hm, thinking out loud here.

ext4_ext_get_blocks() will only set unwritten if (!create) ... but then
ext4_get_blocks_wrap() calls ext4_ext_get_blocks() !create as an
argument no matter what, the first time, for an initial lookup.

But if ext4_get_blocks_wrap() was called with !create, then we return
regardless, so ok - by the time you get to the above hunk, we -are- in
create mode, we're planning to write it ... so I guess clearing the
unwritten state makes sense here.

But is this too late, because it's after this?

        /*
         * Returns if the blocks have already allocated
         *
         * Note that if blocks have been preallocated
         * ext4_ext_get_block() returns th create = 0
         * with buffer head unmapped.
         */
        if (retval > 0 && buffer_mapped(bh))
                return retval;

I guess not; ext4_ext_get_blocks() won't map the buffer if it's found to
be preallocated/unwritten because it was called with !create.  If we're
going on to write it, we want to clear unwritten.

So I guess this looks right, although I can't help but think that in
general, the buffer_head state management is really getting to be a
hard-to-follow mess...

-Eric
