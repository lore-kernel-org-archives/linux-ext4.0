From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Sun, 23 Oct 2016 19:41:19 -0600
Message-ID: <a0243502-fafe-66f3-9ca1-41cc3048bece@fb.com>
References: <ffc283a7-58ef-66b9-3c5b-75703d24ea0d@fb.com>
 <20161013231923.j2fidfbtzdp66x3t@thunk.org>
 <20161018180107.fscbfm66yidwhey4@thunk.org>
 <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
 <30fef8cd-67cc-da49-77d9-9d1a833f8a48@fb.com>
 <20161019203233.mbbmskpn5ekgl7og@thunk.org>
 <1fb60e7c-a558-80df-09da-d3c36863a461@fb.com>
 <20161021221551.sdv4hgw33zjxnkvu@thunk.org>
 <53fe5a98-6ff9-4fa1-e84c-8a3e16cc0f50@fb.com>
 <20161023193320.rlzlaxdi4vbyu7of@thunk.org>
 <20161023212408.cjqmnzw3547ujzil@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, <linux-ext4@vger.kernel.org>,
        <fstests@vger.kernel.org>, <tarasov@vasily.name>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37710 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752089AbcJXBlr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Oct 2016 21:41:47 -0400
In-Reply-To: <20161023212408.cjqmnzw3547ujzil@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/23/2016 03:24 PM, Theodore Ts'o wrote:
> OK, perhaps this is helpful.  I reverted my last patch (so I could
> repro the problem), and then added the following patch to fio/mutex.c
> (see below).
>
> When it hung, I got the following stack trace on the main thread:
>
> (gdb) where
> #0  0x00007ff8c018cf2d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
> #1  0x00007ff8c01b4fb4 in usleep (useconds=<optimized out>)
>     at ../sysdeps/unix/sysv/linux/usleep.c:32
>     #2  0x000000000045b691 in thread_main (data=0x1bc64000) at backend.c:1738
>     #3  0x000000000045d623 in run_threads (sk_out=sk_out@entry=0x0) at backend.c:2268
>     #4  0x000000000045d95d in fio_backend (sk_out=sk_out@entry=0x0) at backend.c:2400
>     #5  0x000000000040cc18 in main (argc=2, argv=0x7fff8446f0d8, envp=<optimized out>) at fio.c:65
>
> .... and it looks like the reason why we can't take the mutex is that
> somehow some thread managed to call stat_exit(), which calls
> fio_mutex_down() followed by fio_mutex_remove():
>
> (gdb) p (void *) stat_mutex->owner
> $4 = (void *) 0x42fd60 <stat_exit+16>
>
> How this could have happened, I have no idea.  The only call to
> stat_exit() appears to be at the end of fio_backend(), and the main
> thread is still in the middle of calling thread_main() which is called
> by run_threads().
>
> Do you have any thoughts?  Let me know if there's something I can try.

Wow, that is very odd. That should only be possible if the main thread
exits too early, and calls stat_exit() while we still have jobs running.
That should trigger other funkiness too. I have no idea how that is
happening, but it obviously is since your debugging patch showed that
stat_exit() owns the mutex.

But this gives me more to work from, very useul, thanks Ted! I'll pound
on this tomorrow.

-- 
Jens Axboe

