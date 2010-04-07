From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/3] ext4: journalled quota optimization
Date: Wed, 07 Apr 2010 12:12:46 +0400
Message-ID: <87r5mrvfy9.fsf@openvz.org>
References: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
	<1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
	<1269692140-5375-3-git-send-email-dmonakhov@openvz.org>
	<20100401091209.GE3322@quack.suse.cz> <871veuzici.fsf@openvz.org>
	<20100406180625.GE4420@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:8568 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab0DGIMz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 04:12:55 -0400
In-Reply-To: <20100406180625.GE4420@quack.suse.cz> (Jan Kara's message of
	"Tue, 6 Apr 2010 20:06:25 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Mon 05-04-10 07:30:37, dmonakhov@openvz.org wrote:
>> Jan Kara <jack@suse.cz> writes:
>> 
>> >   Hi,
>> >
>> > On Sat 27-03-10 15:15:39, Dmitry Monakhov wrote:
>> >> Currently each quota modification result in write_dquot()
>> >> and later dquot_commit().  This means what each quota modification
>> >> function must wait for dqio_mutex. Which is *huge* performance
>> >> penalty on big SMP systems. ASAIU The core idea of this implementation
>> >> is to guarantee that each quota modification will be written to journal
>> >> atomically. But in fact this is not always true, because dquot may be
>> >> changed after dquot modification, but before it was committed to disk.
>> >   We were already discussing this when you've last submitted the patch.
>> > dqio_mutex has nothing to do with journaling. It is there so that two
>> > writes to quota file cannot happen in parallel because that could cause
>> > corruption. Without dqio_mutex, the following would be possible:
>> >   Task 1				Task 2
>> > ...
>> >   qtree_write_dquot()
>> >     ...
>> >     info->dqi_ops->mem2disk_dqblk
>> > 					modify dquot
>> > 					mark_dquot_dirty
>> > 					...
>> > 					qtree_write_dquot()
>> > 					  - writes newer information
>> >     ret = sb->s_op->quota_write
>> >       - overwrites the new information
>> >         with an old one.
>> >
>> >
>> >>  | Task 1                           | Task 2                      |
>> >>  | alloc_space(nr)                  |                             |
>> >>  | ->spin_lock(dq_data_lock)        |                             |
>> >>  | ->curspace += nr                 |                             |
>> >>  | ->spin_unlock(dq_data_lock)      |                             |
>> >>  | ->mark_dirty()                   | free_space(nr)              |
>> >>  | -->write_dquot()                 | ->spin_lock(dq_data_lock)   |
>> >>  | --->dquot_commit()               | ->curspace -= nr            |
>> >>  | ---->commit_dqblk()              | ->spin_unlock(dq_data_lock) |
>> >>  | ----->spin_lock(dq_data_lock)    |                             |
>> >>  | ----->mem2disk_dqblk(ddq, dquot) | <<< Copy updated value      |
>> >>  | ----->spin_unlock(dq_data_lock)  |                             |
>> >>  | ----->quota_write()              |                             |
>> >> Quota corruption not happens only because quota modification caller
>> >> started journal already. And ext3/4 allow only one running transaction
>> >> at a time.
>> >   While what you write above happens for other ext3/4 metadata as well.
>> >
>> >> Let's exploit this fact and avoid writing quota each time.
>> >> Act similar to dirty_for_io in general write_back path in page-cache.
>> >> If we have found what other task already started on copy and write the
>> >> dquot then we skip actual quota_write stage. And let that task do the job.
>> >> This patch fix only contention on dqio_mutex.
>> >   As I wrote last time, your patch helps the contention only a tiny bit -
>> > we clear the dirty bit as a first thing after we acquire dqio_mutex. So
>> > your patch helps only if one task happens while another task is between
>> >
>> Yes. Absolutely right. But in fact two or more writer tasks are common
>> because each quota modification result int quota_write.
>> Mail server is just an example.
>> In my measurements performance boost was about x2, x3
>   I have to admit I'm really surprised (almost suspicious) about those
> results :). If I consider the length of the whole write path doing block
> allocation and how tiny part of the window you have to squeeze into, it's
> hard for me to believe that you can achive such huge improvement. So if
> the measurement is really correct, there must be something I miss...
This one was done more than a month ago, but i think they are
still correct
http://download.openvz.org/~dmonakhov/docs/quota/STATUS.html
I was too lazy(i say my self that i'm busy) to remeasure results in
more mature SMP host(now i have host with 8 cores). I hope i'll do it
this week. The performance gain is easy to describe
Assume you have 16 writer tasks (with same uid for simplicity)
and the first lucky one is able to grab dqio_mutex.
others 15 are modified dquota and wait for dqio_mutex to
write the exact same value.
But after the patch we have only two IO involved tasks
one which actually acquired the mutex and other which wait for
the mutex.
So in my example only first task from 15 will wait on mutex, and
others will return without wait.
>
>> > dquot_mark_dquot_dirty <---------- here
>> > mutex_lock(&dqopt->dqio_mutex);
>> > spin_lock(&dq_list_lock);
>> > if (!clear_dquot_dirty(dquot)) { <----- and here
>> >
>> 
>> > So I find this as complicating the code without much merit. And if I
>> > remember right, last time I also suggested that it might be much more
>> > useful to optimize how quota structure is written - i.e., get a reference
>> > to a buffer in ext4_acquire_dquot and thus save ext4_bread from
>> > ext4_quota_write.
>> Ok, Indeed this make code more tricky. I just want to make future
>> default quota switch to journalled_mode more painless with minimal
>> code changes.
>   :-) We share this aim.
>
>> I'll go back to work on long term solution(according to your comments).
>> Right now i think it is reasonable to add new field to struct dquot.
>> void *dq_private; to let filesystem to store it's private data.
>> Ext3/4 will store journalled_buffer here.
>   Quota uses the same approach for fs-private data as VFS uses for inodes -
> i.e., a filesystem can provide quota allocation and destruction functions
> that allocate it's private quota structure which contains also the generic
> quota structure. OCFS2 uses the opportunity already so you can check out
> how it's exactly implemented.
>
> 									Honza
