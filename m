From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -V4 08/11] vfs: Add new file and directory create
 permission flags
Date: Sun, 2 Jan 2011 18:21:01 -0500
Message-ID: <20110102232101.GB11955@thunk.org>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1285332494-12756-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100924115423.530813c3@tlielax.poochiereds.net>
 <201009271514.00279.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com,
	sandeen@redhat.com, bfields@citi.umich.edu,
	linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201009271514.00279.agruen@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I was going through some old patches in the ext4 patchwork list, and
came across this.  It looks like this patch has never been applied to
mainline.  If it's a "clear improvement", any reason not to submit it?

Regards,

	      	     	    		      - Ted

On Mon, Sep 27, 2010 at 03:14:00PM +0200, Andreas Gruenbacher wrote:
> 
> Ah, you mean this:
> 
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2450,7 +2450,9 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
>  	if (!inode)
>  		return -ENOENT;
>  
> -	error = may_create(dir, new_dentry, S_ISDIR(inode->i_mode));
> +	if (S_ISDIR(inode->i_mode))
> +		return -EPERM;
> +	error = may_create(dir, new_dentry, 0);
>  	if (error)
>  		return error;
>  
> @@ -2464,8 +2466,6 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
>  		return -EPERM;
>  	if (!dir->i_op->link)
>  		return -EPERM;
> -	if (S_ISDIR(inode->i_mode))
> -		return -EPERM;
>  
>  	error = security_inode_link(old_dentry, dir, new_dentry);
>  	if (error)
> 
> This is a clear improvement; I don't think it matters that user-space will
> get -EPERM instead of -EXDEV when trying to hard-link a directory across
> devices.
> 
> Thanks,
> Andreas
