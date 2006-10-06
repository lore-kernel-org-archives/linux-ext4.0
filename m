From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: + ext4-enable.patch added to -mm tree
Date: Thu, 5 Oct 2006 21:59:41 -0700
Message-ID: <20061005215941.f0681c66.rdunlap@xenotime.net>
References: <200610060036.k960aB76011550@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, shaggy@austin.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:20948 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751796AbWJFE6O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 00:58:14 -0400
Received: from midway.site ([71.117.236.95]) by xenotime.net for <linux-ext4@vger.kernel.org>; Thu, 5 Oct 2006 21:58:12 -0700
To: akpm@osdl.org, linux-ext4@vger.kernel.org
In-Reply-To: <200610060036.k960aB76011550@shell0.pdx.osdl.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 05 Oct 2006 17:36:11 -0700 akpm@osdl.org wrote:

> Subject: ext4: enable building of ext4
> From: Mingming Cao<cmm@us.ibm.com>
> 
> Originally part of a patch from Mingming Cao and Randy Dunlap.  Reorganized
> by Shaggy.
> ---
> 
>  fs/Kconfig            |   75 +++++++++++++++++++++++++++++++++++++---
>  fs/Makefile           |    1 
>  include/linux/magic.h |    1 
>  3 files changed, 73 insertions(+), 4 deletions(-)
> 
> diff -puN fs/Kconfig~ext4-enable fs/Kconfig
> --- a/fs/Kconfig~ext4-enable
> +++ a/fs/Kconfig
> @@ -140,6 +140,73 @@ config EXT3_FS_SECURITY
>  	  If you are not using a security module that requires using
>  	  extended attributes for file security labels, say N.
>  
> +config EXT4DEV_FS
> +	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL
> +        select JBD
> +        help

ugh, I'm getting seasick from looking at that indentation.
I don't have an ext4 patchset ATM, but I'll fix that if no one
else does.

> +	  Ext4dev is a predecessor filesystem of the next generation
> +	  extended fs ext4, based on ext3 filesystem code. It will be
> +	  renamed ext4 fs later, once ext4dev is mature and stabilized.
> +
> +          Unlike the change from ext2 filesystem to ext3 filesystem,
> +          the on-disk format of ext4dev is not the same as ext3 any more:
> +	  it is based on extent maps and it supports 48-bit physical block
> +          numbers. These combined on-disk format changes will allow
> +	  ext4dev/ext4 to handle more than 16 TB filesystem volumes --
> +	  a hard limit that ext3 cannot overcome without changing the
> +          on-disk format.
> +
> +	  Other than extent maps and 48-bit block numbers, ext4dev also is
> +          likely to have other new features such as persistent preallocation,
> +	  high resolution time stamps, and larger file support etc.  These
> +          features will be added to ext4dev gradually.
> +
> +	  To compile this file system support as a module, choose M here. The
> +	  module will be called ext4dev.  Be aware, however, that the filesystem
> +	  of your root partition (the one containing the directory /) cannot
> +	  be compiled as a module, and so this could be dangerous.
> +
> +	  If unsure, say N.

---
~Randy
