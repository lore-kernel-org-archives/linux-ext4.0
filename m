From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 16/21 v5] e2fsck: add problem descriptions and check
 inline data feature
Date: Mon, 15 Oct 2012 07:34:15 +0800
Message-ID: <20121014233415.GA23130@gmail.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
 <1348286469-31690-17-git-send-email-wenqing.lz@taobao.com>
 <20121014132210.GB6207@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47431 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2JNXXO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Oct 2012 19:23:14 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so4380008pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 14 Oct 2012 16:23:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20121014132210.GB6207@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 14, 2012 at 09:22:10AM -0400, Theodore Ts'o wrote:
> Hi Zheng,
> 
> I was trying to apply these patches to the e2fsprogs pu branch, and as
> a matter of course, I ran checkpatch on the patch series.  The reason
> why it's useful is because it finds stuff like this:
> 
> WARNING: trailing semicolon indicates no statements, indent implies otherwise
> #156: FILE: lib/ext2fs/inline_data.c:567:
> +     if (retval);
> +     	 return pass;
> 
> ERROR: trailing statements should be on next line
> #156: FILE: lib/ext2fs/inline_data.c:567:
> +     if (retval);
> 
> > +int ext2fs_inline_data_header_check(ext2_filsys fs, ext2_ino_t ino)
> > +{
> > +	struct ext2_inode_large *inode;
> > +	struct inline_data data;
> > +	errcode_t retval = 0;
> > +	int pass = 0;
> > +
> > +	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
> > +	if (retval);
> > +		return pass;
> 
> This means the rest of ext2fs_inline_data_header_check() isn't getting
> executed, since the "return pass;" statement would get executed
> unconditionally.  I didn't try it, but I suspect "make gcc-wall"
> probably would have turned up this typo as well.
> 
> I'll fix this in my tree on the pu branch; I'm still looking over the
> rest of the patches, but I thought it would be good to point this out
> first.

Oops, it's my fault.  Thanks for pointing it out.

Regards,
Zheng
