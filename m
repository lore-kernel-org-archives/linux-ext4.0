From: Jan Kara <jack@suse.cz>
Subject: Re: quota: dqio_mutex design
Date: Thu, 3 Aug 2017 16:36:57 +0200
Message-ID: <20170803143657.GB23093@quack2.suse.cz>
References: <10928956.Fla3vXZ7d9@panda>
 <20170801130242.GH4215@quack2.suse.cz>
 <20170802162552.GA30353@quack2.suse.cz>
 <1691224.ooLB1CWbbI@panda>
 <CAP9B-QmBKVOfmT3=5wR9_P23+r6KGW_rfzJES4Y6pkjSofvPGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Perepechko <anserper@yandex.ru>,
        Shuichi Ihara <sihara@ddn.com>,
        Wang Shilong <wshilong@ddn.com>, Li Xi <lixi@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44743 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751251AbdHCOhA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 3 Aug 2017 10:37:00 -0400
Content-Disposition: inline
In-Reply-To: <CAP9B-QmBKVOfmT3=5wR9_P23+r6KGW_rfzJES4Y6pkjSofvPGg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello!

On Thu 03-08-17 19:31:04, Wang Shilong wrote:
> We DDN is investigating the same issue!
> 
> Some comments comes:
> 
> On Thu, Aug 3, 2017 at 1:52 AM, Andrew Perepechko <anserper@yandex.ru> wrote:
> >> On Tue 01-08-17 15:02:42, Jan Kara wrote:
> >> > Hi Andrew,
> >> >
> >> I've been experimenting with this today but this idea didn't bring any
> >> benefit in my testing. Was your setup with multiple users or a single user?
> >> Could you give some testing to my patches to see whether they bring some
> >> benefit to you?
> >>
> >>                                                               Honza
> >
> > Hi Jan!
> >
> > My setup was with a single user. Unfortunately, it may take some time before
> > I can try a patched kernel other than RHEL6 or RHEL7 with the same test,
> > we have a lot of dependencies on these kernels.
> >
> > The actual test we ran was mdtest.
> >
> > By the way, we had 15+% performance improvement in creates from the
> > change that was discussed earlier in this thread:
> >
> >            EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
> > +              if (test_bit(DQ_MOD_B, &dquot->dq_flags))
> > +                       return 0;
> 
> I don't think this is right, as far as i understand, journal quota need go
> together with quota space change update inside same transaction, this will
> break consistency if power off or RO happen.
> 
> Here is some ideas that i have thought:
> 
> 1) switch dqio_mutex to a read/write lock, especially, i think most of
> time journal quota updates is in-place update, that means we don't need
> change quota tree in memory, firstly try read lock, retry with write lock if
> there is real tree change.
> 
> 2)another is similar idea of Andrew's walkaround, but we need make correct
> fix, maintain dirty list for per transaction, and gurantee quota updates are
> flushed when commit transaction, this might be complex, i am not very
> familiar with JBD2 codes.
> 
> It will be really nice if we could fix this regression, as we see 20% performace
> regression.

So I have couple of patches:

1) I convert dqio_mutex do rw semaphore and use it in exclusive mode only
when quota tree is going to change. We also use dq_lock to serialize writes
of dquot - you cannot have two writes happening in parallel as that could
result in stale data being on disk. This patch brings benefit when there
are multiple users - now they don't contend on common lock. It shows
advantage in my testing so I plan to merge these patches. When the
contention is on a structure for single user this change however doesn't
bring much (the performance change is in statistical noise in my testing).

2) I have patches to remove some contention on dq_list_lock by not using
dirty list for tracking dquots in ext4 (and thus avoid dq_list_lock
completely in quota modification path). This does not bring measurable
benefit in my testing even on ramdisk but lockstat data for dq_list_lock
looks much better after this - it seems lock contention just shifted to
dq_data_lock - I'll try to address that as well and see whether I'll be
able to measure some advantage.

3) I have patches to convert dquot dirty bit to sequence counter so that
in commit_dqblk() we can check whether dquot state we wanted to write is
already on disk. Note that this is different from Andrew's approach in that
we do wait for dquot to be actually written before returning. We just don't
repeat the write unnecessarily. However this didn't bring any measurable
benefit in my testing so unless I'll be able to confirm it benefits some
workloads I won't merge this change.

If you can experiment with your workloads, I can send you patches. I'd be
keen on having some performance data from real setups...

								Honza

> 
> Thanks,
> Shilong
> 
> >                dquot_mark_dquot_dirty(dquot);
> >                return ext4_write_dquot(dquot);
> >
> > The idea was that if we know that some thread is somewhere between
> > mark_dirty and clear_dirty, then we can avoid blocking on dqio_mutex,
> > since that thread will update the ondisk dquot for us.
> >
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
