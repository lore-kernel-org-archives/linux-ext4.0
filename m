From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/12] jfs: Convert to private i_dquot field
Date: Fri, 10 Oct 2014 17:40:44 +0200
Message-ID: <20141010154043.GC8705@quack.suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
 <1412952910-7142-12-git-send-email-jack@suse.cz>
 <5437FC2E.6020000@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5437FC2E.6020000@oracle.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 10-10-14 10:33:02, Dave Kleikamp wrote:
> On 10/10/2014 09:55 AM, Jan Kara wrote:
> > CC: Dave Kleikamp <shaggy@kernel.org>
> > CC: jfs-discussion@lists.sourceforge.net
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/jfs/jfs_incore.h |  3 +++
> >  fs/jfs/super.c      | 13 +++++++++++++
> >  2 files changed, 16 insertions(+)
> > 
> > diff --git a/fs/jfs/jfs_incore.h b/fs/jfs/jfs_incore.h
> > index cf47f09e8ac8..fa7e795bd8ae 100644
> > --- a/fs/jfs/jfs_incore.h
> > +++ b/fs/jfs/jfs_incore.h
> > @@ -94,6 +94,9 @@ struct jfs_inode_info {
> >  			unchar _inline_ea[128];	/* 128: inline extended attr */
> >  		} link;
> >  	} u;
> > +#ifdef CONFIG_QUOTA
> > +	struct dquot *i_dquot[MAXQUOTAS];
> > +#endif
> >  	u32 dev;	/* will die when we get wide dev_t */
> >  	struct inode	vfs_inode;
> >  };
> > diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> > index adf8cb045b9e..a13727dd3826 100644
> > --- a/fs/jfs/super.c
> > +++ b/fs/jfs/super.c
> > @@ -54,6 +54,7 @@ static struct kmem_cache *jfs_inode_cachep;
> >  
> >  static const struct super_operations jfs_super_operations;
> >  static const struct export_operations jfs_export_operations;
> > +static const int jfs_inode_fields[IF_FIELD_NR];
> 
> see below
> 
> >  static struct file_system_type jfs_fs_type;
> >  
> >  #define MAX_COMMIT_THREADS 64
> > @@ -117,6 +118,9 @@ static struct inode *jfs_alloc_inode(struct super_block *sb)
> >  	jfs_inode = kmem_cache_alloc(jfs_inode_cachep, GFP_NOFS);
> >  	if (!jfs_inode)
> >  		return NULL;
> > +#ifdef CONFIG_QUOTA
> > +	memset(&jfs_inode->i_dquot, 0, sizeof(jfs_inode->i_dquot));
> > +#endif
> >  	return &jfs_inode->vfs_inode;
> >  }
> >  
> > @@ -537,7 +541,9 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
> >  #ifdef CONFIG_QUOTA
> >  	sb->dq_op = &dquot_operations;
> >  	sb->s_qcop = &dquot_quotactl_ops;
> > +	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
> >  #endif
> > +	sb_init_inode_fields(sb, jfs_inode_fields);
> >  
> >  	/*
> >  	 * Initialize direct-mapping inode/address-space
> > @@ -857,6 +863,13 @@ static const struct super_operations jfs_super_operations = {
> >  #endif
> >  };
> >  
> > +static const int jfs_inode_fields[IF_FIELD_NR] = {
> > +#ifdef CONFIG_QUOTA
> > +	[IF_DQUOTS] = (int)offsetof(struct jfs_inode_info, i_dquot) -
> > +		      (int)offsetof(struct jfs_inode_info, vfs_inode),
> > +#endif
> > +};
> 
> Why isn't the initialization done up above where jfs_inode_fields is
> first defined?
  There's no good reason, I'll move the definition. The code got created this
way because I added the table in all filesystems after jfs_super_operations
definition but JFS needed the structure earlier... Thanks for review.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
