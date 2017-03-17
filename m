From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] ext4: Add statx support
Date: Thu, 16 Mar 2017 22:47:55 -0700
Message-ID: <20170317054755.GA595@zzz>
References: <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35487 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdCQFsK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Mar 2017 01:48:10 -0400
Content-Disposition: inline
In-Reply-To: <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi David,

On Thu, Mar 16, 2017 at 11:35:33AM +0000, David Howells wrote:
> +
> +	ext4_get_inode_flags(ei);
> +	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
> +	if (flags & EXT4_APPEND_FL)
> +		stat->attributes |= STATX_ATTR_APPEND;
> +	if (flags & EXT4_COMPR_FL)
> +		stat->attributes |= STATX_ATTR_COMPRESSED;
> +	if (flags & EXT4_ENCRYPT_FL)
> +		stat->attributes |= STATX_ATTR_ENCRYPTED;
> +	if (flags & EXT4_IMMUTABLE_FL)
> +		stat->attributes |= STATX_ATTR_IMMUTABLE;
> +	if (flags & EXT4_NODUMP_FL)
> +		stat->attributes |= STATX_ATTR_NODUMP;
>  
> -	inode = d_inode(path->dentry);
>  	generic_fillattr(inode, stat);
> +	return 0;
> +}

I think it's the wrong approach to be calling ext4_get_inode_flags() here to
sync the generic inode flags (inode->i_flags) to the ext4-specific inode flags
(ei->i_flags).  I know the GETFLAGS and FSGETXATTR ioctls do it too, but I think
it's a mistake --- at least, when done so without holding the inode lock.  The
issue is that flag syncs can occur in both directions concurrently and cause an
update to be lost.  For example, with thread 1 doing a stat() and thread 2 doing
the SETFLAGS ioctl to set the APPEND flag:

	Thread 1, in ext4_get_inode_flags()	Thread 2, in ext4_ioctl_setflags()
	-----------------------------------    -----------------------------------

	Read inode->i_flags; S_APPEND is clear	
						Set EXT4_APPEND_FL in ei->i_flags
	Clear EXT4_APPEND_FL in ei->i_flags
						Read ei->i_flags; EXT4_APPEND_FL is clear
						Clear S_APPEND in inode->i_flags

So the flag set by SETFLAGS gets lost.  This bug probably hasn't really been
noticable with GETFLAGS and FSGETXATTR since they're rarely used, but stat() on
the other hand is very common, and I'm worried that with this change people
would start seeing this race more often.

Ultimately this needs to be addressed in ext4 more fully, but how about for
->getattr() just skipping the call to ext4_get_inode_flags() and instead
populating the generic attributes like STATX_ATTR_APPEND and
STATX_ATTR_IMMUTABLE from the generic inode flags, rather than from the
ext4-specific flags?  Actually, it could even be done in generic_fillattr(), so
that all filesystems benefit.

> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index 73b184d161fc..4c6b23a0603e 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -91,11 +91,13 @@ const struct inode_operations ext4_encrypted_symlink_inode_operations = {
>  const struct inode_operations ext4_symlink_inode_operations = {
>  	.get_link	= page_get_link,
>  	.setattr	= ext4_setattr,
> +	.getattr	= ext4_getattr,
>  	.listxattr	= ext4_listxattr,
>  };
>  
>  const struct inode_operations ext4_fast_symlink_inode_operations = {
>  	.get_link	= simple_get_link,
>  	.setattr	= ext4_setattr,
> +	.getattr	= ext4_getattr,
>  	.listxattr	= ext4_listxattr,
>  };
> 

getattr needs to be added to ext4_encrypted_symlink_inode_operations too.

- Eric
