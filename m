From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/6] ext4: fix data integrity for ext4_sync_fs
Date: Mon, 03 Jun 2013 15:30:19 +0400
Message-ID: <87mwr7fn3o.fsf@openvz.org>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org> <1369732741-26070-3-git-send-email-dmonakhov@openvz.org> <20130528215112.GF16408@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:52399 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3FCLaY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jun 2013 07:30:24 -0400
Received: by mail-la0-f53.google.com with SMTP id ea20so3346094lab.12
        for <linux-ext4@vger.kernel.org>; Mon, 03 Jun 2013 04:30:22 -0700 (PDT)
In-Reply-To: <20130528215112.GF16408@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 28 May 2013 23:51:12 +0200, Jan Kara <jack@suse.cz> wrote:
> On Tue 28-05-13 13:18:57, Dmitry Monakhov wrote:
> > Inode's data or non journaled quota may be written w/o jounral so we _must_
> > send a barrier at the end of ext4_sync_fs. But it can be skipped if journal
> > commit will do it for us.
> > 
> > Also fix data integrity for nojournal mode.
> > changes from v1:
> >  skip barrier for async mode
>   One comment below:
> 
> > diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> > index c9e1ab6..ed974fd 100644
> > --- a/include/linux/jbd2.h
> > +++ b/include/linux/jbd2.h
> > @@ -1319,6 +1319,21 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
> >  	return *(u32 *)desc.ctx;
> >  }
> >  
> > +/* Return most recent uncommitted transaction */
> > +static inline tid_t  jbd2_get_latest_transaction(journal_t *journal)
> > +{
> > +	tid_t tid;
> > +
> > +	read_lock(&journal->j_state_lock);
> > +	tid = journal->j_commit_request;
> > +	if (journal->j_running_transaction) {
> > +		tid = journal->j_running_transaction->t_tid;
> > +	} else if (!journal->j_commit_sequence)
>   I would expect here journal->j_committing_transaction and then
> journal->j_commit_request below. And you can use j_commit_sequence as an
> initial 'tid' value...
I have to admit that my code is not correct because function should
return 'most recent uncommitted transaction', but I do not get your
idea. journal->j_commit_request >= jorunal->j_committing_transaction
and journal->j_commit_request >= journal->j_commit_sequence

So it is reasonable to define function like follows:

static inline tid_t  jbd2_get_latest_transaction(journal_t journal)
{
   tid_t tid;

   read_lock(&journal->j_state_lock);
   tid = journal->j_commit_request;
   if (journal->j_running_transaction)
           tid = journal->j_running_transaction->t_tid;
   read_unlock(&journal->j_state_lock);
   return tid;
}
