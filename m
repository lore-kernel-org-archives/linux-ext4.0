From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Wed, 12 Oct 2016 20:39:57 -0600
Message-ID: <ffc283a7-58ef-66b9-3c5b-75703d24ea0d@fb.com>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard> <20160929043722.ypf3tnxsl6ovt653@thunk.org>
 <20161012211407.GL23194@dastard>
 <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
 <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, <linux-ext4@vger.kernel.org>,
        <fstests@vger.kernel.org>, <tarasov@vasily.name>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933707AbcJMCl7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Oct 2016 22:41:59 -0400
In-Reply-To: <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/12/2016 08:15 PM, Theodore Ts'o wrote:
> On Wed, Oct 12, 2016 at 03:19:25PM -0600, Jens Axboe wrote:
>>
>> FWIW, this is the commit that fixes it:
>>
>> commit 39d13e67ef1f4b327c68431f8daf033a03920117
>> Author: Jens Axboe <axboe@fb.com>
>> Date:   Fri Aug 26 14:39:30 2016 -0600
>>
>>     backend: check if we need to update rusage stats, if stat_mutex is busy
>>
>> 2.14 and newer should not have the problem, but earlier versions may
>> depending on how old...
>
> Unfortunately, I'm still seeing hangs in generic/299 with the latest version of fio:
>
> fio 	  fio-2.14-10-g0a301e9 (Fri, 23 Sep 2016 11:57:00 -0600)

Well, that's no good.

> If I use an older fio, it reliably does not hang.  What can I do to
> help debug this?

If I just wanted to invoke generic/299 with a setup similar to yours,
what should I do? I can attempt to reproduce it.

> As I said, I can attach to the hanging fio using a gdb and give you
> stackdumps for all of the threads if that would be helpful.

That would definitely be helpful as well, especially if I cannot
reproduce it.

-- 
Jens Axboe

