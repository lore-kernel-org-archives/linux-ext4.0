From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/34] debugfs: add LIBINTL to debugfs link command
Date: Fri, 17 Oct 2014 14:07:37 -0700
Message-ID: <20141017210737.GA13081@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221152.13646.7986.stgit@birch.djwong.org>
 <20140919044601.GI26995@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49343 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaJQVHo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2014 17:07:44 -0400
Content-Disposition: inline
In-Reply-To: <20140919044601.GI26995@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 19, 2014 at 12:46:01AM -0400, Theodore Ts'o wrote:
> On Sat, Sep 13, 2014 at 03:11:52PM -0700, Darrick J. Wong wrote:
> > Since debugfs now links in the journal code (which in turn depends on
> > internationalization libraries) we must add a linker option to pull
> > that in on Mac OSX.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The dependency on the internationalization libraries wasn't caused by
> the journal code.  It was caused by create_inode.h pulling in
> nls-enable.h indiscriminately.  The following should fix things (I'll
> check this in alongside some other patches needed to allow e2fsprogs
> to build under dietlibc):

True, but since debugfs pulls in plausible.o which uses _(), it still needs
this patch to build on OSX 10.9.5.

--D

> 
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index 7f57979..cf7c097 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -17,6 +17,7 @@
>  #endif
>  
>  #include "create_inode.h"
> +#include "nls-enable.h"
>  
>  #if __STDC_VERSION__ < 199901L
>  # if __GNUC__ >= 2
> diff --git a/misc/create_inode.h b/misc/create_inode.h
> index 067bf96..145fd57 100644
> --- a/misc/create_inode.h
> +++ b/misc/create_inode.h
> @@ -7,7 +7,6 @@
>  #include "et/com_err.h"
>  #include "e2p/e2p.h"
>  #include "ext2fs/ext2fs.h"
> -#include "nls-enable.h"
>  
>  struct hdlink_s
>  {
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 69045b2..f09351d 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -58,6 +58,7 @@ extern int optind;
>  #include "quota/quotaio.h"
>  #include "mke2fs.h"
>  #include "create_inode.h"
> +#include "nls-enable.h"
>  
>  #define STRIDE_LENGTH 8
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
