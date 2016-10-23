From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Sun, 23 Oct 2016 08:32:49 -0600
Message-ID: <53fe5a98-6ff9-4fa1-e84c-8a3e16cc0f50@fb.com>
References: <20161012211407.GL23194@dastard>
 <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
 <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
 <ffc283a7-58ef-66b9-3c5b-75703d24ea0d@fb.com>
 <20161013231923.j2fidfbtzdp66x3t@thunk.org>
 <20161018180107.fscbfm66yidwhey4@thunk.org>
 <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
 <30fef8cd-67cc-da49-77d9-9d1a833f8a48@fb.com>
 <20161019203233.mbbmskpn5ekgl7og@thunk.org>
 <1fb60e7c-a558-80df-09da-d3c36863a461@fb.com>
 <20161021221551.sdv4hgw33zjxnkvu@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, <linux-ext4@vger.kernel.org>,
        <fstests@vger.kernel.org>, <tarasov@vasily.name>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41834 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754677AbcJWOdR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Oct 2016 10:33:17 -0400
In-Reply-To: <20161021221551.sdv4hgw33zjxnkvu@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/21/2016 04:15 PM, Theodore Ts'o wrote:
> On Thu, Oct 20, 2016 at 08:22:00AM -0600, Jens Axboe wrote:
>>> So what's happening is that generic/299 is looping in the
>>> fallocate/truncate loop until fio exits, but since fio never exits, so
>>> it ends up looping forever.
>>
>> I'm setting up the GCE now, I've had the tests running for about 24h now
>> on another test box and haven't been able to trigger any hangs. I'll
>> match your setup as closely as I can, hopefully that'll work.
>
> Any luck reproducing the problem?
>
> On Wed, Oct 19, 2016 at 08:06:44AM -0600, Jens Axboe wrote:
>>
>> I'll take a look today. I agree, this definitely looks like a fio
>> bug. But not related to the mutex issue for the stat part, all verifier
>> threads are waiting to be woken up, but the main thread is done.
>>
>
> I was taking a closer look at this, and it does look ike it's related
> to the stat_mutex.  The main thread (according to gdb) seems to be
> stuck in this loop in backend.c line 1738 (in thread_main):
>
> 		do {
> 			check_update_rusage(td);
> 			if (!fio_mutex_down_trylock(stat_mutex))
> 				break;
> 			usleep(1000);   <----- line 1738
> 		} while (1);
>
> So it looks like it's not able to grab the stat_mutex.  But I can't
> figure out how the stat_mutex could be down.  None of the strack
> traces seem to show that, and I've looked at all of the places where
> stat_mutex is taken, and it doesn't look like stat_mutex should ever
> be down for more than, say, a second?
>
> So as a temporary workaround, I'm considering adding a check to see if
> we stay stuck in this loop for than a thousand times, and if so, print
> an error to stderr and then call _exit(1), or maybe just break out two
> levels by jumping to line 1778 at "td_set_runstate(td, TD_FINISHING)"
> and just give up on the usage statistics (since for xfstests we really
> don't care about the usage stats).

Very strange. Can you see who the owner is of stat_mutex->lock, that's
the pthread_mutex_t they are sleeping on.

For now, I'll apply the work-around you sent. I haven't been able to
reproduce this, but knowing that it's the stat_mutex will allow me to
better make up a test case to hit it.

-- 
Jens Axboe

