From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 28/28] quota: add extra inode count to dquot transfer
 functions
Date: Thu, 15 Jun 2017 09:57:35 +0200
Message-ID: <20170615075735.GB1764@quack2.suse.cz>
References: <20170531081517.11438-1-tahsin@google.com>
 <20170531081517.11438-28-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170531081517.11438-28-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 31-05-17 01:15:17, Tahsin Erdogan wrote:
> Ext4 ea_inode feature allows storing xattr values in external inodes to
> be able to store values that are bigger than a block in size. Ext4 also
> has deduplication support for these type of inodes. With deduplication,
> the actual storage waste is eliminated but the users of such inodes are
> still charged full quota for the inodes as if there was no sharing
> happening in the background.
> 
> This design requires ext4 to manually charge the users because the
> inodes are shared.
> 
> An implication of this is that, if someone calls chown on a file that
> has such references we need to transfer the quota for the file and xattr
> inodes. Current dquot_transfer() function implicitly transfers one inode
> charge. In our case, we would like to specify additional inodes to be
> transferred.

Hum, rather handle this similarly to how we handle delalloc reserved space.
Add a callback to dq_ops to get "inode usage" of an inode and then use it
in dquot_transfer(), dquot_free_inode(), dquot_alloc_inode().

								Honza

 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
