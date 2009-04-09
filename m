From: Jack Stone <jwjstone@fastmail.fm>
Subject: Re: [PATCH 10/56] ext2: Remove void casts
Date: Thu, 09 Apr 2009 10:52:47 +0100
Message-ID: <49DDC56F.8000006@fastmail.fm>
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34955 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbZDIJwv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 05:52:51 -0400
In-Reply-To: <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Added maintainer CCs]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  fs/ext2/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index f983225..be6825a 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -143,7 +143,7 @@ static struct kmem_cache * ext2_inode_cachep;
>  static struct inode *ext2_alloc_inode(struct super_block *sb)
>  {
>  	struct ext2_inode_info *ei;
> -	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
> +	ei = kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
>  	if (!ei)
>  		return NULL;
>  #ifdef CONFIG_EXT2_FS_POSIX_ACL
>   

