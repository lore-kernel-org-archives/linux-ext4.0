From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Test generic/299 stalling forever
Date: Sat, 22 Oct 2016 22:02:28 -0400
Message-ID: <20161023020228.gf6lzfw2phca3ykp@thunk.org>
References: <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
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
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org, tarasov@vasily.name
To: Jens Axboe <axboe@fb.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161021221551.sdv4hgw33zjxnkvu@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 21, 2016 at 06:15:51PM -0400, Theodore Ts'o wrote:
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

So I have something very strange to report.  I sync'ed up to the
latest fio repo, at commit e291cff14e97feb3cf.  The problem still
manifests with that commit.  Given what I've observed with a thread
spinning in this do loop, I added this commit:

commit 0f2f71f51595f6b708b801f7ae1dc86c5b2f3705
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Oct 22 10:32:41 2016 -0400

    backend: if we can't grab stat_mutex, report a deadlock error and exit
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/backend.c b/backend.c
index fb2a855..093b6a3 100644
--- a/backend.c
+++ b/backend.c
@@ -1471,6 +1471,7 @@ static void *thread_main(void *data)
 	struct thread_data *td = fd->td;
 	struct thread_options *o = &td->o;
 	struct sk_out *sk_out = fd->sk_out;
+	int deadlock_loop_cnt;
 	int clear_state;
 	int ret;
 
@@ -1731,11 +1732,17 @@ static void *thread_main(void *data)
 		 * the rusage_sem, which would never get upped because
 		 * this thread is waiting for the stat mutex.
 		 */
+		deadlock_loop_cnt = 0;
 		do {
 			check_update_rusage(td);
 			if (!fio_mutex_down_trylock(stat_mutex))
 				break;
 			usleep(1000);
+			if (deadlock_loop_cnt++ > 5000) {
+				log_err("fio seems to be stuck grabbing stat_mutex, forcibly exiting\n");
+				td->error = EDEADLOCK;
+				goto err;
+			}
 		} while (1);
 
 		if (td_read(td) && td->io_bytes[DDIR_READ])

With this commit, the fioe in the generic/299 test no longer hangs.
I've tried running a very large time, and it no longer reproduces at
all.  Specifically, the log_err() and the EDEADLOCK error added by the
patch isn't triggering, and fio is no longer hanging.  So merely
adding loop counter seems to make the problem go away.  Which makes me
wonder if there is either some kind of compiler or code generation
artifact we're seeing.  So I should mention which compiler I'm
currently using:

% schroot -c jessie64 -- gcc --version
gcc (Debian 4.9.2-10) 4.9.2

Anyway, I have a work around that seems to work for me, and which even
if the deadlock_loop counter fires, will at least stop the test run
from hanging.

You may or may not want to include this in the fio upstream repo,
given that I can't explain merely trying to check for the deadlock (or
inability to grab the stat_mute, anyway) makes the deadlock go away.
At least for the purposes of running the test, though, it does seem to
be a valid workaround, though.

Cheers,

						- Ted