>  fs/ext2/inode.c          |  2 +-
>  fs/ext4/inode.c          |  8 ++++++-
>  fs/ext4/ioctl.c          | 13 +++++++++++-
>  fs/ext4/xattr.c          | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/xattr.h          |  2 ++
>  fs/jfs/file.c            |  2 +-
>  fs/ocfs2/file.c          |  2 +-
>  fs/quota/dquot.c         | 16 +++++++-------
>  fs/reiserfs/inode.c      |  2 +-
>  include/linux/quotaops.h |  8 ++++---
>  10 files changed, 93 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 2dcbd5698884..a13ba5dcb355 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1656,7 +1656,7 @@ int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
>  	}
>  	if ((iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid)) ||
>  	    (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid))) {
> -		error = dquot_transfer(inode, iattr);
> +		error = dquot_transfer(inode, iattr, 0);
>  		if (error)
>  			return error;
>  	}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6f5872197d6c..28abbbdbbb80 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5267,6 +5267,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	int error, rc = 0;
>  	int orphan = 0;
>  	const unsigned int ia_valid = attr->ia_valid;
> +	int ea_inode_refs;
>  
>  	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
>  		return -EIO;
> @@ -5293,7 +5294,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  			error = PTR_ERR(handle);
>  			goto err_out;
>  		}
> -		error = dquot_transfer(inode, attr);
> +
> +		down_read(&EXT4_I(inode)->xattr_sem);
> +		error = ea_inode_refs = ext4_xattr_inode_count(inode);
> +		if (ea_inode_refs >= 0)
> +			error = dquot_transfer(inode, attr, ea_inode_refs);
> +		up_read(&EXT4_I(inode)->xattr_sem);
>  		if (error) {
>  			ext4_journal_stop(handle);
>  			return error;
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index dde8deb11e59..9938dc8e24c8 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -21,6 +21,7 @@
>  #include "ext4.h"
>  #include <linux/fsmap.h>
>  #include "fsmap.h"
> +#include "xattr.h"
>  #include <trace/events/ext4.h>
>  
>  /**
> @@ -319,6 +320,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>  	struct ext4_iloc iloc;
>  	struct ext4_inode *raw_inode;
>  	struct dquot *transfer_to[MAXQUOTAS] = { };
> +	int ea_inode_refs;
>  
>  	if (!ext4_has_feature_project(sb)) {
>  		if (projid != EXT4_DEF_PROJID)
> @@ -371,9 +373,17 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>  	if (err)
>  		goto out_stop;
>  
> +	down_read(&EXT4_I(inode)->xattr_sem);
> +	ea_inode_refs = ext4_xattr_inode_count(inode);
> +	if (ea_inode_refs < 0) {
> +		up_read(&EXT4_I(inode)->xattr_sem);
> +		err = ea_inode_refs;
> +		goto out_stop;
> +	}
> +
>  	transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
>  	if (!IS_ERR(transfer_to[PRJQUOTA])) {
> -		err = __dquot_transfer(inode, transfer_to);
> +		err = __dquot_transfer(inode, transfer_to, ea_inode_refs);
>  		dqput(transfer_to[PRJQUOTA]);
>  		if (err)
>  			goto out_dirty;
> @@ -382,6 +392,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>  	EXT4_I(inode)->i_projid = kprojid;
>  	inode->i_ctime = current_time(inode);
>  out_dirty:
> +	up_read(&EXT4_I(inode)->xattr_sem);
>  	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
>  	if (!err)
>  		err = rc;
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index caddc176a612..1d6fcbb01517 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -701,6 +701,60 @@ static void ext4_xattr_update_super_block(handle_t *handle,
>  	}
>  }
>  
> +int ext4_xattr_inode_count(struct inode *inode)
> +{
> +	struct ext4_iloc iloc = { .bh = NULL };
> +	struct buffer_head *bh = NULL;
> +	struct ext4_inode *raw_inode;
> +	struct ext4_xattr_ibody_header *header;
> +	struct ext4_xattr_entry *entry;
> +	int inode_count = 0;
> +	void *end;
> +	int ret;
> +
> +	lockdep_assert_held_read(&EXT4_I(inode)->xattr_sem);
> +
> +	if (ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
> +		ret = ext4_get_inode_loc(inode, &iloc);
> +		if (ret)
> +			goto out;
> +		raw_inode = ext4_raw_inode(&iloc);
> +		header = IHDR(inode, raw_inode);
> +		end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
> +		ret = xattr_check_inode(inode, header, end);
> +		if (ret)
> +			goto out;
> +
> +		for (entry = IFIRST(header); !IS_LAST_ENTRY(entry);
> +		     entry = EXT4_XATTR_NEXT(entry))
> +			if (entry->e_value_inum)
> +				inode_count++;
> +	}
> +
> +	if (EXT4_I(inode)->i_file_acl) {
> +		bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
> +		if (!bh) {
> +			ret = -EIO;
> +			goto out;
> +		}
> +
> +		if (ext4_xattr_check_block(inode, bh)) {
> +			ret = -EFSCORRUPTED;
> +			goto out;
> +		}
> +
> +		for (entry = BFIRST(bh); !IS_LAST_ENTRY(entry);
> +		     entry = EXT4_XATTR_NEXT(entry))
> +			if (entry->e_value_inum)
> +				inode_count++;
> +	}
> +	ret = inode_count;
> +out:
> +	brelse(iloc.bh);
> +	brelse(bh);
> +	return ret;
> +}
> +
>  static inline size_t round_up_cluster(struct inode *inode, size_t length)
>  {
>  	struct super_block *sb = inode->i_sb;
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index 67616cb9a059..8ef6fe123255 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -193,3 +193,5 @@ extern void ext4_xattr_inode_set_class(struct inode *ea_inode);
>  #else
>  static inline void ext4_xattr_inode_set_class(struct inode *ea_inode) { }
>  #endif
> +
> +int ext4_xattr_inode_count(struct inode *inode);
> diff --git a/fs/jfs/file.c b/fs/jfs/file.c
> index 739492c7a3fd..b08e0b0449a7 100644
> --- a/fs/jfs/file.c
> +++ b/fs/jfs/file.c
> @@ -114,7 +114,7 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
>  	}
>  	if ((iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid)) ||
>  	    (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid))) {
> -		rc = dquot_transfer(inode, iattr);
> +		rc = dquot_transfer(inode, iattr, 0);
>  		if (rc)
>  			return rc;
>  	}
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index bfeb647459d9..d3cbf6467af6 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1259,7 +1259,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  			mlog_errno(status);
>  			goto bail_unlock;
>  		}
> -		status = __dquot_transfer(inode, transfer_to);
> +		status = __dquot_transfer(inode, transfer_to, 0);
>  		if (status < 0)
>  			goto bail_commit;
>  	} else {
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 48813aeaab80..16e13d554aaa 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1906,10 +1906,12 @@ EXPORT_SYMBOL(dquot_free_inode);
>   * We are holding reference on transfer_from & transfer_to, no need to
>   * protect them by srcu_read_lock().
>   */
> -int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
> +int __dquot_transfer(struct inode *inode, struct dquot **transfer_to,
> +		     int inodes_extra)
>  {
>  	qsize_t space, cur_space;
>  	qsize_t rsv_space = 0;
> +	qsize_t inode_count = 1 + inodes_extra;
>  	struct dquot *transfer_from[MAXQUOTAS] = {};
>  	int cnt, ret = 0;
>  	char is_valid[MAXQUOTAS] = {};
> @@ -1946,7 +1948,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>  			continue;
>  		is_valid[cnt] = 1;
>  		transfer_from[cnt] = i_dquot(inode)[cnt];
> -		ret = check_idq(transfer_to[cnt], 1, &warn_to[cnt]);
> +		ret = check_idq(transfer_to[cnt], inode_count, &warn_to[cnt]);
>  		if (ret)
>  			goto over_quota;
>  		ret = check_bdq(transfer_to[cnt], space, 0, &warn_to[cnt]);
> @@ -1963,7 +1965,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>  		/* Due to IO error we might not have transfer_from[] structure */
>  		if (transfer_from[cnt]) {
>  			int wtype;
> -			wtype = info_idq_free(transfer_from[cnt], 1);
> +			wtype = info_idq_free(transfer_from[cnt], inode_count);
>  			if (wtype != QUOTA_NL_NOWARN)
>  				prepare_warning(&warn_from_inodes[cnt],
>  						transfer_from[cnt], wtype);
> @@ -1971,13 +1973,13 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>  			if (wtype != QUOTA_NL_NOWARN)
>  				prepare_warning(&warn_from_space[cnt],
>  						transfer_from[cnt], wtype);
> -			dquot_decr_inodes(transfer_from[cnt], 1);
> +			dquot_decr_inodes(transfer_from[cnt], inode_count);
>  			dquot_decr_space(transfer_from[cnt], cur_space);
>  			dquot_free_reserved_space(transfer_from[cnt],
>  						  rsv_space);
>  		}
>  
> -		dquot_incr_inodes(transfer_to[cnt], 1);
> +		dquot_incr_inodes(transfer_to[cnt], inode_count);
>  		dquot_incr_space(transfer_to[cnt], cur_space);
>  		dquot_resv_space(transfer_to[cnt], rsv_space);
>  
> @@ -2005,7 +2007,7 @@ EXPORT_SYMBOL(__dquot_transfer);
>  /* Wrapper for transferring ownership of an inode for uid/gid only
>   * Called from FSXXX_setattr()
>   */
> -int dquot_transfer(struct inode *inode, struct iattr *iattr)
> +int dquot_transfer(struct inode *inode, struct iattr *iattr, int inodes_extra)
>  {
>  	struct dquot *transfer_to[MAXQUOTAS] = {};
>  	struct dquot *dquot;
> @@ -2037,7 +2039,7 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
>  		}
>  		transfer_to[GRPQUOTA] = dquot;
>  	}
> -	ret = __dquot_transfer(inode, transfer_to);
> +	ret = __dquot_transfer(inode, transfer_to, inodes_extra);
>  out_put:
>  	dqput_all(transfer_to);
>  	return ret;
> diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> index 873fc04e9403..51586051b5dd 100644
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -3370,7 +3370,7 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
>  		reiserfs_write_unlock(inode->i_sb);
>  		if (error)
>  			goto out;
> -		error = dquot_transfer(inode, attr);
> +		error = dquot_transfer(inode, attr, 0);
>  		reiserfs_write_lock(inode->i_sb);
>  		if (error) {
>  			journal_end(&th);
> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
> index dda22f45fc1b..b7bcd9c6db6c 100644
> --- a/include/linux/quotaops.h
> +++ b/include/linux/quotaops.h
> @@ -106,8 +106,9 @@ int dquot_get_next_dqblk(struct super_block *sb, struct kqid *id,
>  int dquot_set_dqblk(struct super_block *sb, struct kqid id,
>  		struct qc_dqblk *di);
>  
> -int __dquot_transfer(struct inode *inode, struct dquot **transfer_to);
> -int dquot_transfer(struct inode *inode, struct iattr *iattr);
> +int __dquot_transfer(struct inode *inode, struct dquot **transfer_to,
> +		int inodes_extra);
> +int dquot_transfer(struct inode *inode, struct iattr *iattr, int inodes_extra);
>  
>  static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
>  {
> @@ -226,7 +227,8 @@ static inline void dquot_free_inode(struct inode *inode)
>  {
>  }
>  
> -static inline int dquot_transfer(struct inode *inode, struct iattr *iattr)
> +static inline int dquot_transfer(struct inode *inode, struct iattr *iattr,
> +		int inodes_extra)
>  {
>  	return 0;
>  }
> -- 
> 2.13.0.219.gdb65acc882-goog
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
