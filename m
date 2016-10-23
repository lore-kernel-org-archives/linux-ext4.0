From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Test generic/299 stalling forever
Date: Sun, 23 Oct 2016 15:33:20 -0400
Message-ID: <20161023193320.rlzlaxdi4vbyu7of@thunk.org>
References: <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
 <ffc283a7-58ef-66b9-3c5b-75703d24ea0d@fb.com>
 <20161013231923.j2fidfbtzdp66x3t@thunk.org>
 <20161018180107.fscbfm66yidwhey4@thunk.org>
 <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
 <30fef8cd-67cc-da49-77d9-9d1a833f8a48@fb.com>
 <20161019203233.mbbmskpn5ekgl7og@thunk.org>
 <1fb60e7c-a558-80df-09da-d3c36863a461@fb.com>
 <20161021221551.sdv4hgw33zjxnkvu@thunk.org>
 <53fe5a98-6ff9-4fa1-e84c-8a3e16cc0f50@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org, tarasov@vasily.name
To: Jens Axboe <axboe@fb.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53fe5a98-6ff9-4fa1-e84c-8a3e16cc0f50@fb.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 23, 2016 at 08:32:49AM -0600, Jens Axboe wrote:
> 
> Very strange. Can you see who the owner is of stat_mutex->lock, that's
> the pthread_mutex_t they are sleeping on.
> 
> For now, I'll apply the work-around you sent. I haven't been able to
> reproduce this, but knowing that it's the stat_mutex will allow me to
> better make up a test case to hit it.

Well, that's the wierd thing.  I can't see anything that could be
holding the stat_mutex.  This is from a somewhat older version of fio
(fio-2.14-27-gafd2cef) but there when things wedged, there were four
threads hanging here (with the exact same stack trace):

Thread 5 (Thread 0x7fb3ddfed700 (LWP 19800)):
#0  pthread_cond_wait@@GLIBC_2.3.2 () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
#1  0x000000000043987b in verify_async_thread (data=0x7fb3c7590610) at verify.c:1241
#2  0x00007fb3dd85d0a4 in start_thread (arg=0x7fb3ddfed700) at pthread_create.c:309
#3  0x00007fb3dd38e62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111

... and the main thread was hanging here:

Thread 1 (Thread 0x7fb3de190740 (LWP 19781)):
#0  0x00007fb3dd35ff2d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
#1  0x00007fb3dd387fb4 in usleep (useconds=<optimized out>) at ../sysdeps/unix/sysv/linux/usleep.c:32
#2  0x000000000045b541 in thread_main (data=0x18fca000) at backend.c:1738
#3  0x000000000045d4d3 in run_threads (sk_out=sk_out@entry=0x0) at backend.c:2268
#4  0x000000000045d80d in fio_backend (sk_out=sk_out@entry=0x0) at backend.c:2400
#5  0x000000000040cbc8 in main (argc=2, argv=0x7ffd24b952e8, envp=<optimized out>) at fio.c:65


The verify threads were waiting td->verify_cond, which it looks like
the main thread was supposed to wakeup in its shutdown sequence when
it calls verify_async_exit(), or if there was work to be done via the
verify_io_u_async() end_io callback.  But the verify threads don't
take the stat_mutex, and the only places that take the stat_mutex in
stat.c and backend.c don't hold it for long, and I can't see any
longjumps or other progam flow discontinuities that could have left
stat_mutex locked.

I'm not an expert on pthreads debugging; is there some way to figure
out ala CONFIG_PROVE_LOCKiNG, which thread took the mutex, and at what
line number?  Or would we need to to try hacking in some kind of mutex
debugging code into fio_mutex_down(), et. al.?

Cheers,

					- Ted
