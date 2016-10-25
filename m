From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Mon, 24 Oct 2016 20:59:12 -0600
Message-ID: <34b2b4fe-052d-4d13-bc80-211707ea118e@fb.com>
References: <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
 <30fef8cd-67cc-da49-77d9-9d1a833f8a48@fb.com>
 <20161019203233.mbbmskpn5ekgl7og@thunk.org>
 <1fb60e7c-a558-80df-09da-d3c36863a461@fb.com>
 <20161021221551.sdv4hgw33zjxnkvu@thunk.org>
 <53fe5a98-6ff9-4fa1-e84c-8a3e16cc0f50@fb.com>
 <20161023193320.rlzlaxdi4vbyu7of@thunk.org>
 <20161023212408.cjqmnzw3547ujzil@thunk.org>
 <20161024033852.quinlee4a24mb2e2@thunk.org>
 <773e0780-6641-ec85-5e78-d04e5a82d6b1@fb.com>
 <20161025025456.bbruxu4lg25773sl@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, <linux-ext4@vger.kernel.org>,
        <fstests@vger.kernel.org>, <tarasov@vasily.name>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49631 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750800AbcJYDAB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Oct 2016 23:00:01 -0400
In-Reply-To: <20161025025456.bbruxu4lg25773sl@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/24/2016 08:54 PM, Theodore Ts'o wrote:
> On Mon, Oct 24, 2016 at 10:28:14AM -0600, Jens Axboe wrote:
>
>> How about the below? Bump the timeout to 5 min, 1 min is a little on the
>> short side, we want normal error handling to be out of the way before
>> that happens. And additionally, break out if we have been marked as
>> reaped/exited, so we avoid grabbing the stat mutex again.
>
> Yep, that works.  I tried a test with just the second change:
>
>> +		/*
>> +		 * If we took too long to shut down, the main thread could
>> +		 * already consider us reaped/exited. If that happens, break
>> +		 * out and clean up.
>> +		 */
>> +		if (td->runstate >= TD_EXITED)
>> +			break;
>> +
>
> And that's sufficient to solve the problem.

Yes, it should be, so glad that it is!

> Increasing the timeout to 5 minute also would be a good idea, so we
> can let the worker threads exit cleanly so the reported stats will be
> completely accurate.

I made that separate change as well. If the job is stuck in the kernel
for some sync operation, we could feasibly be uninterruptible for
minutes. So 1 minutes is too short in any case, and I'd rather just make
this check than sending kill signals since it won't fix the
uninterruptible problem.

> Thanks for your help in figuring out this long-standing problem!

It was easy based on all your info, since I could not reproduce. So
thanks for your help! Everything should be committed now, and I'll cut a
new release tomorrow so we can hopefully put this behind us.

-- 
Jens Axboe

