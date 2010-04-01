From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: journalled quota optimization
Date: Thu, 1 Apr 2010 11:12:10 +0200
Message-ID: <20100401091209.GE3322@quack.suse.cz>
References: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1269692140-5375-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

On Sat 27-03-10 15:15:39, Dmitry Monakhov wrote:
> Currently each quota modification result in write_dquot()
> and later dquot_commit().  This means what each quota modification
> function must wait for dqio_mutex. Which is *huge* performance
> penalty on big SMP systems. ASAIU The core idea of this implementation
> is to guarantee that each quota modification will be written to journal
> atomically. But in fact this is not always true, because dquot may be
> changed after dquot modification, but before it was committed to disk.
  We were already discussing this when you've last submitted the patch.
dqio_mutex has nothing to do with journaling. It is there so that two
writes to quota file cannot happen in parallel because that could cause
corruption. Without dqio_mutex, the following would be possible:
  Task 1				Task 2
...
  qtree_write_dquot()
    ...
    info->dqi_ops->mem2disk_dqblk
					modify dquot
					mark_dquot_dirty
					...
					qtree_write_dquot()
					  - writes newer information
    ret = sb->s_op->quota_write
      - overwrites the new information
        with an old one.


>  | Task 1                           | Task 2                      |
>  | alloc_space(nr)                  |                             |
>  | ->spin_lock(dq_data_lock)        |                             |
>  | ->curspace += nr                 |                             |
>  | ->spin_unlock(dq_data_lock)      |                             |
>  | ->mark_dirty()                   | free_space(nr)              |
>  | -->write_dquot()                 | ->spin_lock(dq_data_lock)   |
>  | --->dquot_commit()               | ->curspace -= nr            |
>  | ---->commit_dqblk()              | ->spin_unlock(dq_data_lock) |
>  | ----->spin_lock(dq_data_lock)    |                             |
>  | ----->mem2disk_dqblk(ddq, dquot) | <<< Copy updated value      |
>  | ----->spin_unlock(dq_data_lock)  |                             |
>  | ----->quota_write()              |                             |
> Quota corruption not happens only because quota modification caller
> started journal already. And ext3/4 allow only one running transaction
> at a time.
  While what you write above happens for other ext3/4 metadata as well.

> Let's exploit this fact and avoid writing quota each time.
> Act similar to dirty_for_io in general write_back path in page-cache.
> If we have found what other task already started on copy and write the
> dquot then we skip actual quota_write stage. And let that task do the job.
> This patch fix only contention on dqio_mutex.
  As I wrote last time, your patch helps the contention only a tiny bit -
we clear the dirty bit as a first thing after we acquire dqio_mutex. So
your patch helps only if one task happens while another task is between

dquot_mark_dquot_dirty <---------- here
mutex_lock(&dqopt->dqio_mutex);
spin_lock(&dq_list_lock);
if (!clear_dquot_dirty(dquot)) { <----- and here

So I find this as complicating the code without much merit. And if I
remember right, last time I also suggested that it might be much more
useful to optimize how quota structure is written - i.e., get a reference
to a buffer in ext4_acquire_dquot and thus save ext4_bread from
ext4_quota_write.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
