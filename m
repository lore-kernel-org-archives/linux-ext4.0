From: Jens Axboe <axboe@kernel.dk>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Fri, 1 Jun 2018 22:31:13 -0600
Message-ID: <f43465cf-e2f1-807f-d283-89033c056b5b@kernel.dk>
References: <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
 <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com>
 <CACT4Y+ZJwvROpBmKWF08fTd2AH=dO-a5+dzCzZua_vVFjiCRBw@mail.gmail.com>
 <6db16aa3a7c56b6dcca2d10b4e100a780c740081.camel@wdc.com>
 <201805220652.BFH82351.SMQFFOJOtFOVLH@I-love.SAKURA.ne.jp>
 <201805222020.FEJ82897.OFtJMFHOVLQOSF@I-love.SAKURA.ne.jp>
 <25708e84-6f35-04c3-a2e4-6854f0ed9e78@I-love.SAKURA.ne.jp>
 <dc9862c7-ec16-8b11-04e4-422b435d41ef@kernel.dk>
 <20180601234946.GA655@ming.t460p>
 <95c419d8-7f19-f9c0-a53f-3d381fe93176@kernel.dk>
 <20180602023622.GA2306@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Bart.VanAssche@wdc.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        jthumshirn@suse.de, alan.christopher.jenkins@gmail.com,
        syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com,
        martin.petersen@oracle.com, dan.j.williams@intel.com, hch@lst.de,
        oleksandr@natalenko.name, martin@lichtvoll.de, hare@suse.com,
        syzkaller-bugs@googlegroups.com, ross.zwisler@linux.intel.com,
        keith.busch@intel.com, linux-ext4@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180602023622.GA2306@ming.t460p>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 6/1/18 8:36 PM, Ming Lei wrote:
>> clear the bit when we need to, potentially even adding a debug check to
>> blk_queue_enter_live() that complains if the ref was not already
>> elevated. Though that would be expensive, compared to the percpu inc
>> now. Not saying the bit is necessarily the best way forward, but I do
>> like it a LOT more than adding an argument to generic_make_request.
> 
> We may introduce generic_make_request_with_ref() for blk_queue_split(),
> what do you think of the following patch?

Functionally it'll work as well.

> In DM or MD, there is the following use case:
> 
> 1) bio comes from fs, then one clone is made from this bio
> 
> 2) the cloned bio is submitted via generic_make_request() from
> another context, such as wq.
> 
> 3) then the flag of BIO_QUEUE_ENTERED is inherited and causes
> the queue usage counter isn't held.

We don't copy flags on a clone.

-- 
Jens Axboe
