From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 2/8] fs/buffer.c: make some functions non-static
Date: Fri, 12 Jan 2018 06:38:23 -0800
Message-ID: <20180112143823.GA28063@bombadil.infradead.org>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <20180112141129.27507-3-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112141129.27507-3-chandan@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 12, 2018 at 07:41:23PM +0530, Chandan Rajendra wrote:
> @@ -1642,12 +1642,12 @@ EXPORT_SYMBOL(clean_bdev_aliases);
>   * constraints in mind (relevant mostly if some
>   * architecture has a slow bit-scan instruction)
>   */
> -static inline int block_size_bits(unsigned int blocksize)
> +int block_size_bits(unsigned int blocksize)
>  {
>  	return ilog2(blocksize);
>  }

Could you move this to buffer.h instead please?
