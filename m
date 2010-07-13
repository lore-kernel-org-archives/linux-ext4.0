From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext2: return -ENODATA for NULL i_file_acl in ext2_xattr_list
Date: Tue, 13 Jul 2010 12:36:54 -0600
Message-ID: <7D4617C2-565E-4F34-94B4-3F308EB75D18@dilger.ca>
References: <4C3C7E59.8040905@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: kernel-janitors <kernel-janitors@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Wang Sheng-Hui <crosslonelyover@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C3C7E59.8040905@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2010-07-13, at 08:55, Wang Sheng-Hui wrote:
> In ext2_xattr_list, if (!EXT2_I(inode)->i_file_acl)
> is true, we should return -ENODATA instead of 0.
> 
> @@ -263,7 +263,7 @@ ext2_xattr_list(struct dentry *dentry, char *buffer,
>          size_t buffer_size)
> 
>          down_read(&EXT2_I(inode)->xattr_sem);
> -        error = 0;
> +        error = -ENODATA;
>          if (!EXT2_I(inode)->i_file_acl)
>                  goto cleanup;
>          ea_idebug(inode, "reading block %d", EXT2_I(inode)->i_file_acl);

The "error" value gets overwritten almost immediately with -EIO, and then at the end of the function if there is an xattr block but it doesn't contain any attributes (I'm not sure if this could happen, but it seems possible) it will return "error = buffer_size - rest;  /* total size */", so 0 if "rest" was not changed from its initial value of buffer_size.

The question is why this return value should be changed to -ENODATA in the first place?  This isn't true for ext3_xattr_list() or ext4_xattr_list().  I tend to think it is not an error to get back an empty list, and applications shouldn't treat it as such.  Most applications will check "if (rc < 0)" and treat it as an error.  This is different than e.g. requesting a specific value by name (which does return -ENODATA) because it would otherwise be ambiguous whether the xattr existed but had zero size or didn't exist at all.

Cheers, Andreas
