Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21473C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 11:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F20012083D
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 11:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388894AbfDRLzi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:55:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:46860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388716AbfDRLzi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 07:55:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 708C2AEBC;
        Thu, 18 Apr 2019 11:55:36 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3DB1E1E15AE; Thu, 18 Apr 2019 13:55:34 +0200 (CEST)
Date:   Thu, 18 Apr 2019 13:55:34 +0200
From:   Jan Kara <jack@suse.cz>
To:     Barret Rhoden <brho@google.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com,
        stable@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix use-after-free race with debug_want_extra_isize
Message-ID: <20190418115534.GF28541@quack2.suse.cz>
References: <20190415211945.27343-1-brho@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415211945.27343-1-brho@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 15-04-19 17:19:45, Barret Rhoden wrote:
> When remounting with debug_want_extra_isize, we were not performing the
> same checks that we do during a normal mount.  That allowed us to set a
> value for s_want_extra_isize that reached outside the s_inode_size.
> 
> Reported-by: syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com
> Signed-off-by: Barret Rhoden <brho@google.com>
> Cc: stable@vger.kernel.org

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
> - In the current code, it looks like someone could mount with want_extra_isize
>   with some value > 0 but less than the minimums in the s_es.  If that's a bug,
>   I can submit a follow-on patch.
> 
> - Similarly, on a failed remount, sbi->s_want_extra_isize is changed to the
>   remounted value.  I can fix that too if it's a problem.
> 
> - Is it OK to remount with a smaller s_want_extra_isize than the previous mount?
>   I thought it was, but figured I'd ask while I'm looking at it.
> 
> 
>  fs/ext4/super.c | 58 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 34 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6ed4eb81e674..184944d4d8d1 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3513,6 +3513,37 @@ int ext4_calculate_overhead(struct super_block *sb)
>  	return 0;
>  }
>  
> +static void ext4_clamp_want_extra_isize(struct super_block *sb)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct ext4_super_block *es = sbi->s_es;
> +
> +	/* determine the minimum size of new large inodes, if present */
> +	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
> +	    sbi->s_want_extra_isize == 0) {
> +		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
> +						     EXT4_GOOD_OLD_INODE_SIZE;
> +		if (ext4_has_feature_extra_isize(sb)) {
> +			if (sbi->s_want_extra_isize <
> +			    le16_to_cpu(es->s_want_extra_isize))
> +				sbi->s_want_extra_isize =
> +					le16_to_cpu(es->s_want_extra_isize);
> +			if (sbi->s_want_extra_isize <
> +			    le16_to_cpu(es->s_min_extra_isize))
> +				sbi->s_want_extra_isize =
> +					le16_to_cpu(es->s_min_extra_isize);
> +		}
> +	}
> +	/* Check if enough inode space is available */
> +	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
> +							sbi->s_inode_size) {
> +		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
> +						       EXT4_GOOD_OLD_INODE_SIZE;
> +		ext4_msg(sb, KERN_INFO,
> +			 "required extra inode space not available");
> +	}
> +}
> +
>  static void ext4_set_resv_clusters(struct super_block *sb)
>  {
>  	ext4_fsblk_t resv_clusters;
> @@ -4387,30 +4418,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	} else if (ret)
>  		goto failed_mount4a;
>  
> -	/* determine the minimum size of new large inodes, if present */
> -	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
> -	    sbi->s_want_extra_isize == 0) {
> -		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
> -						     EXT4_GOOD_OLD_INODE_SIZE;
> -		if (ext4_has_feature_extra_isize(sb)) {
> -			if (sbi->s_want_extra_isize <
> -			    le16_to_cpu(es->s_want_extra_isize))
> -				sbi->s_want_extra_isize =
> -					le16_to_cpu(es->s_want_extra_isize);
> -			if (sbi->s_want_extra_isize <
> -			    le16_to_cpu(es->s_min_extra_isize))
> -				sbi->s_want_extra_isize =
> -					le16_to_cpu(es->s_min_extra_isize);
> -		}
> -	}
> -	/* Check if enough inode space is available */
> -	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
> -							sbi->s_inode_size) {
> -		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
> -						       EXT4_GOOD_OLD_INODE_SIZE;
> -		ext4_msg(sb, KERN_INFO, "required extra inode space not"
> -			 "available");
> -	}
> +	ext4_clamp_want_extra_isize(sb);
>  
>  	ext4_set_resv_clusters(sb);
>  
> @@ -5194,6 +5202,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  		goto restore_opts;
>  	}
>  
> +	ext4_clamp_want_extra_isize(sb);
> +
>  	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
>  	    test_opt(sb, JOURNAL_CHECKSUM)) {
>  		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
> -- 
> 2.21.0.392.gf8f6787159e-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
