From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Ext4: wait for log to commit when putting super
Date: Mon, 07 Dec 2009 14:26:21 -0600
Message-ID: <4B1D64ED.5060403@redhat.com>
References: <20091207200924.GB8558@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934732AbZLGU0Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2009 15:26:16 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nB7KQMU8010305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 15:26:22 -0500
In-Reply-To: <20091207200924.GB8558@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Josef Bacik wrote:
> There is a problem where a transaction will be committing while we're unmounting
> the filesystem and you will get a panic because EXT4_SB(sb)->s_group_info has
> been kfree'ed in ext4_put_super.  The commit code does the callback for the
> mballoc stuff to release free'ed blocks in the transaction and panic's trying to
> access s_group_info.  The fix is to wait for the transaction to finish
> committing before we start cleaning up the mballoc stuff.  This patch hasn't
> been tested yet, but its an obvious fix.

Hm, doesn't jbd2_journal_destroy already do that, but we just
call it -after- we've done ext4_mb_release which leads to freeing
EXT4_SB(sb)->s_group_info ?

Can we just do jbd2_journal_destroy() earlier before we tear
down things it may depend on?

-Eric

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/ext4/super.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d4ca92a..ddd115f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -593,6 +593,7 @@ static void ext4_put_super(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_super_block *es = sbi->s_es;
> +	tid_t target;
>  	int i, err;
>  
>  	flush_workqueue(sbi->dio_unwritten_wq);
> @@ -603,6 +604,9 @@ static void ext4_put_super(struct super_block *sb)
>  	if (sb->s_dirt)
>  		ext4_commit_super(sb, 1);
>  
> +	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target))
> +		jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
> +
>  	ext4_release_system_zone(sb);
>  	ext4_mb_release(sb);
>  	ext4_ext_release(sb);

