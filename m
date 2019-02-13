Return-Path: <SRS0=kW/n=QU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95034C282C2
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 10:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C27E20842
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 10:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfBMK52 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Feb 2019 05:57:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:39050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727861AbfBMK52 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Feb 2019 05:57:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9BBB5AF7B;
        Wed, 13 Feb 2019 10:57:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 869D81E09C5; Wed, 13 Feb 2019 11:57:25 +0100 (CET)
Date:   Wed, 13 Feb 2019 11:57:25 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        adilger.kernel@dilger.ca, miaoxie@huawei.com, jack@suse.cz
Subject: Re: [PATCH -v2] jbd2: fix race when writing superblock
Message-ID: <20190213105725.GB13313@quack2.suse.cz>
References: <20190211195841.GO23000@mit.edu>
 <20190212011917.9326-1-tytso@mit.edu>
 <164df20f-8976-a074-300d-35f7cd2ee786@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164df20f-8976-a074-300d-35f7cd2ee786@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 13-02-19 10:17:39, zhangyi (F) wrote:
> On 2019/2/12 9:19, Theodore Ts'o Wrote:
> > The jbd2 superblock is lockless now, so there is probably a race
> > condition between writing it so disk and modifing contents of it, which
> > may lead to checksum error. The following race is the one case that we
> > have captured.
> > 
> > jbd2                                fsstress
> > jbd2_journal_commit_transaction
> >  jbd2_journal_update_sb_log_tail
> >   jbd2_write_superblock
> >    jbd2_superblock_csum_set         jbd2_journal_revoke
> >                                      jbd2_journal_set_features(revork)
> >                                      modify superblock
> >    submit_bh(checksum incorrect)
> > 
> > Fix this by locking the buffer head before modifing it.  We always
> > write the jbd2 superblock after we modify it, so this just means
> > calling the lock_buffer() a little earlier.
> > 
> 
> I check the Linux 5.0-rc6 source code, there is one exception, which is
> jbd2_journal_set_features(), it will modify the jbd2 superblock buffer
> and will not wirte the jbd2 superblock. So the buffer is still lockless
> in this case and the race mentioned above is still there.

So I've ignored jbd2_journal_set_features() as it is used only during mount
and so there's no possibility of a race. However now when checking again I
can see that jbd2_journal_revoke() does call jbd2_journal_set_features() as
well. Although that will modify journal superblock only on the first
revoke, there's a tiny chance that this indeed races with other journal
superblock modification. So I agree we should protect those changes with
buffer lock as well.

								Honza
> 
> Thanks,
> Yi.
> 
> > This checksum corruption problem can be reproduced by xfstests
> > generic/475.
> > 
> > Reported-by: zhangyi (F) <yi.zhang@huawei.com>
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > ---
> > 
> > v1->v2:
> >   - Fix missing unlock when jbd2_mark_journal_empty() doesn't need to
> >     do anything
> > 
> >  fs/jbd2/journal.c | 18 ++++++++++--------
> >  1 file changed, 10 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 88d8f22d2cba..a8082c86d569 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -1356,6 +1356,10 @@ static int journal_reset(journal_t *journal)
> >  	return jbd2_journal_start_thread(journal);
> >  }
> >  
> > +/*
> > + * This function expects that the caller will have locked the journal
> > + * buffer head, and will return with it unlocked
> > + */
> >  static int jbd2_write_superblock(journal_t *journal, int write_flags)
> >  {
> >  	struct buffer_head *bh = journal->j_sb_buffer;
> > @@ -1365,7 +1369,6 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
> >  	trace_jbd2_write_superblock(journal, write_flags);
> >  	if (!(journal->j_flags & JBD2_BARRIER))
> >  		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
> > -	lock_buffer(bh);
> >  	if (buffer_write_io_error(bh)) {
> >  		/*
> >  		 * Oh, dear.  A previous attempt to write the journal
> > @@ -1424,6 +1427,7 @@ int jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
> >  	jbd_debug(1, "JBD2: updating superblock (start %lu, seq %u)\n",
> >  		  tail_block, tail_tid);
> >  
> > +	lock_buffer(journal->j_sb_buffer);
> >  	sb->s_sequence = cpu_to_be32(tail_tid);
> >  	sb->s_start    = cpu_to_be32(tail_block);
> >  
> > @@ -1454,18 +1458,17 @@ static void jbd2_mark_journal_empty(journal_t *journal, int write_op)
> >  	journal_superblock_t *sb = journal->j_superblock;
> >  
> >  	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
> > -	read_lock(&journal->j_state_lock);
> > -	/* Is it already empty? */
> > -	if (sb->s_start == 0) {
> > -		read_unlock(&journal->j_state_lock);
> > +	lock_buffer(journal->j_sb_buffer);
> > +	if (sb->s_start == 0) {		/* Is it already empty? */
> > +		unlock_buffer(journal->j_sb_buffer);
> >  		return;
> >  	}
> > +
> >  	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
> >  		  journal->j_tail_sequence);
> >  
> >  	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
> >  	sb->s_start    = cpu_to_be32(0);
> > -	read_unlock(&journal->j_state_lock);
> >  
> >  	jbd2_write_superblock(journal, write_op);
> >  
> > @@ -1488,9 +1491,8 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
> >  	journal_superblock_t *sb = journal->j_superblock;
> >  	int errcode;
> >  
> > -	read_lock(&journal->j_state_lock);
> > +	lock_buffer(journal->j_sb_buffer);
> >  	errcode = journal->j_errno;
> > -	read_unlock(&journal->j_state_lock);
> >  	if (errcode == -ESHUTDOWN)
> >  		errcode = 0;
> >  	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n", errcode);
> > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
