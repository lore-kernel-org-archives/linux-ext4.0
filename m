From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 2/9 linux-next] nilfs2: remove dir_pages() declaration
Date: Mon, 25 May 2015 10:06:42 +0900 (JST)
Message-ID: <20150525.100642.1998714117047339503.konishi.ryusuke@lab.ntt.co.jp>
References: <1432480791-31396-1-git-send-email-fabf@skynet.be>
	<1432480791-31396-3-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Boaz Harrosh <ooo-rh7Tgz9RNieUD9Wbbkgo/g@public.gmane.org>,
	Benny Halevy <bhalevy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Evgeniy Dushistov <dushistov-JGs/UdohzUI@public.gmane.org>
To: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432480791-31396-3-git-send-email-fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 24 May 2015 17:19:42 +0200, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org> wrote:
> dir_pages() is now declared in pagemap.h
> 
> Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
> ---
>  fs/nilfs2/dir.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index 0ee0bed..6b8b92b 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -61,11 +61,6 @@ static inline void nilfs_put_page(struct page *page)
>  	page_cache_release(page);
>  }
>  
> -static inline unsigned long dir_pages(struct inode *inode)
> -{
> -	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
> -}
> -

Can you include this and similar changes in the first patch
"pagemap.h: declare dir_pages()" ?

The first patch transiently breaks build because it inserts a
duplicate definition of the dir_pages() inline function until it gets
removed from each file system by the successive patches.

This series looks non-divisible except the patch of ufs.

Regards,
Ryusuke Konishi

>  /*
>   * Return the offset into page `page_nr' of the last valid
>   * byte in that page, plus one.
> -- 
> 2.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
