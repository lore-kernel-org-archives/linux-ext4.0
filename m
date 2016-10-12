From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Wed, 12 Oct 2016 15:19:25 -0600
Message-ID: <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard> <20160929043722.ypf3tnxsl6ovt653@thunk.org>
 <20161012211407.GL23194@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <fstests@vger.kernel.org>,
        <tarasov@vasily.name>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753755AbcJLWsn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Oct 2016 18:48:43 -0400
In-Reply-To: <20161012211407.GL23194@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/12/2016 03:14 PM, Dave Chinner wrote:
> On Thu, Sep 29, 2016 at 12:37:22AM -0400, Theodore Ts'o wrote:
>> On Fri, Jun 19, 2015 at 09:34:30AM +1000, Dave Chinner wrote:
>>> On Thu, Jun 18, 2015 at 11:53:37AM -0400, Theodore Ts'o wrote:
>>>> I've been trying to figure out why generic/299 has occasionally been
>>>> stalling forever.  After taking a closer look, it appears the problem
>>>> is that the fio process is stalling in userspace.  Looking at the ps
>>>> listing, the fio process hasn't run in over six hours, and using
>>>> attaching strace to the fio process, it's stalled in a FUTUEX_WAIT.
>>>>
>>>> Has anyone else seen this?  I'm using fio 2.2.6, and I have a feeling
>>>> that I started seeing this when I started using a newer version of
>>>> fio.  So I'm going to try roll back to an older version of fio and see
>>>> if that causes the problem to go away.
>>>
>>> I'm running on fio 2.1.3 at the moment and I havne't seen any
>>> problems like this for months. Keep in mind that fio does tend to
>>> break in strange ways fairly regularly, so I'd suggest an
>>> upgrade/downgrade of fio as your first move.
>>
>> Out of curiosity, Dave, are you still using fio 2.1.3?  I had upgraded
>
> No.
>
> $ fio -v
> fio-2.1.11
> $
>
>> to the latest fio to fix other test breaks, and I'm stil seeing the
>> occasional generic/299 test failure.  In fact, it's been happening
>> often enough on one of my test platforms[1] that I decided to really
>> dig down and investigate it, and all of the threads were blocking on
>> td->verify_cond in fio's verify.c.
>>
>> It bisected down to this commit:
>>
>> commit e5437a073e658e8154b9e87bab5c7b3b06ed4255
>> Author: Vasily Tarasov <tarasov@vasily.name>
>> Date:   Sun Nov 9 20:22:24 2014 -0700
>>
>>     Fix for a race when fio prints I/O statistics periodically
>>
>>     Below is the demonstration for the latest code in git:
>>     ...
>>
>> So generic/299 passes reliably with this commits parent, and it fails
>> on this commit within a dozen tries or so.  The commit first landed in
>> fio 2.1.14, so it's consistent with Dave's report a year ago he was
>> still using fio 2.1.3.
>
> But I'm still not using a fio recent enough to hit this.

FWIW, this is the commit that fixes it:

commit 39d13e67ef1f4b327c68431f8daf033a03920117
Author: Jens Axboe <axboe@fb.com>
Date:   Fri Aug 26 14:39:30 2016 -0600

     backend: check if we need to update rusage stats, if stat_mutex is busy

2.14 and newer should not have the problem, but earlier versions may
depending on how old...

-- 
Jens Axboe

