From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH] fs, dax: unify IOMAP_F_DIRTY read vs write handling
 policy in the dax core
Date: Tue, 14 Nov 2017 15:12:28 +1100
Message-ID: <20171114041228.GA4094@dastard>
References: <151062258598.8554.8157038002895095232.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <151062258598.8554.8157038002895095232.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 13, 2017 at 05:27:54PM -0800, Dan Williams wrote:
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index b43be199fbdf..888b60189983 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1087,9 +1087,9 @@ xfs_file_iomap_begin(
>  		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
>  	}
>  
> -	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
> -	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> -		iomap->flags |= IOMAP_F_DIRTY;
> +	if (xfs_ipincount(ip))
> +		if (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP)
> +			iomap->flags |= IOMAP_F_DIRTY;

Please make a helper for this, and use it in xfs_file_fsync() where
the same dirty checks are done. e.g.

static inline bool
xfs_inode_need_fsync(struct xfs_inode *ip, bool datasync)
{
	if (!xfs_ipincount(ip))
		return false;
	if (xfs_inode_clean(ip))
		return false;
	if (datasync &&
	    !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
		return false;
	return true;
}

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
