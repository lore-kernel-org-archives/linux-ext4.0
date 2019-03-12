Return-Path: <SRS0=vuM7=RP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE26CC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 12:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0DB20883
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 12:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfCLMVI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Mar 2019 08:21:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:34996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbfCLMVI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Mar 2019 08:21:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B5D8B053;
        Tue, 12 Mar 2019 12:21:07 +0000 (UTC)
Date:   Tue, 12 Mar 2019 13:21:06 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Avoid panic during forced reboot
Message-ID: <20190312122106.xzko4pmtpyreq6ih@pathway.suse.cz>
References: <20190312094906.5974-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190312094906.5974-1-jack@suse.cz>
User-Agent: NeoMutt/20170421 (1.8.2)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 2019-03-12 10:49:06, Jan Kara wrote:
> When admin calls "reboot -f" - i.e., does a hard system reboot by
> directly calling reboot(2) - ext4 filesystem mounted with errors=panic
> can panic the system. This happens because the underlying device gets
> disabled without unmounting the filesystem and thus some syscall running
> in parallel to reboot(2) can result in the filesystem getting IO errors.
> 
> This is somewhat surprising to the users so try improve the behavior by
> switching to errors=remount-ro behavior when the system is running
> reboot(2).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> What do people think about this? Arguably this change has some potential
> for breakage if e.g. an ext4 error would somehow block reboot(2). I don't
> see how that would be possible but I wanted to raise this just in case...
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 60da0a6e4d86..f7b6f95fa8dd 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -430,6 +430,12 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
>  	spin_unlock(&sbi->s_md_lock);
>  }
>  
> +static bool system_going_down(void)
> +{
> +	return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
> +		|| system_state == SYSTEM_RESTART;
> +}
> +
>  /* Deal with the reporting of failure conditions on a filesystem such as
>   * inconsistencies detected or read IO failures.
>   *
> @@ -460,7 +466,12 @@ static void ext4_handle_error(struct super_block *sb)
>  		if (journal)
>  			jbd2_journal_abort(journal, -EIO);
>  	}
> -	if (test_opt(sb, ERRORS_RO)) {
> +	/*
> +	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
> +	 * could panic during 'reboot -f' as the underlying device got already
> +	 * disabled.
> +	 */
> +	if (test_opt(sb, ERRORS_RO) || system_going_down()) {

If I read the code correctly then this will not avoid the panic().

There is no return in this branch. Therefore it still continues
with the ERRORS_PANIC check...

Or do I miss anything, please?

Best Regards,
Petr

>  		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
>  		/*
>  		 * Make sure updated value of ->s_mount_flags will be visible
> -- 
> 2.16.4
