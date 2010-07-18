From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix return value for mb_cache_shrink_fn when nr_to_scan
 > 0
Date: Sun, 18 Jul 2010 02:01:06 -0400
Message-ID: <20100718060106.GA579@infradead.org>
References: <4C425273.5000702@gmail.com>
 <4C427DC8.6020504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Sheng-Hui <crosslonelyover@gmail.com>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-mm@kvack.org, linux-ext4 <linux-ext4@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	a.gruenbacher@computer.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <4C427DC8.6020504@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 17, 2010 at 11:06:32PM -0500, Eric Sandeen wrote:
> +	/* Count remaining entries */
> +	spin_lock(&mb_cache_spinlock);
> +	list_for_each(l, &mb_cache_list) {
> +		struct mb_cache *cache =
> +			list_entry(l, struct mb_cache, c_cache_list);

This should be using list_for_each_entry.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
