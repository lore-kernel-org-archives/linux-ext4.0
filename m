Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A854FC282C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 08:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 809D72077B
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 08:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfBLI3I (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 03:29:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:46234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728170AbfBLI3I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 03:29:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 29642AED1;
        Tue, 12 Feb 2019 08:29:06 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 987291E09A8; Tue, 12 Feb 2019 09:29:05 +0100 (CET)
Date:   Tue, 12 Feb 2019 09:29:05 +0100
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, "zhangyi (F)" <yi.zhang@huawei.com>,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        miaoxie@huawei.com
Subject: Re: [PATCH] jbd2: fix race when writing superblock
Message-ID: <20190212082905.GP19029@quack2.suse.cz>
References: <1548420023-8519-1-git-send-email-yi.zhang@huawei.com>
 <20190128150634.GC5858@quack2.suse.cz>
 <20190211195841.GO23000@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211195841.GO23000@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 11-02-19 14:58:41, Theodore Y. Ts'o wrote:
> On Mon, Jan 28, 2019 at 04:06:34PM +0100, Jan Kara wrote:
> > 
> > Thanks for the analysis and the patch! I think that copying of the
> > superblock to a temporary buffer is not free either and the frequent
> > updates of journal superblock are synchronized by j_checkpoint_mutex
> > anyway. So I think that using buffer lock when modifying journal
> > superblock contents is actually the easiest way forward.
> 
> Agreed.  It turns out we always write the superblock after we modify
> it, so we have to call lock_buffer() anyway; the patch just moves it
> so it happens a bit earlier.
> 
> Please take a look at this fix.  Zhangyi, can you confirm whether your
> test failures of generic/475 are addressed with this patch?
> 
> 					- Ted
> 
> From 9bb7a0025fc43bc517c5e30c638f9ca389600b15 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Mon, 11 Feb 2019 14:52:14 -0500
> Subject: [PATCH] jbd2: fix race when writing superblock
> 
> The jbd2 superblock is lockless now, so there is probably a race
> condition between writing it so disk and modifing contents of it, which
> may lead to checksum error. The following race is the one case that we
> have captured.
> 
> jbd2                                fsstress
> jbd2_journal_commit_transaction
>  jbd2_journal_update_sb_log_tail
>   jbd2_write_superblock
>    jbd2_superblock_csum_set         jbd2_journal_revoke
>                                      jbd2_journal_set_features(revork)
>                                      modify superblock
>    submit_bh(checksum incorrect)
> 
> Fix this by locking the buffer head before modifing it.  We always
> write the jbd2 superblock after we modify it, so this just means
> calling the lock_buffer() a little earlier.
> 
> This checksum corruption problem can be reproduced by xfstests
> generic/475.
> 
> Reported-by: zhangyi (F) <yi.zhang@huawei.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Yeah, that's a good observation. The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/journal.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 88d8f22d2cba..7a38b56c2544 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1356,6 +1356,10 @@ static int journal_reset(journal_t *journal)
>  	return jbd2_journal_start_thread(journal);
>  }
>  
> +/*
> + * This function expects that the caller will have locked the journal
> + * buffer head, and will return with it unlocked
> + */
>  static int jbd2_write_superblock(journal_t *journal, int write_flags)
>  {
>  	struct buffer_head *bh = journal->j_sb_buffer;
> @@ -1365,7 +1369,6 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
>  	trace_jbd2_write_superblock(journal, write_flags);
>  	if (!(journal->j_flags & JBD2_BARRIER))
>  		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
> -	lock_buffer(bh);
>  	if (buffer_write_io_error(bh)) {
>  		/*
>  		 * Oh, dear.  A previous attempt to write the journal
> @@ -1424,6 +1427,7 @@ int jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
>  	jbd_debug(1, "JBD2: updating superblock (start %lu, seq %u)\n",
>  		  tail_block, tail_tid);
>  
> +	lock_buffer(journal->j_sb_buffer);
>  	sb->s_sequence = cpu_to_be32(tail_tid);
>  	sb->s_start    = cpu_to_be32(tail_block);
>  
> @@ -1454,18 +1458,15 @@ static void jbd2_mark_journal_empty(journal_t *journal, int write_op)
>  	journal_superblock_t *sb = journal->j_superblock;
>  
>  	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
> -	read_lock(&journal->j_state_lock);
> -	/* Is it already empty? */
> -	if (sb->s_start == 0) {
> -		read_unlock(&journal->j_state_lock);
> +	lock_buffer(journal->j_sb_buffer);
> +	if (sb->s_start == 0)	/* Is it already empty? */
>  		return;
> -	}
> +
>  	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
>  		  journal->j_tail_sequence);
>  
>  	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
>  	sb->s_start    = cpu_to_be32(0);
> -	read_unlock(&journal->j_state_lock);
>  
>  	jbd2_write_superblock(journal, write_op);
>  
> @@ -1488,9 +1489,8 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
>  	journal_superblock_t *sb = journal->j_superblock;
>  	int errcode;
>  
> -	read_lock(&journal->j_state_lock);
> +	lock_buffer(journal->j_sb_buffer);
>  	errcode = journal->j_errno;
> -	read_unlock(&journal->j_state_lock);
>  	if (errcode == -ESHUTDOWN)
>  		errcode = 0;
>  	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n", errcode);
> -- 
> 2.19.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
