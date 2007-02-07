From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Tue, 6 Feb 2007 17:33:44 -0800
Message-ID: <20070206173344.a3e8e37a.akpm@linux-foundation.org>
References: <20070116210520sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: sho@tnes.nec.co.jp
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070116210520sho@rifu.tnes.nec.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 16 Jan 2007 21:05:20 +0900
sho@tnes.nec.co.jp wrote:

> Move the blocks on the temporary inode to the original inode
> by a page.
> 1. Read the file data from the old blocks to the page
> 2. Move the block on the temporary inode to the original inode
> 3. Write the file data on the page into the new blocks
> 
> ...
>
> +
> +/**
> + * ext4_ext_replace_branches - replace original extents with new extents.
> + * @org_inode    Original inode
> + * @dest_inode   temporary inode
> + * @from_page    Page offset
> + * @count_page   Page count to be replaced
> + * @delete_start block offset for deletion
> + *
> + * This function returns 0 if succeed, otherwise returns error value.
> + * Replace extents for blocks from "from" to "from+count-1".
> + */
> +static int
> +ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
> +			pgoff_t from_page,  pgoff_t dest_from_page,
> +			pgoff_t count_page, unsigned long *delete_start) 
> +{
> +	struct ext4_ext_path *org_path = NULL;
> +	struct ext4_ext_path *dest_path = NULL;
> +	struct ext4_extent   *oext, *dext;
> +	struct ext4_extent   tmp_ext;
> +	int	err = 0;
> +	int	depth;
> +	unsigned long from, count, dest_off, diff, replaced_count = 0;

These should be sector_t, shouldn't they?

> +	handle_t *handle = NULL;
> +	unsigned jnum;
> +
> +	from = from_page << (PAGE_CACHE_SHIFT - dest_inode->i_blkbits);

In which case one needs to be very careful to avoid overflows in
expressions such as this one.

> +	wait_on_page_locked(page);
> +	lock_page(page);

The wait_on_page_locked() is unneeded here.
