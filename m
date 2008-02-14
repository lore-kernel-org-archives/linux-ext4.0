From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH RESEND] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Thu, 14 Feb 2008 09:43:45 -0800
Message-ID: <1203011025.3637.9.camel@localhost.localdomain>
References: <1203006909.8970.20.camel@ext1.frec.bull.fr>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41489 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbYBNRnr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 12:43:47 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1EHhkGJ001664
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 12:43:46 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1EHhkZ2145718
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 12:43:46 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1EHhkDk017184
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 12:43:46 -0500
In-Reply-To: <1203006909.8970.20.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-02-14 at 17:35 +0100, Valerie Clement wrote:
> Fix kernel BUG at fs/ext4/mballoc.c:910!
> 
> From: Valerie Clement <valerie.clement@bull.net>
> 
> With the flex_bg feature enabled, a large file creation oopses the
> kernel.
> The BUG_ON is:
> 	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
> 
> As the allocation of the bitmaps and the inode table can be done
> outside the block group with flex_bg, this allows to allocate up to
> EXT4_BLOCKS_PER_GROUP blocks in a group.
> Depending on the group size and the block size, extents might be 
> larger than BLOCKS_PER_GROUP(); use EXT_INIT_MAX_LEN instead of 
> BLOCKS_PER_GROUP().
> 

Yep, I think using EXT_INIT_MAX_LEN is better.
Will add to the patch queue shortly.

Thanks,
Mingming
> This patch fixes the oops.
> 
> Signed-off-by: Valerie Clement <valerie.clement@bull.net>
> ---
> 
>  fs/ext4/mballoc.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index b0f84b4..ccc33e9 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -34,6 +34,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/seq_file.h>
>  #include <linux/version.h>
> +#include <linux/ext4_fs_extents.h>
>  #include "group.h"
> 
>  /*
> @@ -907,7 +908,9 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
>  	unsigned short chunk;
>  	unsigned short border;
> 
> -	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
> +	BUG_ON(len > EXT4_HAS_INCOMPAT_FEATURE(sb,
> +			EXT4_FEATURE_INCOMPAT_FLEX_BG) ? EXT_INIT_MAX_LEN :
> +			EXT4_BLOCKS_PER_GROUP(sb));
> 
>  	border = 2 << sb->s_blocksize_bits;
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
