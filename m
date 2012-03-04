From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] [Patch] JBD and JBD2 missing set_freezable()
Date: Sun, 4 Mar 2012 23:51:07 +0100
Message-ID: <201203042351.07405.rjw@sisk.pl>
References: <4F2BA1FD.3030302@tuxonice.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Nigel Cunningham <nigel@tuxonice.net>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: linux-pm@lists.linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:54809 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab2CDWrB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 17:47:01 -0500
In-Reply-To: <4F2BA1FD.3030302@tuxonice.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday, February 03, 2012, Nigel Cunningham wrote:
> Hi all.
> 
> With the latest and greatest changes to the freezer, I started seeing
> panics that were caused by jbd2 running post-process freezing and
> hitting the canary BUG_ON for non-TuxOnIce I/O submission. I've traced
> this back to a lack of set_freezable calls in both jbd and jbd2. Since
> they're clearly meant to be frozen (there are tests for freezing()), I
> submit the following patch to add the missing calls.
> 
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>

Well, I wonder what the filesystems people think about that.

Thanks,
Rafael


> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 59c09f9..89cd985 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -129,6 +129,8 @@ static int kjournald(void *arg)
>  	setup_timer(&journal->j_commit_timer, commit_timeout,
>  			(unsigned long)current);
> 
> +	set_freezable();
> +
>  	/* Record that the journal thread is running */
>  	journal->j_task = current;
>  	wake_up(&journal->j_wait_done_commit);
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index c0a5f9f..663e47c 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -139,6 +139,8 @@ static int kjournald2(void *arg)
>  	setup_timer(&journal->j_commit_timer, commit_timeout,
>  			(unsigned long)current);
> 
> +	set_freezable();
> +
>  	/* Record that the journal thread is running */
>  	journal->j_task = current;
>  	wake_up(&journal->j_wait_done_commit);
> 

