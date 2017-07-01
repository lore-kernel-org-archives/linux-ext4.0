From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] xfs: remove a whitespace-only line from
 xfs_fs_get_nextdqblk
Date: Fri, 30 Jun 2017 19:45:31 -0700
Message-ID: <20170701024531.GR5874@birch.djwong.org>
References: <20170629135420.21357-1-hch@lst.de>
 <20170629135420.21357-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170629135420.21357-2-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 29, 2017 at 06:54:16AM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_quotaops.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index f82d79a8c694..de9493253edf 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -269,7 +269,6 @@ xfs_fs_get_nextdqblk(
>  	/* ID may be different, so convert back what we got */
>  	*qid = make_kqid(current_user_ns(), qid->type, id);
>  	return 0;
> -	
>  }
>  
>  STATIC int
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
