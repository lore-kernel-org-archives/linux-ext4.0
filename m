From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: sparse fixes
Date: Sun, 2 Nov 2008 21:59:12 -0500
Message-ID: <20081103025911.GA29102@mit.edu>
References: <1225472135-20297-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, frederic.bohe@bull.net,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47386 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754212AbYKCC70 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 21:59:26 -0500
Content-Disposition: inline
In-Reply-To: <1225472135-20297-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 31, 2008 at 10:25:35PM +0530, Aneesh Kumar K.V wrote:
> There are some locking fixes also in this patch.

Can we move the one real locking fix into a separate patch, and push
that to Linus ASAP, while leaving the cleanups to later?

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index bdddea1..a725a5c 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1455,9 +1455,8 @@ static int ext4_fill_flex_info(struct super_block *sb)
>  
>  	/* We allocate both existing and potentially added groups */
>  	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
> -			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
> -			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
> -			   groups_per_flex;
> +			    ((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
> +			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
>  	sbi->s_flex_groups = kzalloc(flex_group_count *
>  				     sizeof(struct flex_groups), GFP_KERNEL);
>  	if (sbi->s_flex_groups == NULL) {


This looks like a real bug fix which we should get to Linus quickly,
since could cause problems on Big Endian systems.

> @@ -2014,8 +2013,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  		       sb->s_id, le32_to_cpu(features));
>  		goto failed_mount;
>  	}
> -	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb,
> -				    EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
> +	has_huge_files = le32_to_cpu(EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +				    EXT4_FEATURE_RO_COMPAT_HUGE_FILE));
>  	if (has_huge_files) {
>  		/*
>  		 * Large file size enabled file system can only be


This, on the other hand is a pointless sparse fixup that actually ends
up causing code bloat.  EXT4_HAS_RO_COMPAT() is a macro which
returns a boolean.  So we don't need to call le32_to_cpu() to it just
to shut up sparse.  Better to simply give a sparse anotation that this
returns an int and not a le32.

       		      	   	      	  - Ted
