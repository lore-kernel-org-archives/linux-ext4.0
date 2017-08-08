From: Jan Kara <jack@suse.cz>
Subject: Re: FAILED: patch "[PATCH] ext4: Don't clear SGID when inheriting
 ACLs" failed to apply to 4.12-stable tree
Date: Tue, 8 Aug 2017 14:06:24 +0200
Message-ID: <20170808120624.GC20321@quack2.suse.cz>
References: <1502142294145252@kroah.com>
 <20170808113651.GB20321@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, agruenba@redhat.com, tytso@mit.edu,
        stable@vger.kernel.org, linux-ext4@vger.kernel.org
To: gregkh@linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752702AbdHHMGg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Aug 2017 08:06:36 -0400
Content-Disposition: inline
In-Reply-To: <20170808113651.GB20321@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 08-08-17 13:36:51, Jan Kara wrote:
> On Mon 07-08-17 14:44:54, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.12-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Greg, I think you need to pick up also commit 397e434176bb "ext4: preserve
> i_mode if __ext4_set_acl() fails" which was not marked for stable but
> changes that function and probably it makes sense in stable as well.

Hum, I've found out even with this patch the changes need some massaging
due to context changes. I'll send backports once they are tested.

								Honza

> > ------------------ original commit in Linus's tree ------------------
> > 
> > From a3bb2d5587521eea6dab2d05326abb0afb460abd Mon Sep 17 00:00:00 2001
> > From: Jan Kara <jack@suse.cz>
> > Date: Sun, 30 Jul 2017 23:33:01 -0400
> > Subject: [PATCH] ext4: Don't clear SGID when inheriting ACLs
> > 
> > When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
> > set, DIR1 is expected to have SGID bit set (and owning group equal to
> > the owning group of 'DIR0'). However when 'DIR0' also has some default
> > ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
> > 'DIR1' to get cleared if user is not member of the owning group.
> > 
> > Fix the problem by moving posix_acl_update_mode() out of
> > __ext4_set_acl() into ext4_set_acl(). That way the function will not be
> > called when inheriting ACLs which is what we want as it prevents SGID
> > bit clearing and the mode has been properly set by posix_acl_create()
> > anyway.
> > 
> > Fixes: 073931017b49d9458aa351605b43a7e34598caef
> > CC: stable@vger.kernel.org
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
> > 
> > diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> > index 2985cd0a640d..46ff2229ff5e 100644
> > --- a/fs/ext4/acl.c
> > +++ b/fs/ext4/acl.c
> > @@ -189,18 +189,10 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
> >  	void *value = NULL;
> >  	size_t size = 0;
> >  	int error;
> > -	int update_mode = 0;
> > -	umode_t mode = inode->i_mode;
> >  
> >  	switch (type) {
> >  	case ACL_TYPE_ACCESS:
> >  		name_index = EXT4_XATTR_INDEX_POSIX_ACL_ACCESS;
> > -		if (acl) {
> > -			error = posix_acl_update_mode(inode, &mode, &acl);
> > -			if (error)
> > -				return error;
> > -			update_mode = 1;
> > -		}
> >  		break;
> >  
> >  	case ACL_TYPE_DEFAULT:
> > @@ -224,11 +216,6 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
> >  	kfree(value);
> >  	if (!error) {
> >  		set_cached_acl(inode, type, acl);
> > -		if (update_mode) {
> > -			inode->i_mode = mode;
> > -			inode->i_ctime = current_time(inode);
> > -			ext4_mark_inode_dirty(handle, inode);
> > -		}
> >  	}
> >  
> >  	return error;
> > @@ -240,6 +227,8 @@ ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >  	handle_t *handle;
> >  	int error, credits, retries = 0;
> >  	size_t acl_size = acl ? ext4_acl_size(acl->a_count) : 0;
> > +	umode_t mode = inode->i_mode;
> > +	int update_mode = 0;
> >  
> >  	error = dquot_initialize(inode);
> >  	if (error)
> > @@ -254,7 +243,20 @@ ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >  	if (IS_ERR(handle))
> >  		return PTR_ERR(handle);
> >  
> > +	if ((type == ACL_TYPE_ACCESS) && acl) {
> > +		error = posix_acl_update_mode(inode, &mode, &acl);
> > +		if (error)
> > +			goto out_stop;
> > +		update_mode = 1;
> > +	}
> > +
> >  	error = __ext4_set_acl(handle, inode, type, acl, 0 /* xattr_flags */);
> > +	if (!error && update_mode) {
> > +		inode->i_mode = mode;
> > +		inode->i_ctime = current_time(inode);
> > +		ext4_mark_inode_dirty(handle, inode);
> > +	}
> > +out_stop:
> >  	ext4_journal_stop(handle);
> >  	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> >  		goto retry;
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
