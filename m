From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/11] ext4: Set flags on quota files directly
Date: Thu, 13 Apr 2017 10:01:55 +0200
Message-ID: <20170413080155.GA21025@quack2.suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
 <20170412072611.29017-2-jack@suse.cz>
 <BDA95568-149C-4049-AFE0-0D7AB483CFB6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BDA95568-149C-4049-AFE0-0D7AB483CFB6@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 12-04-17 15:00:04, Andreas Dilger wrote:
> On Apr 12, 2017, at 1:26 AM, Jan Kara <jack@suse.cz> wrote:
> > @@ -5344,11 +5365,28 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
> > 		if (err)
> > 			return err;
> > 	}
> > +
> > 	lockdep_set_quota_inode(path->dentry->d_inode, I_DATA_SEM_QUOTA);
> > 	err = dquot_quota_on(sb, type, format_id, path);
> > -	if (err)
> > +	if (err) {
> > 		lockdep_set_quota_inode(path->dentry->d_inode,
> > 					     I_DATA_SEM_NORMAL);
> > +	} else {
> > +		struct inode *inode = d_inode(path->dentry);
> > +		handle_t *handle;
> > +
> > +		inode_lock(inode);
> > +		handle = ext4_journal_start(inode, EXT4_HT_QUOTA, 1);
> > +		if (IS_ERR(handle))
> > +			goto unlock_inode;
> > +		EXT4_I(inode)->i_flags |= EXT4_NOATIME_FL | EXT4_IMMUTABLE_FL;
> > +		inode_set_flags(inode, S_NOATIME | S_IMMUTABLE,
> > +				S_NOATIME | S_IMMUTABLE);
> > +		ext4_mark_inode_dirty(handle, inode);
> > +		ext4_journal_stop(handle);
> 
> Should this be conditional on these flags not already being set?  Otherwise
> it dirties the filesystem on every mount even if it isn't needed.

Well, this doesn't happen on mount but on Q_QUOTAON quotactl and only when
INCOMPAT_QUOTA feature is not enabled (i.e., we are using legacy quota
support). Also the flags are not expected to be set as userspace
quota-tools (most notably quotacheck) need to write to quota files when
kernel isn't using them.

> > @@ -5422,24 +5460,36 @@ static int ext4_quota_off(struct super_block *sb, int type)
> > {
> > 	struct inode *inode = sb_dqopt(sb)->files[type];
> > 	handle_t *handle;
> > +	int err;
> > 
> > 	/* Force all delayed allocation blocks to be allocated.
> > 	 * Caller already holds s_umount sem */
> > 	if (test_opt(sb, DELALLOC))
> > 		sync_filesystem(sb);
> > 
> > -	if (!inode)
> > +	if (!inode || !igrab(inode))
> > 		goto out;
> > 
> > +	err = dquot_quota_off(sb, type);
> > +	if (err)
> > +		goto out_put;
> > +
> > +	inode_lock(inode);
> > 	/* Update modification times of quota files when userspace can
> > 	 * start looking at them */
> > 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA, 1);
> > 	if (IS_ERR(handle))
> > -		goto out;
> > +		goto out_unlock;
> > +	EXT4_I(inode)->i_flags &= ~(EXT4_NOATIME_FL | EXT4_IMMUTABLE_FL);
> > +	inode_set_flags(inode, 0, S_NOATIME | S_IMMUTABLE);
> 
> It isn't obvious that we need to clear these flags at every unmount?  I
> don't think there is a good reason to be modifying the quota files from
> userspace, and e2fsck won't care about these flags anyway when fixing
> the quota files.

Remember we are in the case of legacy quota support. In that case e2fsck
doesn't touch quota files and quotacheck is used instead to put quota files
in sync with what is in the filesystem. Also tools like setquota directly
modify quota files when kernel isn't using them. So we must clear the flags
on quotaoff to keep all this working.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
