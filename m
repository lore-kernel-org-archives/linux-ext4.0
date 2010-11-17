From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH 3/6] Ocfs2: handle hole punching via fallocate properly
Date: Wed, 17 Nov 2010 15:27:45 -0800
Message-ID: <20101117232745.GG25677@mail.oracle.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
 <1289840723-3056-4-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
	cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1289840723-3056-4-git-send-email-josef@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 15, 2010 at 12:05:20PM -0500, Josef Bacik wrote:
> This patch just makes ocfs2 use its UNRESERVP ioctl when we get the hole punch
> flag in fallocate.  I didn't test it, but it seems simple enough.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Seems reasonable to me.
Acked-by: Joel Becker <joel.becker@oracle.com>

Joel

> ---
>  fs/ocfs2/file.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 77b4c04..181ae52 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1992,6 +1992,7 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct ocfs2_space_resv sr;
>  	int change_size = 1;
> +	int cmd = OCFS2_IOC_RESVSP64;
>  
>  	if (!ocfs2_writes_unwritten_extents(osb))
>  		return -EOPNOTSUPP;
> @@ -2002,12 +2003,17 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
>  	if (mode & FALLOC_FL_KEEP_SIZE)
>  		change_size = 0;
>  
> +	if (mode & FALLOC_FL_PUNCH_HOLE) {
> +		cmd = OCFS2_IOC_UNRESVSP64;
> +		change_size = 0;
> +	}
> +
>  	sr.l_whence = 0;
>  	sr.l_start = (s64)offset;
>  	sr.l_len = (s64)len;
>  
> -	return __ocfs2_change_file_space(NULL, inode, offset,
> -					 OCFS2_IOC_RESVSP64, &sr, change_size);
> +	return __ocfs2_change_file_space(NULL, inode, offset, cmd, &sr,
> +					 change_size);
>  }
>  
>  int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
