From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: remove ext4_mb_return_to_preallocation()
Date: Mon, 10 Jan 2011 10:45:31 -0600
Message-ID: <4D2B37AB.5010003@redhat.com>
References: <20110109030447.GX21922@thunk.org> <1294544609-14225-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jiaying Zhang <jiayingz@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab1AJQpf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 11:45:35 -0500
In-Reply-To: <1294544609-14225-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/08/2011 09:43 PM, Theodore Ts'o wrote:
> This function was never implemented, except for a BUG_ON which was
> tripping when ext4 is run without a journal.  The problem is that
> although the comment asserts that "truncate (which is the only way to
> free block) discards all preallocations", ext4_free_blocks() is also
> called in various error recovery paths when blocks have been
> allocated, but for various reasons, we were not able to use those data
> blocks (for example, because we ran out of memory while trying to
> manipulate the extent tree, or some other similar situation).
> 
> In addition to the fact that this function isn't implemented except
> for the incorrect BUG_ON, the single caller of this function,
> ext4_free_blocks(), doesn't use it all if the journal is enabled.
> 
> So remove the (stub) function entirely for now.  If we decide it's
> better to add it back, it's only going to be useful with a relatively
> large number of code changes anyway.

Acked-by: Eric Sandeen <sandeen@redhat.com>

This always bugged me.  :)

> Google-Bug-Id: 3236408
> 
> Cc: Jiaying Zhang <jiayingz@google.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/mballoc.c |   14 --------------
>  1 files changed, 0 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 5bbf6e3..85b6d44 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3881,19 +3881,6 @@ repeat:
>  	}
>  }
>  
> -/*
> - * finds all preallocated spaces and return blocks being freed to them
> - * if preallocated space becomes full (no block is used from the space)
> - * then the function frees space in buddy
> - * XXX: at the moment, truncate (which is the only way to free blocks)
> - * discards all preallocations
> - */
> -static void ext4_mb_return_to_preallocation(struct inode *inode,
> -					struct ext4_buddy *e4b,
> -					sector_t block, int count)
> -{
> -	BUG_ON(!list_empty(&EXT4_I(inode)->i_prealloc_list));
> -}
>  #ifdef CONFIG_EXT4_DEBUG
>  static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
>  {
> @@ -4648,7 +4635,6 @@ do_more:
>  		ext4_lock_group(sb, block_group);
>  		mb_clear_bits(bitmap_bh->b_data, bit, count);
>  		mb_free_blocks(inode, &e4b, bit, count);
> -		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
>  	}
>  
>  	ret = ext4_free_blks_count(sb, gdp) + count;

