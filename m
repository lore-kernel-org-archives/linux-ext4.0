From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ext2: conditional removal of NFSD code
Date: Sat, 6 Jan 2007 21:52:25 +0000
Message-ID: <20070106215225.GC17561@ftp.linux.org.uk>
References: <20070106195830.GA6711@martell.zuzino.mipt.ru> <20070106212540.GJ24620@parisc-linux.org> <20070106214456.GA5376@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew@wil.cx>, akpm@osdl.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Content-Disposition: inline
In-Reply-To: <20070106214456.GA5376@martell.zuzino.mipt.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jan 07, 2007 at 12:44:56AM +0300, Alexey Dobriyan wrote:
> > #if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
> > #define set_export_ops(sb, ops)		sb->s_export_op = ops
> > #else
> > #define set_export_ops(sb, ops)		0
> > #endif
> >
> > That way you can get rid of the function pointer from the struct
> > superblock too.
> 
> Exactly! I've just started with filesystems I use.
> 
> it should be wrapped in do {} while 0, of course.

What the hell for?  Repeat after me:
	* do {} while(0) is always inferior to ((void)0)
	* do { expr; } while(0) is always inferior to ((void)(expr))
