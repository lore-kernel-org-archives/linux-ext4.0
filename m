From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/35 v3] libext2fs: add EXT4_INLINE_DATA_FL flag for
 inode
Date: Mon, 16 Jul 2012 11:01:44 -0400
Message-ID: <20120716150144.GA3670@thunk.org>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
 <1341150538-32047-6-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39304 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab2GPPBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2012 11:01:47 -0400
Content-Disposition: inline
In-Reply-To: <1341150538-32047-6-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 01, 2012 at 09:48:28PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Add EXT4_INLINE_DATA_FL flag.
> 
>  /* EXT4_EOFBLOCKS_FL 0x00400000 was here */
> +#define EXT4_INLINE_DATA_FL		0x00800000 /* Inode has inline data */

Hi,

Unfortunately, we have a codepoint collision.  The BTRFS folks have
already exposed FS_NOCOW_FL as 0x00800000; this is in mainline in the
kernel, and in fact that latest version of e2fsprogs understands this
since lsattr and chattr are used by multiple file systems (even though
it was originally intended only for ext2/3/4).

I'd like to move this to:

#define EXT4_INLINE_DATA_FL	0x10000000 /* Inode has inline data */

However, if you already have this in production internally inside
Taobao, this could potentially could be a problem for you.  (We've had
to handle this before inside Google, when we used a different code
point for EOFBLOCKS_FL than what ended up being used in mainline; it
can be dealt with, but it's certainly annoying...)

Is this going to potentially be a problem for you?

Regards,

						- Ted
