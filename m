From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Wed, 16 May 2018 17:16:40 +0200
Message-ID: <CACT4Y+ZJwvROpBmKWF08fTd2AH=dO-a5+dzCzZua_vVFjiCRBw@mail.gmail.com>
References: <0000000000009b212b056ae6dbad@google.com> <343bbbf6-64eb-879e-d19e-96aebb037d47@I-love.SAKURA.ne.jp>
 <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp> <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com"
        <syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "penguin-kernel@I-love.SAKURA.ne.jp"
        <penguin-kernel@i-love.sakura.ne.jp>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jthumshirn@suse.de" <jthumshirn@suse.de>,
        "alan.christopher.jenkins@gmail.com"
        <alan.christopher.jenkins@gmail.com>, "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "martin@lichtvoll.de" <martin@lichtvoll.de>,
        "oleks
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 16, 2018 at 4:56 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Wed, 2018-05-16 at 22:05 +0900, Tetsuo Handa wrote:
>> One ore more threads are waiting for q->mq_freeze_depth to become 0. But the
>> thread who incremented q->mq_freeze_depth at blk_freeze_queue_start(q) from
>> blk_freeze_queue() is waiting at blk_mq_freeze_queue_wait(). Therefore,
>> atomic_read(&q->mq_freeze_depth) == 0 condition for wait_event() in
>> blk_queue_enter() will never be satisfied. But what does that wait_event()
>> want to do? Isn't "start freezing" a sort of blk_queue_dying(q) == true?
>> Since percpu_ref_tryget_live(&q->q_usage_counter) failed and the queue is
>> about to be frozen, shouldn't we treat atomic_read(&q->mq_freeze_depth) != 0
>> as if blk_queue_dying(q) == true? That is, something like below:
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 85909b4..59e2496 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -951,10 +951,10 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
>>               smp_rmb();
>>
>>               wait_event(q->mq_freeze_wq,
>> -                        (atomic_read(&q->mq_freeze_depth) == 0 &&
>> -                         (preempt || !blk_queue_preempt_only(q))) ||
>> +                        atomic_read(&q->mq_freeze_depth) ||
>> +                        (preempt || !blk_queue_preempt_only(q)) ||
>>                          blk_queue_dying(q));
>> -             if (blk_queue_dying(q))
>> +             if (atomic_read(&q->mq_freeze_depth) || blk_queue_dying(q))
>>                       return -ENODEV;
>>       }
>>  }
>
> That change looks wrong to me.

Hi Bart,

Why does it look wrong to you?

> Additionally, I think that you are looking in
> the wrong direction. Since blk_mq_freeze_queue_wait() and blk_queue_enter()
> work fine for all block drivers except the loop driver I think that you should
> have a closer look at how the loop driver uses this block layer functionality.
>
> Thanks,
>
> Bart.
>
>
>
