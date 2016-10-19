From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Wed, 19 Oct 2016 11:49:12 -0600
Message-ID: <30fef8cd-67cc-da49-77d9-9d1a833f8a48@fb.com>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard> <20160929043722.ypf3tnxsl6ovt653@thunk.org>
 <20161012211407.GL23194@dastard>
 <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
 <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
 <ffc283a7-58ef-66b9-3c5b-75703d24ea0d@fb.com>
 <20161013231923.j2fidfbtzdp66x3t@thunk.org>
 <20161018180107.fscbfm66yidwhey4@thunk.org>
 <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, <linux-ext4@vger.kernel.org>,
        <fstests@vger.kernel.org>, <tarasov@vasily.name>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/19/2016 08:06 AM, Jens Axboe wrote:
> On 10/18/2016 12:01 PM, Theodore Ts'o wrote:
>> Jens, ping?
>>
>> Have you had a chance to take a look at the stack traces?  Is there
>> any other debugging information I can get for you?
>
> I'll take a look today. I agree, this definitely looks like a fio
> bug. But not related to the mutex issue for the stat part, all verifier
> threads are waiting to be woken up, but the main thread is done.
>
> I'll see if I can reproduce. If not, I may ask you to dump more info
> from the hung processes.

Been running for 4 hours now, in a loop, with bs=1k. I haven't been able
to reproduce. Before I go through the hassle of doing the google compute
engine thing, can you give me some details of the hardware?

Number of cores/nodes?
Memory size?
Rough speed and size of the device?
Any special mkfs options?

And whatever else might be relevant.

-- 
Jens Axboe
