From: Calvin Owens <jcalvinowens@gmail.com>
Subject: Re: e2fsprogs: Fsck of read-only FS w/ external journal fails after
 1.42.5?
Date: Sat, 4 May 2013 19:33:32 -0500
Message-ID: <20130505003332.GA21178@gmail.com>
References: <20130504195350.GA20046@gmail.com>
 <20130504233307.GB5948@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ye0-f176.google.com ([209.85.213.176]:42281 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3EEAdh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 May 2013 20:33:37 -0400
Received: by mail-ye0-f176.google.com with SMTP id r9so329676yen.7
        for <linux-ext4@vger.kernel.org>; Sat, 04 May 2013 17:33:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130504233307.GB5948@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday 05/04 at 19:33 -0400, Theodore Ts'o wrote:
> On Sat, May 04, 2013 at 02:53:50PM -0500, Calvin Owens wrote:
> > 
> > Commit a85f8350 (http://goo.gl/aCykm) makes it impossible to fsck an
> > ext4 filesystem w/ external journal if it is mounted read-only. Certain
> > distros (Gentoo in my case) expect to be able to do this on the root
> > filesystem at boot time, and get very upset if they can't.
> 
> The fact that e2fsck would working with root file systems with an
> external journal between commits 47c1b8e166 and a85f8350 was by accident.
> Can you try this patch?  This should allow external journals on the
> root file system to work properly.
> 
> 						- Ted

Tested - your patch fixes the issue.

Thanks,
Calvin

> 
> From 26991d026e4b555229a4466ae4d003420321bbd2 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sat, 4 May 2013 19:07:18 -0400
> Subject: [PATCH] e2fsck: don't use IO_FLAG_EXCLUSIVE for read-only root file
>  systems
> 
> When opening the external journal, use the same logic to decide
> whether or not to open the file system with EXT2_FLAG_EXCLUSIVE found
> in main().
> 
> Otherwise, it's not posible to use e2fsck when the root file system is
> using an external journal.
> 
> Reported-by: Calvin Owens <jcalvinowens@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  e2fsck/journal.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index 767ea10..69771da 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -372,9 +372,19 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
>  #ifndef USE_INODE_IO
>  	if (ext_journal)
>  #endif
> -		retval = io_ptr->open(journal_name,
> -				      IO_FLAG_RW | IO_FLAG_EXCLUSIVE,
> +	{
> +		int flags = IO_FLAG_RW;
> +		if (!(ctx->mount_flags & EXT2_MF_ISROOT &&
> +		      ctx->mount_flags & EXT2_MF_READONLY))
> +			flags |= IO_FLAG_EXCLUSIVE;
> +		if ((ctx->mount_flags & EXT2_MF_READONLY) &&
> +		    (ctx->options & E2F_OPT_FORCE))
> +			flags &= ~IO_FLAG_EXCLUSIVE;
> +
> +
> +		retval = io_ptr->open(journal_name, flags,
>  				      &ctx->journal_io);
> +	}
>  	if (retval)
>  		goto errout;
>  
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
