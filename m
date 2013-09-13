From: Cuong Tran <cuonghuutran@gmail.com>
Subject: Re: Java Stop-the-World GC stall induced by FS flush or many large
 file deletions
Date: Fri, 13 Sep 2013 08:25:30 -0700
Message-ID: <CALQm4jiEiKqKRwB8FEp2ojrVcw=-H8zh_+_guh_xmwiLx12syg@mail.gmail.com>
References: <CALQm4jhE8aRjOsK2HpSuqNCzNqZm5RU9QOJi0q0SwgR=1JKZsQ@mail.gmail.com>
 <20130912190251.GB28067@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130912190251.GB28067@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks Ted. That's great info.
I did strace and some stalls can be correlated to GC thread writing to
the log but others are not.

I turned on the  jbd2_run_stats trace point, and this is sample trace
of creating and deleting 300 100MB files in  a loop. (My desktop is
running low on disk space!). No Java test is running. I also turned on
jbd2_checkpoint_stats. Not sure if the count "running" in 5000s or
frequency of jbd2_checkpoint_stats has any relevance.

           <...>-534   [003] 64044.506552: jbd2_checkpoint_stats: dev
sda1 tid 5433920 chp_time 0 forced_to_close 0 written 0 dropped 6
           <...>-534   [003] 64044.506555: jbd2_run_stats: dev sda1
tid 5433921 wait 0 running 5003 locked 0 flushing 0 logging 13
handle_count 1587 blocks 6 blocks_logged 7
           <...>-534   [003] 64049.505782: jbd2_checkpoint_stats: dev
sda1 tid 5433921 chp_time 0 forced_to_close 0 written 0 dropped 6
           <...>-534   [003] 64049.505784: jbd2_run_stats: dev sda1
tid 5433922 wait 0 running 5003 locked 0 flushing 0 logging 15
handle_count 1585 blocks 6 blocks_logged 7
           <...>-534   [003] 64149.417563: jbd2_checkpoint_stats: dev
sda1 tid 5433941 chp_time 0 forced_to_close 0 written 0 dropped 6
           <...>-534   [003] 64149.417565: jbd2_run_stats: dev sda1
tid 5433942 wait 0 running 5003 locked 0 flushing 0 logging 14
handle_count 1600 blocks 6 blocks_logged 7
           <...>-534   [003] 64234.335940: jbd2_checkpoint_stats: dev
sda1 tid 5433958 chp_time 0 forced_to_close 0 written 0 dropped 6
           <...>-534   [003] 64234.335942: jbd2_run_stats: dev sda1
tid 5433959 wait 0 running 5000 locked 0 flushing 0 logging 13
handle_count 1574 blocks 6 blocks_logged 7
           <...>-534   [004] 64658.799432: jbd2_run_stats: dev sda1
tid 5434029 wait 0 running 5004 locked 0 flushing 0 logging 66
handle_count 442 blocks 1139 blocks_logged 1143
           <...>-534   [000] 64707.948801: jbd2_run_stats: dev sda1
tid 5434034 wait 0 running 5002 locked 0 flushing 0 logging 73
handle_count 8416 blocks 1475 blocks_logged 1480
           <...>-534   [000] 64722.940015: jbd2_run_stats: dev sda1
tid 5434037 wait 0 running 5008 locked 0 flushing 0 logging 72
handle_count 8442 blocks 1479 blocks_logged 1484
           <...>-534   [001] 64727.933030: jbd2_run_stats: dev sda1
tid 5434038 wait 0 running 5001 locked 0 flushing 0 logging 73
handle_count 19208 blocks 1389 blocks_logged 1394
           <...>-534   [001] 64737.922818: jbd2_run_stats: dev sda1
tid 5434040 wait 0 running 5002 locked 0 flushing 0 logging 77
handle_count 10147 blocks 1405 blocks_logged 1410
           <...>-534   [001] 64742.908500: jbd2_run_stats: dev sda1
tid 5434041 wait 0 running 5003 locked 0 flushing 0 logging 69
handle_count 8474 blocks 1219 blocks_logged 1223
           <...>-534   [001] 64747.901419: jbd2_run_stats: dev sda1
tid 5434042 wait 0 running 5003 locked 0 flushing 0 logging 66
handle_count 8452 blocks 1206 blocks_logged 1210
           <...>-534   [001] 64752.898315: jbd2_checkpoint_stats: dev
sda1 tid 5434041 chp_time 0 forced_to_close 0 written 0 dropped 1219

And this is sample of traces for creating and deleting one 20 GB file in a loop:

           <...>-534   [001] 64511.057009: jbd2_run_stats: dev sda1
