Return-Path: <SRS0=kW/n=QU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9724C282C4
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 02:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CAF8222BB
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 02:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbfBMCRv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 21:17:51 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:49238 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729117AbfBMCRv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 21:17:51 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EEC842F447120027A4D7;
        Wed, 13 Feb 2019 10:17:48 +0800 (CST)
Received: from [127.0.0.1] (10.177.244.145) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.408.0; Wed, 13 Feb 2019
 10:17:39 +0800
Subject: Re: [PATCH -v2] jbd2: fix race when writing superblock
To:     Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <20190211195841.GO23000@mit.edu>
 <20190212011917.9326-1-tytso@mit.edu>
CC:     <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>, <jack@suse.cz>
From:   "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <164df20f-8976-a074-300d-35f7cd2ee786@huawei.com>
Date:   Wed, 13 Feb 2019 10:17:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20190212011917.9326-1-tytso@mit.edu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.244.145]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2019/2/12 9:19, Theodore Ts'o Wrote:
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

I check the Linux 5.0-rc6 source code, there is one exception, which is
jbd2_journal_set_features(), it will modify the jbd2 superblock buffer
and will not wirte the jbd2 superblock. So the buffer is still lockless
in this case and the race mentioned above is still there.

Thanks,
Yi.

> This checksum corruption problem can be reproduced by xfstests
> generic/475.
> 
> Reported-by: zhangyi (F) <yi.zhang@huawei.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> 
> v1->v2:
>   - Fix missing unlock when jbd2_mark_journal_empty() doesn't need to
>     do anything
> 
>  fs/jbd2/journal.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 88d8f22d2cba..a8082c86d569 100644
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
> @@ -1454,18 +1458,17 @@ static void jbd2_mark_journal_empty(journal_t *journal, int write_op)
>  	journal_superblock_t *sb = journal->j_superblock;
>  
>  	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
> -	read_lock(&journal->j_state_lock);
> -	/* Is it already empty? */
> -	if (sb->s_start == 0) {
> -		read_unlock(&journal->j_state_lock);
> +	lock_buffer(journal->j_sb_buffer);
> +	if (sb->s_start == 0) {		/* Is it already empty? */
> +		unlock_buffer(journal->j_sb_buffer);
>  		return;
>  	}
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
> @@ -1488,9 +1491,8 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
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
> 

