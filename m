From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Test generic/299 stalling forever
Date: Sun, 23 Oct 2016 17:24:08 -0400
Message-ID: <20161023212408.cjqmnzw3547ujzil@thunk.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org, tarasov@vasily.name
To: Jens Axboe <axboe@fb.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161023193320.rlzlaxdi4vbyu7of@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

OK, perhaps this is helpful.  I reverted my last patch (so I could
repro the problem), and then added the following patch to fio/mutex.c
(see below).

When it hung, I got the following stack trace on the main thread:

(gdb) where
#0  0x00007ff8c018cf2d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
#1  0x00007ff8c01b4fb4 in usleep (useconds=<optimized out>)
    at ../sysdeps/unix/sysv/linux/usleep.c:32
    #2  0x000000000045b691 in thread_main (data=0x1bc64000) at backend.c:1738
    #3  0x000000000045d623 in run_threads (sk_out=sk_out@entry=0x0) at backend.c:2268
    #4  0x000000000045d95d in fio_backend (sk_out=sk_out@entry=0x0) at backend.c:2400
    #5  0x000000000040cc18 in main (argc=2, argv=0x7fff8446f0d8, envp=<optimized out>) at fio.c:65

.... and it looks like the reason why we can't take the mutex is that
somehow some thread managed to call stat_exit(), which calls
fio_mutex_down() followed by fio_mutex_remove():

(gdb) p (void *) stat_mutex->owner
$4 = (void *) 0x42fd60 <stat_exit+16>

How this could have happened, I have no idea.  The only call to
stat_exit() appears to be at the end of fio_backend(), and the main
thread is still in the middle of calling thread_main() which is called
by run_threads().

Do you have any thoughts?  Let me know if there's something I can try.

       	    		       	       - Ted


diff --git a/mutex.c b/mutex.c
index 7580922..26e2955 100644
--- a/mutex.c
+++ b/mutex.c
@@ -108,6 +108,8 @@ int __fio_mutex_init(struct fio_mutex *mutex, int value)
 
 	mutex->value = value;
 	mutex->magic = FIO_MUTEX_MAGIC;
+	if (!value)
+		mutex->owner = __builtin_return_address(0);
 
 	ret = mutex_cond_init_pshared(&mutex->lock, &mutex->cond);
 	if (ret)
@@ -128,8 +130,11 @@ struct fio_mutex *fio_mutex_init(int value)
 		return NULL;
 	}
 
-	if (!__fio_mutex_init(mutex, value))
+	if (!__fio_mutex_init(mutex, value)) {
+		if (!value)
+			mutex->owner = __builtin_return_address(0);
 		return mutex;
+	}
 
 	fio_mutex_remove(mutex);
 	return NULL;
@@ -194,7 +199,13 @@ bool fio_mutex_down_trylock(struct fio_mutex *mutex)
 
 	pthread_mutex_lock(&mutex->lock);
 	if (mutex->value) {
+		if (mutex->value > 1) {
+			log_err("Completely bogus mutex value?!? (%d, %p)\n",
+				mutex->value, mutex->owner);
+			abort();
+		}
 		mutex->value--;
+		mutex->owner = __builtin_return_address(0);
 		ret = false;
 	}
 	pthread_mutex_unlock(&mutex->lock);
@@ -215,6 +226,7 @@ void fio_mutex_down(struct fio_mutex *mutex)
 	}
 
 	mutex->value--;
+	mutex->owner = __builtin_return_address(0);
 	pthread_mutex_unlock(&mutex->lock);
 }
 
@@ -228,6 +240,8 @@ void fio_mutex_up(struct fio_mutex *mutex)
 	read_barrier();
 	if (!mutex->value && mutex->waiters)
 		do_wake = 1;
+	if (!mutex->value)
+		mutex->owner = 0;
 	mutex->value++;
 	pthread_mutex_unlock(&mutex->lock);
 
diff --git a/mutex.h b/mutex.h
index 54009ba..ea43845 100644
--- a/mutex.h
+++ b/mutex.h
@@ -13,6 +13,7 @@ struct fio_mutex {
 	int value;
 	int waiters;
 	int magic;
+	unsigned long owner;
 };
 
 struct fio_rwlock {


P.P.S.  As before, the only other reads are the verify threads:

(gdb)  thread apply all bt

Thread 5 (Thread 0x7ff8c0e1a700 (LWP 13147)):
#0  pthread_cond_wait@@GLIBC_2.3.2 ()
    at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
#1  0x00000000004398cb in verify_async_thread (data=0x7ff8aa3bd610) at verify.c:1241
#2  0x00007ff8c068a0a4 in start_thread (arg=0x7ff8c0e1a700) at pthread_create.c:309
#3  0x00007ff8c01bb62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111

Thread 4 (Thread 0x7ff8c0e12700 (LWP 13148)):
#0  pthread_cond_wait@@GLIBC_2.3.2 ()
    at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
#1  0x00000000004398cb in verify_async_thread (data=0x7ff8aa3bd610) at verify.c:1241
#2  0x00007ff8c068a0a4 in start_thread (arg=0x7ff8c0e12700) at pthread_create.c:309
#3  0x00007ff8c01bb62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111

Thread 3 (Thread 0x7ff8c0e0a700 (LWP 13149)):
#0  pthread_cond_wait@@GLIBC_2.3.2 ()
    at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
#1  0x00000000004398cb in verify_async_thread (data=0x7ff8aa3bd610) at verify.c:1241
#2  0x00007ff8c068a0a4 in start_thread (arg=0x7ff8c0e0a700) at pthread_create.c:309
#3  0x00007ff8c01bb62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111

Thread 2 (Thread 0x7ff8c0e02700 (LWP 13150)):
#0  pthread_cond_wait@@GLIBC_2.3.2 ()
    at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
#1  0x00000000004398cb in verify_async_thread (data=0x7ff8aa3bd610) at verify.c:1241
#2  0x00007ff8c068a0a4 in start_thread (arg=0x7ff8c0e02700) at pthread_create.c:309
#3  0x00007ff8c01bb62d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:111

Thread 1 (Thread 0x7ff8c0fbd740 (LWP 13139)):
#0  0x00007ff8c018cf2d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
#1  0x00007ff8c01b4fb4 in usleep (useconds=<optimized out>)
    at ../sysdeps/unix/sysv/linux/usleep.c:32
#2  0x000000000045b691 in thread_main (data=0x1bc64000) at backend.c:1738
#3  0x000000000045d623 in run_threads (sk_out=sk_out@entry=0x0) at backend.c:2268
#4  0x000000000045d95d in fio_backend (sk_out=sk_out@entry=0x0) at backend.c:2400
#5  0x000000000040cc18 in main (argc=2, argv=0x7fff8446f0d8, envp=<optimized out>) at fio.c:65
(gdb) 
