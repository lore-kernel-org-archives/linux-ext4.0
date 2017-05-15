From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 21/27] mm: clean up error handling in write_one_page
Date: Mon, 15 May 2017 14:01:14 +0200
Message-ID: <20170515120114.GF16182@quack2.suse.cz>
References: <20170509154930.29524-1-jlayton@redhat.com>
 <20170509154930.29524-22-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
        ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org,
        jack-IBi9RG/b67k@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org,
        neilb-l3A5Bk7waGM@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
        josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, hubcap-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org, rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        bo.li.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170509154930.29524-22-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue 09-05-17 11:49:24, Jeff Layton wrote:
> Don't try to check PageError since that's potentially racy and not
> necessarily going to be set after writepage errors out.
> 
> Instead, sample the mapping error early on, and use that value to tell
> us whether we got a writeback error since then.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  mm/page-writeback.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index de0dbf12e2c1..1643456881b4 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2373,11 +2373,12 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  int write_one_page(struct page *page)
>  {
>  	struct address_space *mapping = page->mapping;
> -	int ret = 0;
> +	int ret = 0, ret2;
>  	struct writeback_control wbc = {
>  		.sync_mode = WB_SYNC_ALL,
>  		.nr_to_write = 1,
>  	};
> +	errseq_t since = filemap_sample_wb_error(mapping);
>  
>  	BUG_ON(!PageLocked(page));
>  
> @@ -2386,16 +2387,14 @@ int write_one_page(struct page *page)
>  	if (clear_page_dirty_for_io(page)) {
>  		get_page(page);
>  		ret = mapping->a_ops->writepage(page, &wbc);
> -		if (ret == 0) {
> +		if (ret == 0)
>  			wait_on_page_writeback(page);
> -			if (PageError(page))
> -				ret = -EIO;
> -		}
>  		put_page(page);
>  	} else {
>  		unlock_page(page);
>  	}
> -	return ret;
> +	ret2 = filemap_check_wb_error(mapping, since);
> +	return ret ? : ret2;
>  }
>  EXPORT_SYMBOL(write_one_page);
>  
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
