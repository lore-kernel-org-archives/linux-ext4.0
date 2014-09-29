From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 10/10] Add "hash_alg=siphash" support
Date: Mon, 29 Sep 2014 12:24:26 -0700
Message-ID: <20140929192426.GO10150@birch.djwong.org>
References: <20140923100214.26896.qmail@ns.horizon.com>
 <20140923103106.18356.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50701 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaI2TYg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2014 15:24:36 -0400
Content-Disposition: inline
In-Reply-To: <20140923103106.18356.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 23, 2014 at 06:31:06AM -0400, George Spelvin wrote:
> The #define name refers specifically to SipHash-2-4, but keep the
> parameter name short.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
> The other half of the implementation.

Looks reasonable, but are there test cases for e2fsprogs?

--D

> 
>  lib/e2p/hashstr.c     | 1 +
>  misc/mke2fs.conf.5.in | 3 ++-
>  misc/tune2fs.8.in     | 3 ++-
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/e2p/hashstr.c b/lib/e2p/hashstr.c
> index a73758c..bd4a8da 100644
> --- a/lib/e2p/hashstr.c
> +++ b/lib/e2p/hashstr.c
> @@ -27,6 +27,7 @@ static struct hash hash_list[] = {
>  	{	EXT2_HASH_LEGACY, 	"legacy" },
>  	{	EXT2_HASH_HALF_MD4, 	"half_md4" },
>  	{	EXT2_HASH_TEA, 		"tea" },
> +	{	EXT2_HASH_SIPHASH24,	"siphash" },
>  	{	0, 0 },
>  };
>  
> diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
> index ad6c11b..257bddd 100644
> --- a/misc/mke2fs.conf.5.in
> +++ b/misc/mke2fs.conf.5.in
> @@ -173,8 +173,9 @@ new filesystems with hashed b-tree directories.  Valid algorithms
>  accepted are:
>  .IR legacy ,
>  .IR half_md4 ,
> +.IR tea ,
>  and
> -.IR tea .
> +.IR siphash .
>  .TP
>  .I inode_ratio
>  This relation specifies the default inode ratio if the user does not
> diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> index c50d475..f25f177 100644
> --- a/misc/tune2fs.8.in
> +++ b/misc/tune2fs.8.in
> @@ -209,8 +209,9 @@ Set the default hash algorithm used for filesystems with hashed b-tree
>  directories.  Valid algorithms accepted are:
>  .IR legacy ,
>  .IR half_md4 ,
> +.IR tea ,
>  and
> -.IR tea .
> +.IR siphash .
>  .TP
>  .BI mount_opts= mount_option_string
>  Set a set of default mount options which will be used when the file
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
