From: Ric Wheeler <ric@emc.com>
Subject: batching support for transactions
Date: Tue, 02 Oct 2007 08:57:53 -0400
Message-ID: <47024051.2030303@emc.com>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Feld, Andy" <Feld_Andy@emc.com>,
	Jens Axboe <jens.axboe@oracle.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


After several years of helping tune file systems for normal (ATA/S-ATA) 
drives, we have been doing some performance work on ext3 & reiserfs on 
disk arrays.

One thing that jumps out is that the way we currently batch synchronous 
work loads into transactions does really horrible things to performance 
for storage devices which have really low latency.

For example, one a mid-range clariion box, we can use a single thread to 
write around 750 (10240 byte) files/sec to a single directory in ext3. 
That gives us an average time around 1.3ms per file.

With 2 threads writing to the same directory, we instantly drop down to 
234 files/sec.

The culprit seems to be the assumptions in journal_stop() which throw in 
a call to schedule_timeout_uninterruptible(1):

         /*
          * Implement synchronous transaction batching.  If the handle
          * was synchronous, don't force a commit immediately.  Let's
          * yield and let another thread piggyback onto this transaction.
          * Keep doing that while new threads continue to arrive.
          * It doesn't cost much - we're about to run a commit and sleep
          * on IO anyway.  Speeds up many-threaded, many-dir operations
          * by 30x or more...
          *
          * But don't do this if this process was the most recent one to
          * perform a synchronous write.  We do this to detect the case 
where a
          * single process is doing a stream of sync writes.  No point 
in waiting
          * for joiners in that case.
          */
         pid = current->pid;
         if (handle->h_sync && journal->j_last_sync_writer != pid) {
                 journal->j_last_sync_writer = pid;
                 do {
                         old_handle_count = transaction->t_handle_count;
                         schedule_timeout_uninterruptible(1);
                 } while (old_handle_count != transaction->t_handle_count);
         }


reiserfs and ext4 have similar if not exactly the same logic.

What seems to be needed here is either a static per file system/storage 
device tunable to allow us to change this timeout (maybe with "0" 
defaulting back to the old reiserfs trick of simply doing a yield()?) or 
a more dynamic, per device way to keep track of the average time it 
takes to commit a transaction to disk. Based on that rate, we could 
dynamically adjust our logic to account for lower latency devices.

A couple of last thoughts. One, if for some reason you don't have a low 
latency storage array handy and want to test this for yourselves, you 
can test the worst case by using a ram disk.

The test we used was fs_mark with 10240 bytes files, writing to one 
shared directory with varying the numbers of threads from 1 up to 40. In 
the ext3 case, it takes 8 concurrent threads to catch up to the single 
thread writing case.

We are continuing to play with the code and try out some ideas, but I 
wanted to bounce this off the broader list to see if this makes sense...

ric


