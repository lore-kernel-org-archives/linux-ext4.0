From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/4] ext4: fix init_itable=n to work as expected for n=0
Date: Thu, 19 May 2011 14:59:09 -0500
Message-ID: <4DD5768D.9000800@redhat.com>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com> <1304956630-20384-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933926Ab1EST7M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2011 15:59:12 -0400
In-Reply-To: <1304956630-20384-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/9/11 10:57 AM, Lukas Czerner wrote:
> For some reason, when we set mount option init_itable=0 it behaves as
> we would set init_itable=20 which is not right at all. Basically when we
> set it to zero we are saying to lazyinit thread not to wait between
> zeroing the inode table (except of cond_resched()) so this commit fixes
> that and removes the unnecessary condition. The 'n' should be also
> properly used on remount.
> 
> When the n is not set at all, it means that the default miltiplier
> EXT4_DEF_LI_WAIT_MULT is set instead.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Eric Sandeen <sandeen@redhat.com>

This is why last-minute maintainer changes that bypass the list can be dangerous ;)
(This code wasn't in Lukas' last version on the list...)

nitpick: Documentation/fs/ext4.txt should probably be updated to clarify
that the "=n" value is optional and defaults to 20...

nitpick2: Is there any reason to set the default in parse_options() since it's
already set in ext4_fill_super just prior?

i.e. would something like:

                case Opt_init_inode_table:
                        set_opt(sb, INIT_INODE_TABLE);
                        if (args[0].from) {
                                if (match_int(&args[0], &option))
                                        return 0;
	                        if (option < 0)
					return 0;
				sbi->s_li_wait_mult = option;
                        }
                        break;

suffice?

-Eric

> ---
>  fs/ext4/super.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6ccf0e2..c379af6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2690,11 +2690,8 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
>  		ret = ext4_init_inode_table(sb, group,
>  					    elr->lr_timeout ? 0 : 1);
>  		if (elr->lr_timeout == 0) {
> -			timeout = jiffies - timeout;
> -			if (elr->lr_sbi->s_li_wait_mult)
> -				timeout *= elr->lr_sbi->s_li_wait_mult;
> -			else
> -				timeout *= 20;
> +			timeout = (jiffies - timeout) *
> +				  elr->lr_sbi->s_li_wait_mult;
>  			elr->lr_timeout = timeout;
>  		}
>  		elr->lr_next_sched = jiffies + elr->lr_timeout;
> @@ -2931,8 +2928,14 @@ static int ext4_register_li_request(struct super_block *sb,
>  	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
>  	int ret = 0;
>  
> -	if (sbi->s_li_request != NULL)
> +	if (sbi->s_li_request != NULL) {
> +		/*
> +		 * Reset timeout so it can be computed again, because
> +		 * s_li_wait_mult might have changed.
> +		 */
> +		sbi->s_li_request->lr_timeout = 0;
>  		return 0;
> +	}
>  
>  	if (first_not_zeroed == ngroups ||
>  	    (sb->s_flags & MS_RDONLY) ||
> @@ -3137,6 +3140,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	    ((def_mount_opts & EXT4_DEFM_NODELALLOC) == 0))
>  		set_opt(sb, DELALLOC);
>  
> +	/*
> +	 * set default s_li_wait_mult for lazyinit, for the case there is
> +	 * no mount option specified.
> +	 */
> +	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;

>  	if (!parse_options((char *) sbi->s_es->s_mount_opts, sb,
>  			   &journal_devnum, &journal_ioprio, NULL, 0)) {
>  		ext4_msg(sb, KERN_WARNING,

