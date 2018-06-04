From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Mon, 4 Jun 2018 22:13:23 +0900
Message-ID: <09a33861-2ddc-1a13-19f6-2a1998ca3ec5@i-love.sakura.ne.jp>
References: <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
 <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com>
 <CACT4Y+ZJwvROpBmKWF08fTd2AH=dO-a5+dzCzZua_vVFjiCRBw@mail.gmail.com>
 <6db16aa3a7c56b6dcca2d10b4e100a780c740081.camel@wdc.com>
 <201805220652.BFH82351.SMQFFOJOtFOVLH@I-love.SAKURA.ne.jp>
 <201805222020.FEJ82897.OFtJMFHOVLQOSF@I-love.SAKURA.ne.jp>
 <25708e84-6f35-04c3-a2e4-6854f0ed9e78@I-love.SAKURA.ne.jp>
 <CACT4Y+bd8oc3Y5o+mxwktefGc07aU8N25doQRDvD8g8v3TyaZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Alan Jenkins <alan.christopher.jenkins@gmail.com>,
        syzbot <syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>, oleksandr@natalenko.name,
        ming.lei@redhat.com, martin@lichtvoll.de,
        Hannes Reinecke <hare@suse.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        keith.busch@intel.com, linux-ext4@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+bd8oc3Y5o+mxwktefGc07aU8N25doQRDvD8g8v3TyaZw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2018/06/04 20:46, Dmitry Vyukov wrote:
> On Fri, Jun 1, 2018 at 12:10 PM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>> Tetsuo Handa wrote:
>>> Since sum of percpu_count did not change after percpu_ref_kill(), this is
>>> not a race condition while folding percpu counter values into atomic counter
>>> value. That is, for some reason, someone who is responsible for calling
>>> percpu_ref_put(&q->q_usage_counter) (presumably via blk_queue_exit()) is
>>> unable to call percpu_ref_put().
>>> But I don't know how to find someone who is failing to call percpu_ref_put()...
>>
>> I found the someone. It was already there in the backtrace...
> 
> Nice!
> 
> Do I understand it correctly that this bug is probably the root cause
> of a whole lot of syzbot "task hung" reports? E.g. this one too?
> https://syzkaller.appspot.com/bug?id=cdc4add60bb95a4da3fec27c5fe6d75196b7f976
> I guess we will need to sweep close everything related to
> filesystems/block devices when this is committed?
> 

I can't tell it. We still have lockdep warning for loop module. Also, I suspect
that hung tasks waiting for page bit might be related to binder module.

Since we are about to merge "kernel/hung_task.c: show all hung tasks before panic"
patch, we might be able to get more hints after 4.18-rc1.
