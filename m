From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 11/27] fuse: set mapping error in writepage_locked
 when it fails
Date: Wed, 10 May 2017 13:13:46 +0200
Message-ID: <20170510111346.GC25137@quack2.suse.cz>
References: <20170509154930.29524-1-jlayton@redhat.com>
 <20170509154930.29524-12-jlayton@redhat.com>
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
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170509154930.29524-12-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue 09-05-17 11:49:14, Jeff Layton wrote:
> This ensures that we see errors on fsync when writeback fails.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/fuse/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index ec238fb5a584..07d0efcb050c 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1669,6 +1669,7 @@ static int fuse_writepage_locked(struct page *page)
>  err_free:
>  	fuse_request_free(req);
>  err:
> +	mapping_set_error(page->mapping, error);
>  	end_page_writeback(page);
>  	return error;
>  }
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
