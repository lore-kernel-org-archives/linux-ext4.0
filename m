From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 deadlocks
Date: Wed, 08 Oct 2008 09:57:35 -0500
Message-ID: <48ECCA5F.4070905@redhat.com>
References: <48EBB9E9.4030105@goop.org> <48EBC6B9.7000608@sandeen.net> <20081007214637.GA2009@webber.adilger.int> <1223441351.4007.137.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@Sun.COM>,
	Eric Sandeen <sandeen@sandeen.net>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755871AbYJHO56@vger.kernel.org>
In-Reply-To: <1223441351.4007.137.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kalpak Shah wrote:

> ext4_xattr_set_handle() eventually ends up calling
> ext4_mark_inode_dirty() which tries to expand the inode by shifting the
> EAs. This leads to the xattr_sem being downed again and leading to a
> deadlock.
> 
> This patch makes sure that if ext4_xattr_set_handle() is in the
> call-chain, ext4_mark_inode_dirty() will not expand the inode.
> 
> Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

Yes, this fixes my testcase.  Thanks, Kalpak.

-Eric

> Index: linux-2.6.27-rc7/fs/ext4/xattr.c
> ===================================================================
> --- linux-2.6.27-rc7.orig/fs/ext4/xattr.c
> +++ linux-2.6.27-rc7/fs/ext4/xattr.c
> @@ -959,6 +959,7 @@ ext4_xattr_set_handle(handle_t *handle, 
>  	struct ext4_xattr_block_find bs = {
>  		.s = { .not_found = -ENODATA, },
>  	};
> +	unsigned long no_expand;
>  	int error;
>  
>  	if (!name)
> @@ -966,6 +967,9 @@ ext4_xattr_set_handle(handle_t *handle, 
>  	if (strlen(name) > 255)
>  		return -ERANGE;
>  	down_write(&EXT4_I(inode)->xattr_sem);
> +	no_expand = EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND;
> +	EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
> +
>  	error = ext4_get_inode_loc(inode, &is.iloc);
>  	if (error)
>  		goto cleanup;
> @@ -1042,6 +1046,8 @@ ext4_xattr_set_handle(handle_t *handle, 
>  cleanup:
>  	brelse(is.iloc.bh);
>  	brelse(bs.bh);
> +	if (no_expand == 0)
> +		EXT4_I(inode)->i_state &= ~EXT4_STATE_NO_EXPAND;
>  	up_write(&EXT4_I(inode)->xattr_sem);
>  	return error;
>  }
> 
> Thanks,
> Kalpak
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
