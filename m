From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/18] fs: add a set_acl inode operation
Date: Mon, 2 Dec 2013 21:57:44 +0100
Message-ID: <20131202205744.GD12253@quack.suse.cz>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120654.027611567@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>,
	reiserfs-devel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
	linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk,
	jfs-discussion@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Joel Becker <jlbec@evilplan.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20131201120654.027611567@bombadil.infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Sun 01-12-13 03:59:06, Christoph Hellwig wrote:
> This will allow moving all the Posix ACL handling into the VFS and clean
> up tons of cruft in the filesystems.
  Looks good. Btw I'd merge this with the following patch... Anyway:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/fs.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 121f11f..09f553c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1580,6 +1580,7 @@ struct inode_operations {
>  			   struct file *, unsigned open_flag,
>  			   umode_t create_mode, int *opened);
>  	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
> +	int (*set_acl)(struct inode *, struct posix_acl *, int);
>  } ____cacheline_aligned;
>  
>  ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
