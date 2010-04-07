From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: journalled quota optimization
Date: Wed, 7 Apr 2010 14:06:59 +0200
Message-ID: <20100407120658.GB3375@quack.suse.cz>
References: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-3-git-send-email-dmonakhov@openvz.org>
 <20100401091209.GE3322@quack.suse.cz>
 <871veuzici.fsf@openvz.org>
 <20100406180625.GE4420@quack.suse.cz>
 <87r5mrvfy9.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab0DGMGt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 08:06:49 -0400
Content-Disposition: inline
In-Reply-To: <87r5mrvfy9.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 07-04-10 12:12:46, Dmitry Monakhov wrote:
> Jan Kara <jack@suse.cz> writes:
> > On Mon 05-04-10 07:30:37, dmonakhov@openvz.org wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> 
> >> >   Hi,
> >> >
> >> > On Sat 27-03-10 15:15:39, Dmitry Monakhov wrote:
> >> >> Currently each quota modification result in write_dquot()
> >> >> and later dquot_commit().  This means what each quota modification
> >> >> function must wait for dqio_mutex. Which is *huge* performance
> >> >> penalty on big SMP systems. ASAIU The core idea of this implementation
> >> >> is to guarantee that each quota modification will be written to journal
> >> >> atomically. But in fact this is not always true, because dquot may be
> >> >> changed after dquot modification, but before it was committed to disk.
> >> >   We were already discussing this when you've last submitted the patch.
> >> > dqio_mutex has nothing to do with journaling. It is there so that two
> >> > writes to quota file cannot happen in parallel because that could cause
> >> > corruption. Without dqio_mutex, the following would be possible:
> >> >   Task 1				Task 2
> >> > ...
> >> >   qtree_write_dquot()
> >> >     ...
> >> >     info->dqi_ops->mem2disk_dqblk
> >> > 					modify dquot
> >> > 					mark_dquot_dirty
> >> > 					...
> >> > 					qtree_write_dquot()
> >> > 					  - writes newer information
> >> >     ret = sb->s_op->quota_write
> >> >       - overwrites the new information
> >> >         with an old one.
> >> >
> >> >
> >> >>  | Task 1                           | Task 2                      |
> >> >>  | alloc_space(nr)                  |                             |
> >> >>  | ->spin_lock(dq_data_lock)        |                             |
> >> >>  | ->curspace += nr                 |                             |
> >> >>  | ->spin_unlock(dq_data_lock)      |                             |
> >> >>  | ->mark_dirty()                   | free_space(nr)              |
> >> >>  | -->write_dquot()                 | ->spin_lock(dq_data_lock)   |
> >> >>  | --->dquot_commit()               | ->curspace -= nr            |
> >> >>  | ---->commit_dqblk()              | ->spin_unlock(dq_data_lock) |
> >> >>  | ----->spin_lock(dq_data_lock)    |                             |
> >> >>  | ----->mem2disk_dqblk(ddq, dquot) | <<< Copy updated value      |
> >> >>  | ----->spin_unlock(dq_data_lock)  |                             |
> >> >>  | ----->quota_write()              |                             |
> >> >> Quota corruption not happens only because quota modification caller
> >> >> started journal already. And ext3/4 allow only one running transaction
> >> >> at a time.
> >> >   While what you write above happens for other ext3/4 metadata as well.
> >> >
> >> >> Let's exploit this fact and avoid writing quota each time.
> >> >> Act similar to dirty_for_io in general write_back path in page-cache.
> >> >> If we have found what other task already started on copy and write the
> >> >> dquot then we skip actual quota_write stage. And let that task do the job.
> >> >> This patch fix only contention on dqio_mutex.
> >> >   As I wrote last time, your patch helps the contention only a tiny bit -
> >> > we clear the dirty bit as a first thing after we acquire dqio_mutex. So
> >> > your patch helps only if one task happens while another task is between
> >> >
> >> Yes. Absolutely right. But in fact two or more writer tasks are common
> >> because each quota modification result int quota_write.
> >> Mail server is just an example.
> >> In my measurements performance boost was about x2, x3
> >   I have to admit I'm really surprised (almost suspicious) about those
> > results :). If I consider the length of the whole write path doing block
> > allocation and how tiny part of the window you have to squeeze into, it's
> > hard for me to believe that you can achive such huge improvement. So if
> > the measurement is really correct, there must be something I miss...
> This one was done more than a month ago, but i think they are
> still correct
> http://download.openvz.org/~dmonakhov/docs/quota/STATUS.html
> I was too lazy(i say my self that i'm busy) to remeasure results in
> more mature SMP host(now i have host with 8 cores). I hope i'll do it
> this week. The performance gain is easy to describe
> Assume you have 16 writer tasks (with same uid for simplicity)
> and the first lucky one is able to grab dqio_mutex.
> others 15 are modified dquota and wait for dqio_mutex to
> write the exact same value.
> But after the patch we have only two IO involved tasks
> one which actually acquired the mutex and other which wait for
> the mutex.
> So in my example only first task from 15 will wait on mutex, and
> others will return without wait.
  Ah, OK, this was what I was missing. I was always imagining just two
tasks racing against each other but your patch starts bringing benefits
when there are three or more tasks. Now your results make sence to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
