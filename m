From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Wed, 12 Oct 2016 09:46:34 -0600
Message-ID: <6c9630d1-8b3c-5214-cbaf-599d902692aa@fb.com>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard> <20160929043722.ypf3tnxsl6ovt653@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <fstests@vger.kernel.org>,
        <tarasov@vasily.name>
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52513 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932835AbcJLPtZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Oct 2016 11:49:25 -0400
In-Reply-To: <20160929043722.ypf3tnxsl6ovt653@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/28/2016 10:37 PM, Theodore Ts'o wrote:
> On Fri, Jun 19, 2015 at 09:34:30AM +1000, Dave Chinner wrote:
>> On Thu, Jun 18, 2015 at 11:53:37AM -0400, Theodore Ts'o wrote:
>>> I've been trying to figure out why generic/299 has occasionally been
>>> stalling forever.  After taking a closer look, it appears the problem
>>> is that the fio process is stalling in userspace.  Looking at the ps
>>> listing, the fio process hasn't run in over six hours, and using
>>> attaching strace to the fio process, it's stalled in a FUTUEX_WAIT.
>>>
>>> Has anyone else seen this?  I'm using fio 2.2.6, and I have a feeling
>>> that I started seeing this when I started using a newer version of
>>> fio.  So I'm going to try roll back to an older version of fio and see
>>> if that causes the problem to go away.
>>
>> I'm running on fio 2.1.3 at the moment and I havne't seen any
>> problems like this for months. Keep in mind that fio does tend to
>> break in strange ways fairly regularly, so I'd suggest an
>> upgrade/downgrade of fio as your first move.
>
> Out of curiosity, Dave, are you still using fio 2.1.3?  I had upgraded
> to the latest fio to fix other test breaks, and I'm stil seeing the
> occasional generic/299 test failure.  In fact, it's been happening
> often enough on one of my test platforms[1] that I decided to really
> dig down and investigate it, and all of the threads were blocking on
> td->verify_cond in fio's verify.c.
>
> It bisected down to this commit:
>
> commit e5437a073e658e8154b9e87bab5c7b3b06ed4255
> Author: Vasily Tarasov <tarasov@vasily.name>
> Date:   Sun Nov 9 20:22:24 2014 -0700
>
>     Fix for a race when fio prints I/O statistics periodically
>
>     Below is the demonstration for the latest code in git:
>     ...
>
> So generic/299 passes reliably with this commits parent, and it fails
> on this commit within a dozen tries or so.  The commit first landed in
> fio 2.1.14, so it's consistent with Dave's report a year ago he was
> still using fio 2.1.3.
>
> I haven't had time to do a deep analysis on what fio/verify.c does, or
> the above patch, but the good news is that when fio hangs, it's just a
> userspace hang, so I can log into machine and attach a gdb to the
> process.  The code in question isn't very well documented, so I'm
> sending this out in the hopes that Jens and Vasily might see something
> obvious, and because I'm curious whether anyone else has seen this
> (since it seems to be a timing-related race in fio, so it's likely a
> file system independent issue).
>
> Thanks,
>
> 						- Ted
>
> [1] When running xfstests in a Google Compute Engine VM with a
> SSD-backed Persistent disk, using a n1-standard-2 machine type with a
> recent kernel testing with ext4, the command "gce-xfstests -C 100
> generic/299" will hang within a dozen runs of the test, so -C 100 to
> run the test a hundred times was definitely overkill --- in fact
> usually in fio would hang after less than a half-dozen runs.
>
> My bisecting technique (using the infrastructure at
> https://github.com/tytso/xfstests-bld) was:
>
> 	./build-all --fio-only
> 	make tarball
> 	gce-xfstests --update-xfstests -C 100 generic/299
>
> and then wait for an hour or so and see whether or not fio was hanging
> or not, and then follow it up with "(cd fio ; git bisect good)" or
> "(cd fio ; git bisect bad)" as appropriate.  I was using a Debian
> jessie build chroot to compile fio and all of xfstests-bld.

Sorry for being late to the party here, was away. This issue should be
fixed in newer versions. Can you update to current -git and check that
it works without hangs?

-- 
Jens Axboe

