From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/22] ext3: use little endian bitops
Date: Mon, 18 Oct 2010 12:31:56 +0200
Message-ID: <20101018103156.GE3826@quack.suse.cz>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
 <1287135981-17604-12-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57231 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0JRKc6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Oct 2010 06:32:58 -0400
Content-Disposition: inline
In-Reply-To: <1287135981-17604-12-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 15-10-10 18:46:10, Akinobu Mita wrote:
> As a preparation for removing ext2 non-atomic bit operations from
> asm/bitops.h. This converts ext2 non-atomic bit operations to
> little endian bit operations.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  include/linux/ext3_fs.h |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
> index 6ce1bca..34ef455 100644
> --- a/include/linux/ext3_fs.h
> +++ b/include/linux/ext3_fs.h
> @@ -418,13 +418,18 @@ struct ext3_inode {
>  #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
>  #endif
>  
> -#define ext3_set_bit			ext2_set_bit
> +#define ext3_set_bit(nr, addr)	\
> +	__test_and_set_le_bit((nr), (unsigned long *)(addr))
>  #define ext3_set_bit_atomic		ext2_set_bit_atomic
> -#define ext3_clear_bit			ext2_clear_bit
> +#define ext3_clear_bit(nr, addr)	\
> +	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
>  #define ext3_clear_bit_atomic		ext2_clear_bit_atomic
> -#define ext3_test_bit			ext2_test_bit
> -#define ext3_find_first_zero_bit	ext2_find_first_zero_bit
> -#define ext3_find_next_zero_bit		ext2_find_next_zero_bit
> +#define ext3_test_bit(nr, addr)	\
> +	test_le_bit((nr), (unsigned long *)(addr))
> +#define ext3_find_first_zero_bit(addr, size)	\
> +	find_first_zero_le_bit((unsigned long *)(addr), (size))
> +#define ext3_find_next_zero_bit(addr, size, off)	\
> +	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
>  
>  /*
>   * Maximal mount counts between two filesystem checks
> -- 
> 1.7.1.231.gd0b16
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
