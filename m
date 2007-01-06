From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] ext2: conditional removal of NFSD code
Date: Sat, 6 Jan 2007 14:25:40 -0700
Message-ID: <20070106212540.GJ24620@parisc-linux.org>
References: <20070106195830.GA6711@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@osdl.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Content-Disposition: inline
In-Reply-To: <20070106195830.GA6711@martell.zuzino.mipt.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 06, 2007 at 10:58:31PM +0300, Alexey Dobriyan wrote:
> Nor me nor my box is going to act as NFS server, so ifdef all
> exporting code.

> @@ -916,7 +918,9 @@ static int ext2_fill_super(struct super_
>  	 * set up enough so that it can read an inode
>  	 */
>  	sb->s_op = &ext2_sops;
> +#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
>  	sb->s_export_op = &ext2_export_ops;
> +#endif

To avoid putting ifdefs within a function, how about adding:

#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
#define set_export_ops(sb, ops)		sb->s_export_op = ops
#else
#define set_export_ops(sb, ops)		0
#endif

That way you can get rid of the function pointer from the struct
superblock too.

But Dave Woodhouse is going to kill you for adding another
CONFIG_*_MODULE dependency.
