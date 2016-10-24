From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Mon, 24 Oct 2016 10:28:14 -0600
Message-ID: <773e0780-6641-ec85-5e78-d04e5a82d6b1@fb.com>
References: <20161013231923.j2fidfbtzdp66x3t@thunk.org>
 <20161018180107.fscbfm66yidwhey4@thunk.org>
 <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
 <30fef8cd-67cc-da49-77d9-9d1a833f8a48@fb.com>
 <20161019203233.mbbmskpn5ekgl7og@thunk.org>
 <1fb60e7c-a558-80df-09da-d3c36863a461@fb.com>
 <20161021221551.sdv4hgw33zjxnkvu@thunk.org>
 <53fe5a98-6ff9-4fa1-e84c-8a3e16cc0f50@fb.com>
 <20161023193320.rlzlaxdi4vbyu7of@thunk.org>
 <20161023212408.cjqmnzw3547ujzil@thunk.org>
 <20161024033852.quinlee4a24mb2e2@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, <linux-ext4@vger.kernel.org>,
        <fstests@vger.kernel.org>, <tarasov@vasily.name>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965167AbcJXQ20 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Oct 2016 12:28:26 -0400
In-Reply-To: <20161024033852.quinlee4a24mb2e2@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/23/2016 09:38 PM, Theodore Ts'o wrote:
> I enabled some more debugging and it's become more clear what's going
> on.   (See attached for the full log).
>
> The main issue seems to be that once one of fio is done, it kills off
> the other threads (actually, we're using processes):
>
> process  31848 terminate group_id=0
> process  31848 setting terminate on direct_aio/31846
> process  31848 setting terminate on direct_aio/31848
> process  31848 setting terminate on direct_aio/31849
> process  31848 setting terminate on direct_aio/31851
> process  31848 setting terminate on aio-dio-verifier/31852
> process  31848 setting terminate on buffered-aio-verifier/31854
> process  31851 pid=31851: runstate RUNNING -> FINISHING
> process  31851 terminate group_id=0
> process  31851 setting terminate on direct_aio/31846
> process  31851 setting terminate on direct_aio/31848
> process  31851 setting terminate on direct_aio/31849
> process  31851 setting terminate on direct_aio/31851
> process  31851 setting terminate on aio-dio-verifier/31852
> process  31851 setting terminate on buffered-aio-verifier/31854
> process  31852 pid=31852: runstate RUNNING -> FINISHING
> process  31846 pid=31846: runstate RUNNING -> FINISHING
>     ...
>
> but one or more of the threads doesn't exit within 60 seconds:
>
> fio: job 'direct_aio' (state=5) hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
> process  31794 pid=31849: runstate RUNNING -> REAPED
> fio: job 'buffered-aio-verifier' (state=5) hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
> process  31794 pid=31854: runstate RUNNING -> REAPED
> process  31794 terminate group_id=-1
>
> The main thread then prints all of the statistics, and calls stat_exit():
>
> stat_exit called by tid: 31794       <---- debugging message which prints gettid()
>
> Unfortunately, this process(es) aren't actually, killed, they are
> marked as reap, but they are still in the process listing:
>
> root@xfstests:~# ps augxww | grep fio
> root      1585  0.0  0.0      0     0 ?        S<   18:45   0:00 [dm_bufio_cache]
> root      7191  0.0  0.0  12732  2200 pts/1    S+   23:05   0:00 grep fio
> root     31849  1.5  0.2 407208 18876 ?        Ss   22:36   0:26 /root/xfstests/bin/fio /tmp/31503.fio
> root     31854  1.2  0.1 398480 10240 ?        Ssl  22:36   0:22 /root/xfstests/bin/fio /tmp/31503.fio
>
> And if you attach to them with a gdb, they are spinning trying to grab
> the stat_mutex(), which they can't get because the main thread has
> already called stat_exit() and then has exited.  So these two threads
> did eventually return, but some time after 60 seconds had passed, and
> then they hung waiting for stat_mutex(), which they will never get
> because the main thread has already called stat_exit().
>
> This probably also explains why you had trouble reproducing it.  It
> requires a disk whose performance is variable enougoh that under heavy
> load, it might take more than 60 seconds for the direct_aio or
> buffered-aio-verifier thread to close itself out.

Good catch! Yes, that could certainly explain why we are stuck on that 
stat_mutex and why the main thread just gave up on it and ended up in 
stat_exit() with a thread (or more) still running.

> And I suspect once the main thread exited, it probably also closed out
> the debugging channel so the deadlock detector did probably trip, but
> somehow we just didn't see the output.
>
> So I can imagine some possible fixes.  We could make the thread
> timeout configurable, and/or increase it from 60 seconds to something like
> 300 seconds.  We could make stat_exit() a no-op --- after all, if the
> main thread is exiting, there's no real point to down and then destroy
> the stat_mutex.  And/or we could change the forced reap to send a kill
> -9 to the thread, and instead of maring it as reaped.

We have to clean up - for normal runs, it's not a big deal, but if fio
is run as a client/server setup, the backend will persist across runs.
If we leak, then that could be a concern.

How about the below? Bump the timeout to 5 min, 1 min is a little on the
short side, we want normal error handling to be out of the way before
that happens. And additionally, break out if we have been marked as
reaped/exited, so we avoid grabbing the stat mutex again.


diff --git a/backend.c b/backend.c
index 093b6a3a290e..f0927abfccb0 100644
--- a/backend.c
+++ b/backend.c
@@ -1723,6 +1723,14 @@ static void *thread_main(void *data)
  			}
  		}

+		/*
+		 * If we took too long to shut down, the main thread could
+		 * already consider us reaped/exited. If that happens, break
+		 * out and clean up.
+		 */
+		if (td->runstate >= TD_EXITED)
+			break;
+
  		clear_state = 1;

  		/*
diff --git a/fio.h b/fio.h
index 080842aef4f8..74c1b306af26 100644
--- a/fio.h
+++ b/fio.h
@@ -588,7 +588,7 @@ extern const char *runstate_to_name(int runstate);
   * Allow 60 seconds for a job to quit on its own, otherwise reap with
   * a vengeance.
   */
-#define FIO_REAP_TIMEOUT	60
+#define FIO_REAP_TIMEOUT	300

  #define TERMINATE_ALL		(-1U)
  extern void fio_terminate_threads(unsigned int);

-- 
Jens Axboe

