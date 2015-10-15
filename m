From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/8] ext4: make the bitmap read routines return real
 error codes
Date: Thu, 15 Oct 2015 10:57:29 -0400
Message-ID: <20151015145729.GJ17329@thunk.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215458.28872.63722.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52086 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbbJOO5b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 10:57:31 -0400
Content-Disposition: inline
In-Reply-To: <20151012215458.28872.63722.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:54:58PM -0700, Darrick J. Wong wrote:
>   * Return buffer_head on success or NULL in case of failure.
>   */
> -struct buffer_head *
> -ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
> +int
> +ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group,
> +			      struct buffer_head **bbh)


Is there a reason why you didn't use the ERR_PTR convention?

>  
> -struct buffer_head *
> -ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
> +int
> +ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group,
> +		       struct buffer_head **bbh)

And here....

>   * Return buffer_head of bitmap on success or NULL.
>   */
> -static struct buffer_head *
> -ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
> +static int
> +ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group,
> +		       struct buffer_head **bbh)
>  {

And here....

					- Ted
					
