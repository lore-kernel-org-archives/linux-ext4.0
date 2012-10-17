From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 01/10] ext4: balloc: Fixed coding style issue
Date: Wed, 17 Oct 2012 14:05:25 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210171359270.30534@dhcp-1-104.brq.redhat.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2JQMFe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2012 08:05:34 -0400
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 17 Oct 2012, Adil Mujeeb wrote:

> Date: Wed, 17 Oct 2012 00:42:56 +0530
> From: Adil Mujeeb <mujeeb.adil@gmail.com>
> To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
>     linux-kernel@vger.kernel.org
> Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
> Subject: [PATCH 01/10] ext4: balloc: Fixed coding style issue
> 
> Fixed checkpatch.pl reported ERRORs

Hi Adil,

let me ask you something. How useful do you think those changes are ?
Have you learned anything by creating those patches ?

Just to clarify why I am asking such weird questions. It's not one of
those sneer questions, I would really like to know.

Thanks!
-Lukas

> 
> Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
> ---
>  linux-3.7-rc1/fs/ext4/balloc.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/linux-3.7-rc1/fs/ext4/balloc.c b/linux-3.7-rc1/fs/ext4/balloc.c
> index 1b50890..395418d 100644
> --- a/linux-3.7-rc1/fs/ext4/balloc.c
> +++ b/linux-3.7-rc1/fs/ext4/balloc.c
> @@ -246,7 +246,7 @@ unsigned ext4_free_clusters_after_init(struct super_block *sb,
>   * @bh:			pointer to the buffer head to store the block
>   *			group descriptor
>   */
> -struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
> +struct ext4_group_desc *ext4_get_group_desc(struct super_block *sb,
>  					     ext4_group_t block_group,
>  					     struct buffer_head **bh)
>  {
> @@ -700,7 +700,7 @@ static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb,
>  	if (!ext4_bg_has_super(sb, group))
>  		return 0;
>  
> -	if (EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG))
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG))
>  		return le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
>  	else
>  		return EXT4_SB(sb)->s_gdb_count;
> @@ -721,11 +721,11 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, ext4_group_t group)
>  			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
>  	unsigned long metagroup = group / EXT4_DESC_PER_BLOCK(sb);
>  
> -	if (!EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG) ||
> +	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
>  			metagroup < first_meta_bg)
>  		return ext4_bg_num_gdb_nometa(sb, group);
>  
> -	return ext4_bg_num_gdb_meta(sb,group);
> +	return ext4_bg_num_gdb_meta(sb, group);
>  
>  }
>  
> 
