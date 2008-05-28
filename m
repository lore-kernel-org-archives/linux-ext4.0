From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: remove double definitions of xattr macros
Date: Wed, 28 May 2008 14:19:01 -0700
Message-ID: <1212009541.3791.39.camel@localhost.localdomain>
References: <48368E5B.7010909@cn.fujitsu.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37611 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbYE1VTF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 17:19:05 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4SLJ4eY009428
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 17:19:04 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4SLJ35k103230
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 17:19:03 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4SLJ37O009585
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 17:19:03 -0400
In-Reply-To: <48368E5B.7010909@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-05-23 at 17:28 +0800, Shen Feng wrote:
> remove the definitions of macros:
> XATTR_TRUSTED_PREFIX
> XATTR_USER_PREFIX
> since they are defined in linux/xattr.h
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

BTW, the similar duplication also appear in in ext2/3/reiserfs, clean up
should also done there too?

> ---
>  fs/ext4/xattr_trusted.c |    4 +---
>  fs/ext4/xattr_user.c    |    4 +---
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/xattr_trusted.c b/fs/ext4/xattr_trusted.c
> index fff3338..ac1a52c 100644
> --- a/fs/ext4/xattr_trusted.c
> +++ b/fs/ext4/xattr_trusted.c
> @@ -13,13 +13,11 @@
>  #include "ext4.h"
>  #include "xattr.h"
> 
> -#define XATTR_TRUSTED_PREFIX "trusted."
> -
>  static size_t
>  ext4_xattr_trusted_list(struct inode *inode, char *list, size_t list_size,
>  			const char *name, size_t name_len)
>  {
> -	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX)-1;
> +	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
>  	const size_t total_len = prefix_len + name_len + 1;
> 
>  	if (!capable(CAP_SYS_ADMIN))
> diff --git a/fs/ext4/xattr_user.c b/fs/ext4/xattr_user.c
> index 67be723..d91aa61 100644
> --- a/fs/ext4/xattr_user.c
> +++ b/fs/ext4/xattr_user.c
> @@ -12,13 +12,11 @@
>  #include "ext4.h"
>  #include "xattr.h"
> 
> -#define XATTR_USER_PREFIX "user."
> -
>  static size_t
>  ext4_xattr_user_list(struct inode *inode, char *list, size_t list_size,
>  		     const char *name, size_t name_len)
>  {
> -	const size_t prefix_len = sizeof(XATTR_USER_PREFIX)-1;
> +	const size_t prefix_len = XATTR_USER_PREFIX_LEN;
>  	const size_t total_len = prefix_len + name_len + 1;
> 
>  	if (!test_opt(inode->i_sb, XATTR_USER))

