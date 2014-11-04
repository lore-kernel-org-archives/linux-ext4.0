From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [PATCH 11/12] jfs: Convert to private i_dquot
	field
Date: Tue, 04 Nov 2014 08:17:15 -0600
Message-ID: <5458DFEB.50300@oracle.com>
References: <1415099993-18034-1-git-send-email-jack@suse.cz>
	<1415099993-18034-12-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
        tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
        Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>,
        reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
        cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1415099993-18034-12-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On 11/04/2014 05:19 AM, Jan Kara wrote:

> CC: jfs-discussion@lists.sourceforge.net
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>  fs/jfs/jfs_incore.h | 3 +++
>  fs/jfs/super.c      | 9 +++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/fs/jfs/jfs_incore.h b/fs/jfs/jfs_incore.h
> index cf47f09e8ac8..fa7e795bd8ae 100644
> --- a/fs/jfs/jfs_incore.h
> +++ b/fs/jfs/jfs_incore.h
> @@ -94,6 +94,9 @@ struct jfs_inode_info {
>  			unchar _inline_ea[128];	/* 128: inline extended attr */
>  		} link;
>  	} u;
> +#ifdef CONFIG_QUOTA
> +	struct dquot *i_dquot[MAXQUOTAS];
> +#endif
>  	u32 dev;	/* will die when we get wide dev_t */
>  	struct inode	vfs_inode;
>  };
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 93e897e588a8..16c3a9556634 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -117,6 +117,9 @@ static struct inode *jfs_alloc_inode(struct super_block *sb)
>  	jfs_inode = kmem_cache_alloc(jfs_inode_cachep, GFP_NOFS);
>  	if (!jfs_inode)
>  		return NULL;
> +#ifdef CONFIG_QUOTA
> +	memset(&jfs_inode->i_dquot, 0, sizeof(jfs_inode->i_dquot));
> +#endif
>  	return &jfs_inode->vfs_inode;
>  }
>  
> @@ -537,6 +540,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
>  #ifdef CONFIG_QUOTA
>  	sb->dq_op = &dquot_operations;
>  	sb->s_qcop = &dquot_quotactl_ops;
> +	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
>  #endif
>  
>  	/*
> @@ -836,6 +840,10 @@ out:
>  	return len - towrite;
>  }
>  
> +static struct dquot **jfs_get_dquots(struct inode *inode)
> +{
> +	return JFS_IP(inode)->i_dquot;
> +}
>  #endif
>  
>  static const struct super_operations jfs_super_operations = {
> @@ -854,6 +862,7 @@ static const struct super_operations jfs_super_operations = {
>  #ifdef CONFIG_QUOTA
>  	.quota_read	= jfs_quota_read,
>  	.quota_write	= jfs_quota_write,
> +	.get_dquots	= jfs_get_dquots,
>  #endif
>  };
>  
> 
