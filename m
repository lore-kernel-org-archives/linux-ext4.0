From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH 3/4] jbd2: make shure that we do not miss aborted state
Date: Thu, 16 May 2013 20:35:04 +0800
Message-ID: <67146EAB-F75F-4FC4-BF14-D82E01243A23@gmail.com>
References: <1368707290-26185-1-git-send-email-dmonakhov@openvz.org> <1368707290-26185-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35097 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3EPMfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 May 2013 08:35:10 -0400
Received: by mail-pb0-f53.google.com with SMTP id un1so2265950pbc.40
        for <linux-ext4@vger.kernel.org>; Thu, 16 May 2013 05:35:10 -0700 (PDT)
In-Reply-To: <1368707290-26185-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Nothing serious. It seems you miswrite patch title 'sure'  to 'shure'..

Thanks,
Wang

> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> fs/jbd2/journal.c |    3 +--
> 1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 886ec2f..57b9120 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -700,12 +700,11 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
> 				!tid_gt(tid, journal->j_commit_sequence));
> 		read_lock(&journal->j_state_lock);
> 	}
> -	read_unlock(&journal->j_state_lock);
> -
> 	if (unlikely(is_journal_aborted(journal))) {
> 		printk(KERN_EMERG "journal commit I/O error\n");
> 		err = -EIO;
> 	}
> +	read_unlock(&journal->j_state_lock);
> 	return err;
> }
> 
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

