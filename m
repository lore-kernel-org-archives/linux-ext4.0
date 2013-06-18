From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Reduce object size when !CONFIG_PRINTK
Date: Tue, 18 Jun 2013 11:14:38 -0400
Message-ID: <20130618151438.GC7359@thunk.org>
References: <a629c1c6359886419e24179dbb04484a88e6b0f2.1370400427.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-embedded@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59034 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab3FRPOn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jun 2013 11:14:43 -0400
Content-Disposition: inline
In-Reply-To: <a629c1c6359886419e24179dbb04484a88e6b0f2.1370400427.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 04, 2013 at 07:55:05PM -0700, Joe Perches wrote:
> Reduce the object size ~10% could be useful for embedded
> systems.
> 
> Add #ifdef CONFIG_PRINTK #else #endif blocks
> to hold formats and arguments, passing " " to
> functions when !CONFIG_PRINTK and still verifying
> format and arguments with no_printk.
> 
> $ size fs/ext4/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  239375	    610	    888	 240873	  3ace9	fs/ext4/built-in.o.new
>  264167	    738	    888	 265793	  40e41	fs/ext4/built-in.o.old
> 
>     $ grep -E "CONFIG_EXT4|CONFIG_PRINTK" .config
>     # CONFIG_PRINTK is not set
>     CONFIG_EXT4_FS=y
>     CONFIG_EXT4_USE_FOR_EXT23=y
>     CONFIG_EXT4_FS_POSIX_ACL=y
>     # CONFIG_EXT4_FS_SECURITY is not set
>     # CONFIG_EXT4_DEBUG is not set
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

					- Ted
