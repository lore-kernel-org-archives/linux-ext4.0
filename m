From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext2_discard_prealloc() called on each iput?
Date: Tue, 29 May 2007 09:16:43 -0400
Message-ID: <20070529131643.GB9899@thunk.org>
References: <20070522161127.GC13633@duck.suse.cz> <20070523123743.GD5608@thunk.org> <20070529102544.GA25278@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55510 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbXE2NQq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2007 09:16:46 -0400
Content-Disposition: inline
In-Reply-To: <20070529102544.GA25278@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 29, 2007 at 12:25:45PM +0200, Jan Kara wrote:
> Fix a comment when ext2_release_file() is called.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

> diff -rupX /home/jack/.kerndiffexclude linux-2.6.21/fs/ext2/file.c linux-2.6.21-1-ext2_comment_fix/fs/ext2/file.c
> --- linux-2.6.21/fs/ext2/file.c	2007-05-15 14:18:47.000000000 +0200
> +++ linux-2.6.21-1-ext2_comment_fix/fs/ext2/file.c	2007-05-29 12:15:59.000000000 +0200
> @@ -24,9 +24,9 @@
>  #include "acl.h"
>  
>  /*
> - * Called when an inode is released. Note that this is different
> - * from ext2_open_file: open gets called at every open, but release
> - * gets called only when /all/ the files are closed.
> + * Called when filp is released. This happens when all file descriptors
> + * for a single struct file are closed. Note that different open() calls
> + * for the same file yield different struct file structures.
>   */
>  static int ext2_release_file (struct inode * inode, struct file * filp)
>  {
