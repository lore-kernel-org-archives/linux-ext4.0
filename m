From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix quota charging for shared xattr blocks
Date: Tue, 23 May 2017 10:10:55 +0200
Message-ID: <20170523081055.GB1230@quack2.suse.cz>
References: <20170523030148.24361-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170523030148.24361-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 22-05-17 20:01:48, Tahsin Erdogan wrote:
> ext4_xattr_block_set() calls dquot_alloc_block() to charge for an xattr
> block when new references are made. However if dquot_initialize() hasn't
> been called on an inode, request for charging is effectively ignored
> because ext4_inode_info->i_dquot is not initialized yet.
> 
> Add dquot_initialize() call to ext4_xattr_set_handle().

Thanks for finding the bug! However this is a wrong place where to insert
dquot_initialize(). Generally we try really hard to do dquot_initalize()
calls outside of a transaction (as they may have pretty big requirements on
the amount of transaction credits - and for your patch to be correct you'd
have to update credit estimates for each possible transaction involved). So
you should rather place these calls into ext4_xattr_set(), ext4_set_acl(),
ext4_set_context() (only in the case when transaction needs to be started
before starting it). You can then add a warning in ext4_xattr_set_handle()
checking whether quota is indeed initialized as expected.

								Honza

> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
>  fs/ext4/xattr.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 8fb7ce14e6eb..e94575448550 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1166,6 +1166,11 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
>  		return -EINVAL;
>  	if (strlen(name) > 255)
>  		return -ERANGE;
> +
> +	error = dquot_initialize(inode);
> +	if (error)
> +		return error;
> +
>  	ext4_write_lock_xattr(inode, &no_expand);
>  
>  	error = ext4_reserve_inode_write(handle, inode, &is.iloc);
> -- 
> 2.13.0.219.gdb65acc882-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
