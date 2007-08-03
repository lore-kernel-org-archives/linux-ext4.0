From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4][e2fsprogs] Relax group descriptor checking.
Date: Fri, 03 Aug 2007 10:54:04 +0530
Message-ID: <46B2BBF4.7010408@linux.vnet.ibm.com>
References: <20070803040041.29456.31454.stgit@gara> <20070803040059.29456.55756.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:61655 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbXHCF1i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 01:27:38 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l735R4aU206838
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 15:27:37 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l735Rdj3161102
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 15:27:39 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l735O5gJ011525
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 15:24:05 +1000
In-Reply-To: <20070803040059.29456.55756.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
>
>  e2fsck/super.c          |   10 ++++++++--
>  lib/ext2fs/check_desc.c |   10 ++++++++--
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index 00a131c..8e58e5c 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -578,8 +578,14 @@ void check_super_block(e2fsck_t ctx)
>  	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
>  		pctx.group = i;
> 
> -		first_block = ext2fs_group_first_block(fs, i);
> -		last_block = ext2fs_group_last_block(fs, i);
> +		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
> +			EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> +			first_block = fs->super->s_first_data_block;
> +			last_block = fs->super->s_blocks_count;


I guess this should be fs->super->s_blocks_count - 1 ;





> +		} else {
> +			first_block = ext2fs_group_first_block(fs, i);
> +			last_block = ext2fs_group_last_block(fs, i);
> +		}
> 
>  		if ((gd->bg_block_bitmap < first_block) ||
>  		    (gd->bg_block_bitmap > last_block)) {
> diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
> index 146f9e5..bb65c06 100644
> --- a/lib/ext2fs/check_desc.c
> +++ b/lib/ext2fs/check_desc.c
> @@ -38,8 +38,14 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
>  	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> 
>  	for (i = 0; i < fs->group_desc_count; i++) {
> -		first_block = ext2fs_group_first_block(fs, i);
> -		last_block = ext2fs_group_last_block(fs, i);
> +		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> +			first_block = fs->super->s_first_data_block;
> +			last_block = fs->super->s_blocks_count;
> +		

I guess this should be fs->super->s_blocks_count - 1 ;

-aneesh
