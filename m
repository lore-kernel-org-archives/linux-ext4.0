From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] ext2: conditional removal of NFSD code
Date: Sun, 7 Jan 2007 00:44:56 +0300
Message-ID: <20070106214456.GA5376@martell.zuzino.mipt.ru>
References: <20070106195830.GA6711@martell.zuzino.mipt.ru> <20070106212540.GJ24620@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@osdl.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:35136 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbXAFVpB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Jan 2007 16:45:01 -0500
Received: by nf-out-0910.google.com with SMTP id o25so8897370nfa
        for <linux-ext4@vger.kernel.org>; Sat, 06 Jan 2007 13:45:00 -0800 (PST)
To: Matthew Wilcox <matthew@wil.cx>
Content-Disposition: inline
In-Reply-To: <20070106212540.GJ24620@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 06, 2007 at 02:25:40PM -0700, Matthew Wilcox wrote:
> On Sat, Jan 06, 2007 at 10:58:31PM +0300, Alexey Dobriyan wrote:
> > Nor me nor my box is going to act as NFS server, so ifdef all
> > exporting code.
>
> > @@ -916,7 +918,9 @@ static int ext2_fill_super(struct super_
> >  	 * set up enough so that it can read an inode
> >  	 */
> >  	sb->s_op = &ext2_sops;
> > +#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
> >  	sb->s_export_op = &ext2_export_ops;
> > +#endif
>
> To avoid putting ifdefs within a function, how about adding:
>
> #if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
> #define set_export_ops(sb, ops)		sb->s_export_op = ops
> #else
> #define set_export_ops(sb, ops)		0
> #endif
>
> That way you can get rid of the function pointer from the struct
> superblock too.

Exactly! I've just started with filesystems I use.

it should be wrapped in do {} while 0, of course.

> But Dave Woodhouse is going to kill you for adding another
> CONFIG_*_MODULE dependency.

I missed a flamewar on this topic?
