From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Tue, 22 May 2018 06:52:21 +0900
Message-ID: <201805220652.BFH82351.SMQFFOJOtFOVLH@I-love.SAKURA.ne.jp>
References: <343bbbf6-64eb-879e-d19e-96aebb037d47@I-love.SAKURA.ne.jp>
        <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
        <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com>
        <CACT4Y+ZJwvROpBmKWF08fTd2AH=dO-a5+dzCzZua_vVFjiCRBw@mail.gmail.com>
        <6db16aa3a7c56b6dcca2d10b4e100a780c740081.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        jthumshirn@suse.de, alan.christopher.jenkins@gmail.com,
        syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com,
        martin.petersen@oracle.com, axboe@kernel.dk,
        dan.j.williams@intel.com, hch@lst.de, oleksandr@natalenko.name,
        ming.lei@redhat.com, martin@lichtvoll.de, hare@suse.com,
        syzkaller-bugs@googlegroups.com, ross.zwisler@linux.intel.com,
        keith.busch@intel.com, linux-ext4@vger.kernel.org
To: Bart.VanAssche@wdc.com, dvyukov@google.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6db16aa3a7c56b6dcca2d10b4e100a780c740081.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Bart Van Assche wrote:
> On Wed, 2018-05-16 at 17:16 +0200, Dmitry Vyukov wrote:
> > On Wed, May 16, 2018 at 4:56 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > > On Wed, 2018-05-16 at 22:05 +0900, Tetsuo Handa wrote:
> > > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > > index 85909b4..59e2496 100644
> > > > --- a/block/blk-core.c
> > > > +++ b/block/blk-core.c
> > > > @@ -951,10 +951,10 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
> > > >               smp_rmb();
> > > > 
> > > >               wait_event(q->mq_freeze_wq,
> > > > -                        (atomic_read(&q->mq_freeze_depth) == 0 &&
> > > > -                         (preempt || !blk_queue_preempt_only(q))) ||
> > > > +                        atomic_read(&q->mq_freeze_depth) ||
> > > > +                        (preempt || !blk_queue_preempt_only(q)) ||
> > > >                          blk_queue_dying(q));
> > > > -             if (blk_queue_dying(q))
> > > > +             if (atomic_read(&q->mq_freeze_depth) || blk_queue_dying(q))
> > > >                       return -ENODEV;
> > > >       }
> > > >  }
> > > 
> > > That change looks wrong to me.
> > 
> > Hi Bart,
> > 
> > Why does it look wrong to you?
> 
> Because that change conflicts with the purpose of queue freezing and also because
> that change would inject I/O errors in code paths that shouldn't inject I/O errors.

But waiting there until atomic_read(&q->mq_freeze_depth) becomes 0 is causing deadlock.
wait_event() never returns is a bug. I think we should not wait for q->mq_freeze_depth.
