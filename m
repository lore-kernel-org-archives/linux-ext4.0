From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 12/18] ocfs2: use generic posix ACL infrastructure
Date: Tue, 3 Dec 2013 00:00:07 +0100
Message-ID: <20131202230007.GK12253@quack.suse.cz>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120655.852590677@bombadil.infradead.org>
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
In-Reply-To: <20131201120655.852590677@bombadil.infradead.org>
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

On Sun 01-12-13 03:59:15, Christoph Hellwig wrote:
> This contains some major refactoring for the create path so that
> inodes are created with the right mode to start with instead of
> fixing it up later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
...
> -int ocfs2_acl_chmod(struct inode *inode)
> -{
> -	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -	struct posix_acl *acl;
> -	int ret;
> -
> -	if (S_ISLNK(inode->i_mode))
> -		return -EOPNOTSUPP;
> -
> -	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
> -		return 0;
> -
> -	acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
> -	if (IS_ERR(acl) || !acl)
> -		return PTR_ERR(acl);
> -	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
> -	if (ret)
> -		return ret;
> -	ret = ocfs2_set_acl(NULL, inode, NULL, ACL_TYPE_ACCESS,
> -			    acl, NULL, NULL);
> -	posix_acl_release(acl);
> -	return ret;
> -}
...

> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6fff128..ac371ad 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1236,7 +1236,7 @@ bail:
>  		dqput(transfer_to[qtype]);
>  
>  	if (!status && attr->ia_valid & ATTR_MODE) {
> -		status = ocfs2_acl_chmod(inode);
> +		status = posix_acl_chmod(inode);
>  		if (status < 0)
>  			mlog_errno(status);
>  	}
  Hum, this changes the cluster locking. Previously ocfs2_acl_get() used
from ocfs2_acl_chmod() grabbed cluster wide inode lock. Now getting of ACL
isn't protected by the inode lock. That being said the cluster locking
around setattr looks fishy anyway - if two processes on different
nodes are changing attributes of the same file, changing ACLs post fact
after dropping inode lock could cause interesting effects. Also I'm
wondering how inode_change_ok() can ever be safe without holding inode
lock... Until we grab that other node is free to change e.g. owner of the
inode thus leading even to security implications. But maybe I'm missing
something. Mark, Joel?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
