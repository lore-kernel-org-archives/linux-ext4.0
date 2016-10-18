From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Test generic/299 stalling forever
Date: Tue, 18 Oct 2016 14:01:07 -0400
Message-ID: <20161018180107.fscbfm66yidwhey4@thunk.org>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard>
 <20160929043722.ypf3tnxsl6ovt653@thunk.org>
 <20161012211407.GL23194@dastard>
 <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
 <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
 <ffc283a7-58ef-66b9-3c5b-75703d24ea0d@fb.com>
 <20161013231923.j2fidfbtzdp66x3t@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org, tarasov@vasily.name
To: Jens Axboe <axboe@fb.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161013231923.j2fidfbtzdp66x3t@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jens, ping?

Have you had a chance to take a look at the stack traces?  Is there
any other debugging information I can get for you?

Thanks,

					- Ted

On Thu, Oct 13, 2016 at 07:19:23PM -0400, Theodore Ts'o wrote:
> On Wed, Oct 12, 2016 at 08:39:57PM -0600, Jens Axboe wrote:
> > 
> > If I just wanted to invoke generic/299 with a setup similar to yours,
> > what should I do? I can attempt to reproduce it.
> 
> Well, if you're willing to get a Google Compute Engine account (it
> will come with a $300 free trial credit, which is plenty for this
> exercise), the simplest way to do an exact reproduction would be to
> follow the instructions here:
> 
> https://github.com/tytso/xfstests-bld/blob/master/Documentation/gce-xfstests.md
> 
> If you use the current default gce-xfstests image, which is
> xfstests-201610131131 in the xfstests-cloud project, what I run which
> triggers it quite reliably is:
> 
> gce-xfstests -C 10 generic/299
> 
> On a run that I just did using a 4.8.0+ kernel, it ran 12 times (10
> times with the 4k configuration, and then 2 times with the 1k
> configuration) before it hung.
> 
> FSTESTIMG: xfstests-cloud/xfstests-201610131131
> FSTESTVER: e2fsprogs	v1.43.3-30-g8df85fb (Sun, 4 Sep 2016 21:32:35 -0400)
> FSTESTVER: fio		fio-2.14-27-gafd2cef (Wed, 12 Oct 2016 08:59:25 -0600)
> FSTESTVER: quota	81aca5c (Tue, 12 Jul 2016 16:15:45 +0200)
> FSTESTVER: xfsprogs	v4.5.0 (Tue, 15 Mar 2016 15:25:56 +1100)
> FSTESTVER: xfstests-bld	de1a881 (Fri, 30 Sep 2016 18:23:15 -0400)
> FSTESTVER: xfstests	linux-v3.8-1200-g218a62d (Thu, 29 Sep 2016 23:30:27 -0400)
> FSTESTVER: kernel	4.8.0-ext4-14234-gfb44543 #21 SMP Wed Oct 12 23:40:33 EDT 2016 x86_64
> 
> So on a system which was hung in this way, I ran "apt-get update ;
> apt-get install gdb", and uploaded the build tree (plus source code
> for the fio used to build the image) to /root/fio.
> 
> root@xfstests-201610131148:~# ps axm -o pid,tid,class,pri,psr,pcpu,stat,wchan:20,comm
>   PID   TID CLS PRI PSR %CPU STAT WCHAN                COMMAND
> 	....
> 19781     - -     -   -  1.6 -    -                    fio
>     - 19781 TS   19   0  1.6 Ssl  hrtimer_nanosleep    -
>     - 19800 TS   19   0  0.0 Ssl  futex_wait_queue_me  -
>     - 19801 TS   19   0  0.0 Ssl  futex_wait_queue_me  -
>     - 19802 TS   19   0  0.0 Ssl  futex_wait_queue_me  -
>     - 19803 TS   19   0  0.0 Ssl  futex_wait_queue_me  -
> 	....
> root@xfstests-201610131148:~# gdb /root/fio/fio
> 	....
> (gdb) dir /root/fio
> Source directories searched: /root/fio:$cdir:$cwd
> (gdb) attach 19781
> Attaching to program: /root/fio/fio, process 19781
> 	....
> (gdb) thread apply all bt
> 
> Thread 5 (Thread 0x7fb3ddfed700 (LWP 19800)):
> #0  pthread_cond_wait@@GLIBC_2.3.2 () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
> #1  0x000000000043987b in verify_async_thread (data=0x7fb3c7590610) at verify.c:1241
> #2  0x00007fb3dd85d0a4 in start_thread (arg=0x7fb3ddfed700) at pthread_create.c:309
> #3  0x00007fb3dd38e62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111
> 
> Thread 4 (Thread 0x7fb3ddfe5700 (LWP 19801)):
> #0  pthread_cond_wait@@GLIBC_2.3.2 () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
> #1  0x000000000043987b in verify_async_thread (data=0x7fb3c7590610) at verify.c:1241
> #2  0x00007fb3dd85d0a4 in start_thread (arg=0x7fb3ddfe5700) at pthread_create.c:309
> #3  0x00007fb3dd38e62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111
> 
> Thread 3 (Thread 0x7fb3ddfdd700 (LWP 19802)):
> #0  pthread_cond_wait@@GLIBC_2.3.2 () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
> #1  0x000000000043987b in verify_async_thread (data=0x7fb3c7590610) at verify.c:1241
> #2  0x00007fb3dd85d0a4 in start_thread (arg=0x7fb3ddfdd700) at pthread_create.c:309
> #3  0x00007fb3dd38e62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111
> 
> Thread 2 (Thread 0x7fb3ddfd5700 (LWP 19803)):
> #0  pthread_cond_wait@@GLIBC_2.3.2 () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
> #1  0x000000000043987b in verify_async_thread (data=0x7fb3c7590610) at verify.c:1241
> #2  0x00007fb3dd85d0a4 in start_thread (arg=0x7fb3ddfd5700) at pthread_create.c:309
> #3  0x00007fb3dd38e62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111
> 
> Thread 1 (Thread 0x7fb3de190740 (LWP 19781)):
> #0  0x00007fb3dd35ff2d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
> #1  0x00007fb3dd387fb4 in usleep (useconds=<optimized out>) at ../sysdeps/unix/sysv/linux/usleep.c:32
> #2  0x000000000045b541 in thread_main (data=0x18fca000) at backend.c:1738
> #3  0x000000000045d4d3 in run_threads (sk_out=sk_out@entry=0x0) at backend.c:2268
> #4  0x000000000045d80d in fio_backend (sk_out=sk_out@entry=0x0) at backend.c:2400
> #5  0x000000000040cbc8 in main (argc=2, argv=0x7ffd24b952e8, envp=<optimized out>) at fio.c:65
> 
> (gdb) thread apply all bt full
> 
> Thread 5 (Thread 0x7fb3ddfed700 (LWP 19800)):
> #0  pthread_cond_wait@@GLIBC_2.3.2 () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
> No locals.
> #1  0x000000000043987b in verify_async_thread (data=0x7fb3c7590610) at verify.c:1241
>         list = {next = 0x7fb3ddfeced0, prev = 0x7fb3ddfeced0}
>         td = 0x7fb3c7590610
>         io_u = 0x202fac0
>         ret = 0
> #2  0x00007fb3dd85d0a4 in start_thread (arg=0x7fb3ddfed700) at pthread_create.c:309
>         __res = <optimized out>
>         pd = 0x7fb3ddfed700
>         now = <optimized out>
>         unwind_buf = {cancel_jmp_buf = {{jmp_buf = {140410500339456, -2782054375790187915, 0, 140410502103136, 140410120428088, 
>                 140410500339456, 2739195402349996661, 2739194912765274741}, mask_was_saved = 0}}, priv = {pad = {0x0, 0x0, 0x0, 0x0}, 
>             data = {prev = 0x0, cleanup = 0x0, canceltype = 0}}}
>         not_first_call = <optimized out>
>         pagesize_m1 = <optimized out>
>         sp = <optimized out>
>         freesize = <optimized out>
>         __PRETTY_FUNCTION__ = "start_thread"
> #3  0x00007fb3dd38e62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111
> No locals.
> 
> Thread 4 (Thread 0x7fb3ddfe5700 (LWP 19801)):
> #0  pthread_cond_wait@@GLIBC_2.3.2 () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
> No locals.
> #1  0x000000000043987b in verify_async_thread (data=0x7fb3c7590610) at verify.c:1241
>         list = {next = 0x7fb3ddfe4ed0, prev = 0x7fb3ddfe4ed0}
>         td = 0x7fb3c7590610
>         io_u = 0x203d280
>         ret = 0
> #2  0x00007fb3dd85d0a4 in start_thread (arg=0x7fb3ddfe5700) at pthread_create.c:309
>         __res = <optimized out>
>         pd = 0x7fb3ddfe5700
>         now = <optimized out>
>         unwind_buf = {cancel_jmp_buf = {{jmp_buf = {140410500306688, -2782054375790187915, 0, 140410502103136, 140410120428088, 
>                 140410500306688, 2739195406644963957, 2739194912765274741}, mask_was_saved = 0}}, priv = {pad = {0x0, 0x0, 0x0, 0x0}, 
>             data = {prev = 0x0, cleanup = 0x0, canceltype = 0}}}
>         not_first_call = <optimized out>
>         pagesize_m1 = <optimized out>
>         sp = <optimized out>
>         freesize = <optimized out>
>         __PRETTY_FUNCTION__ = "start_thread"
> #3  0x00007fb3dd38e62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111
> No locals.
> 
> Thread 3 (Thread 0x7fb3ddfdd700 (LWP 19802)):
> ---Type <return> to continue, or q <return> to quit---
> #0  pthread_cond_wait@@GLIBC_2.3.2 () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
> No locals.
> #1  0x000000000043987b in verify_async_thread (data=0x7fb3c7590610) at verify.c:1241
>         list = {next = 0x7fb3ddfdced0, prev = 0x7fb3ddfdced0}
>         td = 0x7fb3c7590610
>         io_u = 0x203cf80
>         ret = 0
> #2  0x00007fb3dd85d0a4 in start_thread (arg=0x7fb3ddfdd700) at pthread_create.c:309
>         __res = <optimized out>
>         pd = 0x7fb3ddfdd700
>         now = <optimized out>
>         unwind_buf = {cancel_jmp_buf = {{jmp_buf = {140410500273920, -2782054375790187915, 0, 140410502103136, 140410120428088, 
>                 140410500273920, 2739195393760062069, 2739194912765274741}, mask_was_saved = 0}}, priv = {pad = {0x0, 0x0, 0x0, 0x0}, 
>             data = {prev = 0x0, cleanup = 0x0, canceltype = 0}}}
>         not_first_call = <optimized out>
>         pagesize_m1 = <optimized out>
>         sp = <optimized out>
>         freesize = <optimized out>
>         __PRETTY_FUNCTION__ = "start_thread"
> #3  0x00007fb3dd38e62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111
> No locals.
> 
> Thread 2 (Thread 0x7fb3ddfd5700 (LWP 19803)):
> #0  pthread_cond_wait@@GLIBC_2.3.2 () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
> No locals.
> #1  0x000000000043987b in verify_async_thread (data=0x7fb3c7590610) at verify.c:1241
>         list = {next = 0x7fb3ddfd4ed0, prev = 0x7fb3ddfd4ed0}
>         td = 0x7fb3c7590610
>         io_u = 0x203ccc0
>         ret = 0
> #2  0x00007fb3dd85d0a4 in start_thread (arg=0x7fb3ddfd5700) at pthread_create.c:309
>         __res = <optimized out>
>         pd = 0x7fb3ddfd5700
>         now = <optimized out>
>         unwind_buf = {cancel_jmp_buf = {{jmp_buf = {140410500241152, -2782054375790187915, 0, 140410502103136, 140410120428088, 
>                 140410500241152, 2739195398055029365, 2739194912765274741}, mask_was_saved = 0}}, priv = {pad = {0x0, 0x0, 0x0, 0x0}, 
>             data = {prev = 0x0, cleanup = 0x0, canceltype = 0}}}
>         not_first_call = <optimized out>
>         pagesize_m1 = <optimized out>
>         sp = <optimized out>
>         freesize = <optimized out>
>         __PRETTY_FUNCTION__ = "start_thread"
> #3  0x00007fb3dd38e62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111
> No locals.
> 
> Thread 1 (Thread 0x7fb3de190740 (LWP 19781)):
> #0  0x00007fb3dd35ff2d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
> No locals.
> ---Type <return> to continue, or q <return> to quit---
> #1  0x00007fb3dd387fb4 in usleep (useconds=<optimized out>) at ../sysdeps/unix/sysv/linux/usleep.c:32
>         ts = {tv_sec = 0, tv_nsec = 1000000}
> #2  0x000000000045b541 in thread_main (data=0x18fca000) at backend.c:1738
>         verify_bytes = 419209216
>         elapsed_us = {0, 0, 0}
>         td = 0x7fb3c7590610
>         sk_out = 0x2039600
>         clear_state = 33789440
> #3  0x000000000045d4d3 in run_threads (sk_out=sk_out@entry=0x0) at backend.c:2268
>         ret = <optimized out>
>         pid = <optimized out>
>         this_jobs = 6
>         fd = 0x2029720
>         map = {0x7fb3c754c000, 0x7fb3c7559ad0, 0x7fb3c75675a0, 0x7fb3c7575070, 0x7fb3c7582b40, 0x7fb3c7590610, 0x0 <repeats 11 times>, 
>           0x10000000, 0x0 <repeats 771 times>, 0x7fb3ddf83c1c <check_match+300>, 0x0, 0xd827524, 0x5, 0x7, 0x7fb3de192040, 
>           0x7fb3ddf8458e <do_lookup_x+2334>, 0x0, 0x7ffd24b8ea80, 0x7fb3dd2a9d28, 0x7fb3dd2af020, 0x7ffd24b8eb90, 0x3609d4, 
>           0x7ffd24b8eb80, 0x0, 0x0, 0x7fb3de1920c0, 0x7fb3de1939d8, 0x406851, 0x7fb3dd2b6d78, 0x401e18, 0x100000000, 0x100000375, 0x0, 
>           0x7fb3de1920c0, 0x7ffd24b8ec20, 0x7fb3de19d500, 0x7ffd24b8ec48, 0x7fb3de19d1a8, 0x1, 
>           0x7fb3ddf8473d <_dl_lookup_symbol_x+349>, 0x0, 0x7fb3de1920c0, 0x1, 0x0, 0x1, 0x7fb3de19d1a8, 0x0, 0x0, 0x0, 0x0, 0x0, 
>           0x7fb3de19d500, 0x7ffd24b8eb90, 0x7ffd24b8eb80, 0xd827524, 0x406851, 0xffffffff, 0x0, 0x7fb3dd2af020, 0x7fb3de1939d8, 
>           0x0 <repeats 11 times>, 0x698620 <memcmp@got.plt>, 0x0, 0x7ffd24b8ecf8, 0x7ffd24b8ecf8, 0x3, 0x7ffd24b8f6f0, 
>           0x7fb3ddf88ecc <_dl_fixup+508>, 0x9000000000001, 0x0, 0x8ff5c28f5c28f, 0x7fb3dd2af020, 0x140, 0x7ffd24b8f6f0, 
>           0x7ffd24b91720, 0x7fb3ddf8f2e5 <_dl_runtime_resolve+53>, 0x0, 0x20262a0, 0x2bc4, 0x7ffd24b92530, 0x7ffd24b8f960, 
>           0x8ff5c28f5c200, 0x2026270, 0x7fb3de19d1a8, 0x54, 0x46144b <fio_test_cconv+3595>, 0x0, 0x7ffd24b8ece0, 
>           0x0 <repeats 16 times>, 0x2026210, 0x0, 0x2026270, 0x0, 0x1, 0x40000000400, 0x1, 0x0, 0x1, 0x100000001, 0x100000000, 0x0, 
>           0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x100000001000, 0x1000, 0x0 <repeats 14 times>, 0x1, 0x0, 0x100000000, 0x100000001, 0x0, 0x0, 
>           0x0, 0x100000001, 0x400, 0x0 <repeats 87 times>, 0x100000000, 0x100000000, 0x0, 0x89, 0x0 <repeats 20 times>, 0x6400000000, 
>           0x6400000064, 0x200000, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1f400000000, 0x1000001f4...}
>         this_start = {tv_sec = 0, tv_usec = 0}
>         left = <optimized out>
>         td = 0x7fb3c7590610
>         i = 5
>         todo = 6
>         nr_running = 0
>         m_rate = 0
>         t_rate = 0
>         nr_started = 6
>         spent = <optimized out>
> #4  0x000000000045d80d in fio_backend (sk_out=sk_out@entry=0x0) at backend.c:2400
>         td = <optimized out>
>         i = <optimized out>
> #5  0x000000000040cbc8 in main (argc=2, argv=0x7ffd24b952e8, envp=<optimized out>) at fio.c:65
>         ret = 1
> 
> > > As I said, I can attach to the hanging fio using a gdb and give you
> > > stackdumps for all of the threads if that would be helpful.
> > 
> > That would definitely be helpful as well, especially if I cannot
> > reproduce it.
> 
> Here you go!
> 
> If I kill -9 the fio process, the tests continue to run, and there are
> no kernel complaints, so I'm pretty sure this is a fio issue.
> 
> Many thanks!!
> 
>    	  	      	     	    	 - Ted
> 
> P.S.  In answer to your question from another e-mail message on this
> thread, the block device in volved is a Google Compute Engine
> Persistent Disk device backed using an SSD.  To a very *rough*
> approximation, think about something kinda like a qemu qcow image on
> an very fast flash device in terms of performance.  I've seen
> the problem before on a 5400 RPM laptop drive, but it's ***much***
> rarer.   It reproduces much more easily faster block devices.
> 
> P.P.S.   And here's the fio job file that it was running:
> 
> ###########
> # 299 test fio activity
> # Filenames derived from jobsname and jobid like follows:
> # ..
> [global]
> ioengine=libaio
> bs=128k
> directory=/xt-vdc
> filesize=5368709120
> size=999G
> iodepth=128*1
> continue_on_error=write
> ignore_error=,ENOSPC
> error_dump=0
> create_on_open=1
> fallocate=none
> exitall=1
> 
> ## Perform direct aio, to files which may be truncated
> ## by external task
> [direct_aio]
> direct=1
> buffered=0
> numjobs=4
> rw=randwrite
> runtime=100*1
> time_based
> 
> # Perform direct aio and verify data
> # This test case should check use-after-free issues
> [aio-dio-verifier]
> numjobs=1
> verify=crc32c-intel
> verify_fatal=1
> verify_dump=1
> verify_backlog=1024
> verify_async=4
> verifysort=1
> direct=1
> bs=4k
> rw=randrw
> filename=aio-dio-verifier
> 
> # Perform buffered aio and verify data
> # This test case should check use-after-free issues
> [buffered-aio-verifier]
> numjobs=1
> verify=crc32c-intel
> verify_fatal=1
> verify_dump=1
> verify_backlog=1024
> verify_async=4
> verifysort=1
> direct=0
> buffered=1
> bs=4k
> rw=randrw
> filename=buffered-aio-verifier
