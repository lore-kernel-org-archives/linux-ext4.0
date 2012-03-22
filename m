From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 2/9] ext4: write superblock only once on unmount
Date: Thu, 22 Mar 2012 10:59:55 +0100
Message-ID: <20120322095955.GE14485@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <1332254489-2300-3-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab2CVJ75 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 05:59:57 -0400
Content-Disposition: inline
In-Reply-To: <1332254489-2300-3-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-03-12 16:41:22, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> In some rather rare cases it is possible that ext4 may the superblock to the
> media twice. This patch makes sure this does not happen. This should speed up
> unmounting in those cases.
  This cleanup looks OK.
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  fs/ext4/super.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 502c61f..c1f5111 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -808,9 +808,6 @@ static void ext4_put_super(struct super_block *sb)
>  	destroy_workqueue(sbi->dio_unwritten_wq);
>  
>  	lock_super(sb);
> -	if (sb->s_dirt)
> -		ext4_commit_super(sb, 1);
> -
>  	if (sbi->s_journal) {
>  		err = jbd2_journal_destroy(sbi->s_journal);
>  		sbi->s_journal = NULL;
> @@ -827,8 +824,10 @@ static void ext4_put_super(struct super_block *sb)
>  	if (!(sb->s_flags & MS_RDONLY)) {
>  		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  		es->s_state = cpu_to_le16(sbi->s_mount_state);
> -		ext4_commit_super(sb, 1);
>  	}
> +	if (sb->s_dirt || !(sb->s_flags & MS_RDONLY))
> +		ext4_commit_super(sb, 1);
> +
>  	if (sbi->s_proc) {
>  		remove_proc_entry(sb->s_id, ext4_proc_root);
>  	}
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
