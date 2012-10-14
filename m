From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/21 v5] e2fsck: add problem descriptions and check
 inline data feature
Date: Sun, 14 Oct 2012 09:22:10 -0400
Message-ID: <20121014132210.GB6207@thunk.org>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
 <1348286469-31690-17-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55436 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab2JNOlx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:53 -0400
Content-Disposition: inline
In-Reply-To: <1348286469-31690-17-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zheng,

I was trying to apply these patches to the e2fsprogs pu branch, and as
a matter of course, I ran checkpatch on the patch series.  The reason
why it's useful is because it finds stuff like this:

WARNING: trailing semicolon indicates no statements, indent implies otherwise
#156: FILE: lib/ext2fs/inline_data.c:567:
+     if (retval);
+     	 return pass;

ERROR: trailing statements should be on next line
#156: FILE: lib/ext2fs/inline_data.c:567:
+     if (retval);

> +int ext2fs_inline_data_header_check(ext2_filsys fs, ext2_ino_t ino)
> +{
> +	struct ext2_inode_large *inode;
> +	struct inline_data data;
> +	errcode_t retval = 0;
> +	int pass = 0;
> +
> +	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
> +	if (retval);
> +		return pass;

This means the rest of ext2fs_inline_data_header_check() isn't getting
executed, since the "return pass;" statement would get executed
unconditionally.  I didn't try it, but I suspect "make gcc-wall"
probably would have turned up this typo as well.

I'll fix this in my tree on the pu branch; I'm still looking over the
rest of the patches, but I thought it would be good to point this out
first.

Cheers,

					- Ted
