From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] ext2: conditional removal of NFSD code
Date: Sat, 6 Jan 2007 12:16:11 -0800
Message-ID: <20070106121611.34485a4c.akpm@osdl.org>
References: <20070106195830.GA6711@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Neil Brown <neilb@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20070106195830.GA6711@martell.zuzino.mipt.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 6 Jan 2007 22:58:31 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -70,6 +70,7 @@ static struct dentry *ext2_lookup(struct
>  	return d_splice_alias(inode, dentry);
>  }
>  
> +#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
>  struct dentry *ext2_get_parent(struct dentry *child)

hm.  Officially, one module isn't supposed to know about the presence of
another one at compile-time.  Someone might want to come along and later
configure and compile the nfsd module and then try to load it into a kernel
which wasn't compiled with nfsd enabled.

But given that both modules are in mainline I suspect that nobody would
really be doing that in practice, and in the case of nfsd it might not even
work.

