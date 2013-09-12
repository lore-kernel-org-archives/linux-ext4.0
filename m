From: Cuong Tran <cuonghuutran@gmail.com>
Subject: Java Stop-the-World GC stall induced by FS flush or many large file deletions
Date: Wed, 11 Sep 2013 21:17:26 -0700
Message-ID: <CALQm4jhE8aRjOsK2HpSuqNCzNqZm5RU9QOJi0q0SwgR=1JKZsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We have seen GC stalls that are NOT due to memory usage of applications.

GC log reports the CPU user and system time of GC threads, which are
almost 0, and stop-the-world time, which can be multiple seconds. This
indicates GC threads are waiting for IO but GC threads should be
CPU-bound in user mode.

We could reproduce the problems using a simple Java program that just
appends to a log file via log4j. If the test just runs by itself, it
does not incur any GC stalls. However, if we run a script that enters
a loop to create multiple large file via falloc() and then deletes
them, then GC stall of 1+ seconds can happen fairly predictably.

We can also reproduce the problem by periodically switch the log and
gzip the older log. IO device, a single disk drive, is overloaded by
FS flush when this happens.

Our guess is GC has to acquiesce its threads and if one of the threads
is stuck in the kernel (say in non-interruptible mode). Then GC has to
wait until this thread unblocks. In the mean time, it already stops
the world.

Another test that shows similar problem is doing deferred writes to
append a file. Latency of deferred writes is very fast but once a
while, it can last more than 1 second.

We would really appreciate if you could shed some light on possible
causes? (Threads blocked because of journal check point, delayed
allocation can't proceed?). We could alleviate the problem by
configuring expire_centisecs and writeback_centisecs to flush more
frequently, and thus even-out the workload to the disk drive. But we
would like to know if there  is a methodology to model the rate of
flush vs. rate of changes and IO throughput of the drive (SAS, 15K
RPM).

Many thanks.
