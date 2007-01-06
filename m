From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] ext2: conditional removal of NFSD code
Date: Sat, 6 Jan 2007 13:35:32 -0800
Message-ID: <20070106133532.8d5ddcb8.akpm@osdl.org>
References: <20070106195830.GA6711@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20070106195830.GA6711@martell.zuzino.mipt.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 6 Jan 2007 22:58:31 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Nor me nor my box is going to act as NFS server, so ifdef all
> exporting code.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  fs/ext2/namei.c |    2 ++
>  fs/ext2/super.c |    4 ++++
>  2 files changed, 6 insertions(+)
> 
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -70,6 +70,7 @@ static struct dentry *ext2_lookup(struct
>  	return d_splice_alias(inode, dentry);
>  }
>  
> +#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
>  struct dentry *ext2_get_parent(struct dentry *child)
>  {
>  	unsigned long ino;
> @@ -94,6 +95,7 @@ struct dentry *ext2_get_parent(struct de
>  	}
>  	return parent;
>  } 
> +#endif
>  
>  /*
>   * By the time this is called, we already have created
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -250,6 +250,7 @@ #ifdef CONFIG_QUOTA
>  #endif
>  };
>  
> +#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
>  static struct dentry *ext2_get_dentry(struct super_block *sb, void *vobjp)
>  {
>  	__u32 *objp = vobjp;
> @@ -297,6 +298,7 @@ static struct export_operations ext2_exp
>  	.get_parent = ext2_get_parent,
>  	.get_dentry = ext2_get_dentry,
>  };
> +#endif
>  
>  static unsigned long get_sb_block(void **data)
>  {
> @@ -916,7 +918,9 @@ static int ext2_fill_super(struct super_
>  	 * set up enough so that it can read an inode
>  	 */
>  	sb->s_op = &ext2_sops;
> +#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
>  	sb->s_export_op = &ext2_export_ops;
> +#endif
>  	sb->s_xattr = ext2_xattr_handlers;
>  	root = iget(sb, EXT2_ROOT_INO);
>  	sb->s_root = d_alloc_root(root);
> 

The linker will remove unreferenced static functions from vmlinux.  So a
better approach would be to move ext2_get_parent into super.c, make it
static and do Matthew's trick, yielding zero ifdefs.

That has the additional advantage that the nfsd-supporting code will always
be compiled.

