From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 30/49] ext4: Convert truncate_mutex to read write
 semaphore.
Date: Wed, 23 Jan 2008 14:06:59 -0800
Message-ID: <20080123140659.5b70ae6b.akpm@linux-foundation.org>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
	<1200970948-17903-15-git-send-email-tytso@mit.edu>
	<1200970948-17903-16-git-send-email-tytso@mit.edu>
	<1200970948-17903-17-git-send-email-tytso@mit.edu>
	<1200970948-17903-18-git-send-email-tytso@mit.edu>
	<1200970948-17903-19-git-send-email-tytso@mit.edu>
	<1200970948-17903-20-git-send-email-tytso@mit.edu>
	<1200970948-17903-21-git-send-email-tytso@mit.edu>
	<1200970948-17903-22-git-send-email-tytso@mit.edu>
	<1200970948-17903-23-git-send-email-tytso@mit.edu>
	<1200970948-17903-24-git-send-email-tytso@mit.edu>
	<1200970948-17903-25-git-send-email-tytso@mit.edu>
	<1200970948-17903-26-git-send-email-tytso@mit.edu>
	<1200970948-17903-27-git-send-email-tytso@mit.edu>
	<1200970948-17903-28-git-send-email-tytso@mit.edu>
	<1200970948-17903-29-git-send-email-tytso@mit.edu>
	<1200970948-17903-30-git-send-email-tytso@mit.edu>
	<1200970948-17903-31-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	Andy Whitcroft <apw@shadowen.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757059AbYAWWMc@vger.kernel.org>
In-Reply-To: <1200970948-17903-31-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Mon, 21 Jan 2008 22:02:09 -0500 "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> +int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
> +			unsigned long max_blocks, struct buffer_head *bh,
> +			int create, int extend_disksize)
> +{
> +	int retval;
> +	if (create) {
> +		down_write((&EXT4_I(inode)->i_data_sem));
> +	} else {
> +		down_read((&EXT4_I(inode)->i_data_sem));
> +	}
> +	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
> +		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
> +				bh, create, extend_disksize);
> +	} else {
> +		retval = ext4_get_blocks_handle(handle, inode, block,
> +				max_blocks, bh, create, extend_disksize);
> +	}
> +	if (create) {
> +		up_write((&EXT4_I(inode)->i_data_sem));
> +	} else {
> +		up_read((&EXT4_I(inode)->i_data_sem));
> +	}

This function has many unneeded braces.  checkpatch used to detect this
but it seems to have broken.

> +	return retval;
> +}
>  static int ext4_get_block(struct inode *inode, sector_t iblock,
>  			struct buffer_head *bh_result, int create)

Mising newline.