tid 5434012 wait 0 running 5460 locked 0 flushing 0 logging 47
handle_count 2569 blocks 299 blocks_logged 300
           <...>-534   [001] 64517.051769: jbd2_run_stats: dev sda1
tid 5434013 wait 0 running 5592 locked 0 flushing 0 logging 52
handle_count 3847 blocks 583 blocks_logged 585
           <...>-534   [000] 64522.958310: jbd2_run_stats: dev sda1
tid 5434014 wait 0 running 5905 locked 0 flushing 0 logging 54
handle_count 2570 blocks 572 blocks_logged 574
           <...>-534   [001] 64528.027403: jbd2_run_stats: dev sda1
tid 5434015 wait 0 running 5085 locked 0 flushing 0 logging 47
handle_count 3845 blocks 281 blocks_logged 282
           <...>-534   [000] 64534.019586: jbd2_checkpoint_stats: dev
sda1 tid 5434012 chp_time 0 forced_to_close 0 written 0 dropped 299
           <...>-534   [000] 64534.019610: jbd2_run_stats: dev sda1
tid 5434016 wait 0 running 5490 locked 0 flushing 0 logging 48
handle_count 2568 blocks 298 blocks_logged 299
           <...>-534   [001] 64540.255202: jbd2_checkpoint_stats: dev
sda1 tid 5434013 chp_time 0 forced_to_close 0 written 0 dropped 583
           <...>-534   [001] 64540.255206: jbd2_run_stats: dev sda1
tid 5434017 wait 0 running 5581 locked 283 flushing 0 logging 54
handle_count 3849 blocks 692 blocks_logged 695
           <...>-534   [001] 64547.069532: jbd2_checkpoint_stats: dev
sda1 tid 5434016 chp_time 0 forced_to_close 0 written 0 dropped 8
           <...>-534   [001] 64547.114704: jbd2_checkpoint_stats: dev
sda1 tid 5434015 chp_time 0 forced_to_close 0 written 0 dropped 260
           <...>-534   [001] 64547.114724: jbd2_checkpoint_stats: dev
sda1 tid 5434014 chp_time 0 forced_to_close 0 written 0 dropped 571
           <...>-534   [001] 64547.114729: jbd2_checkpoint_stats: dev
sda1 tid 5434017 chp_time 0 forced_to_close 0 written 0 dropped 8
           <...>-534   [001] 64547.114731: jbd2_run_stats: dev sda1
tid 5434018 wait 0 running 5603 locked 276 flushing 0 logging 45
handle_count 3851 blocks 281 blocks_logged 282
           <...>-534   [001] 64553.974915: jbd2_run_stats: dev sda1
tid 5434019 wait 0 running 5593 locked 274 flushing 0 logging 48
handle_count 3849 blocks 302 blocks_logged 303
           <...>-534   [001] 64559.979010: jbd2_run_stats: dev sda1
tid 5434020 wait 0 running 5005 locked 0 flushing 0 logging 56
handle_count 3847 blocks 669 blocks_logged 671
           <...>-534   [001] 64565.952850: jbd2_run_stats: dev sda1
tid 5434021 wait 0 running 5400 locked 0 flushing 0 logging 52
handle_count 12933 blocks 559 blocks_logged 561

It would be awesome if you could shed some light on the counters and
the interactions.

Thanks again.

--Cuong

On Thu, Sep 12, 2013 at 12:02 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Are you absolutely certain your JVM attempting to write to any files
> in its GC thread?  Say, to do some kind of logging?  It might be worth
> stracing the JVM and correlating the GC stall with any syscalls that
> might have been issued from the JVM GC thread.
>
> Especially in the case of the FS Flush, the writeback thread isn't CPU
> bound.  It will wait for the writeback to complete, but while it's
> waiting, other processes or threads will be allowed to run on the CPU.
>
> Now, if the GC thread tries to do some kind of fs operation which
> requires writing to the file system, and the file sytstem is trying to
> start a jbd transaction commit, file system operations can block until
> all of the jbd handles associated with the previous commit can
> complete.  If you are storage devices are slow, or you are using a
> block cgroup to control how much I/O bandwidth a particular cgroup
> could use, this can end up causing a priority inversion where a low
> priority cgroup takes a while to complete, this can stall the jbd
> commit completion, and this can cause new ext4 operations can stall
> waiting to start a new jbd handle.
>
> So you could have a stall happening, if it's taking a long time for
> commits to complete, but it might be completely unrelated to a GC
> stall.
>
> If you enable the jbd2_run_stats tracepoint, you can get some
> interesting numbers about how long the various phases of the jbd2
> commit are taking.
>
>                                         - Ted
