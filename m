From: John Marconi <jamarconi@sbcglobal.net>
Subject: Re: kjournald hang on ext3 to ext3 copy
Date: Mon, 18 Jun 2007 22:53:02 -0500
Message-ID: <4677531E.1030108@sbcglobal.net>
References: <4673E2F1.2090704@sbcglobal.net>
	<20070618062027.GB5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: John Marconi <jamarconi@sbcglobal.net>, ext3-users@redhat.com,
	linux-ext4@vger.kernel.org
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <20070618062027.GB5181@schatzie.adilger.int>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Jun 16, 2007  08:17 -0500, John Marconi wrote:
>   
>> I am running into a situation in which one of my ext3 filesystems is 
>> getting hung during normal usage.  There are three ext3 filesystems on a 
>> CompactFLASH.  One is mounted as / and one as /tmp.  In my test, I am 
>> copying a 100 MB file from /root to /tmp repeatedly.  While doing this 
>> test, I eventually see the copying stop, and any attempts to access /tmp 
>> fail - if I even do ls /tmp the command will hang.
>>
>> I suspect kjournald because of the following ps output:
>> PID      PPID   WCHAN:20      PCPU  %MEM  PSR  COMM
>> 8847    99 start_this_handle        1.1  0.0  28     pdflush
>> 8853    99 schedule_timeout       0.2  0.0   7     pdflush
>>  188     1 kswapd                       0.0  0.0  19   kswapd0
>> 8051     1 mtd_blktrans_thread   0.0  0.0  22   mtdblockd
>> 8243     1 kjournald                    0.0  0.0   0   kjournald
>> 8305     1 schedule_timeout        0.0  0.0   2   udevd
>> 8378     1 kjournald                    0.0  0.0   0   kjournald
>> 8379     1 journal_commit_trans 16.6  0.0   0   kjournald
>> 8437     1 schedule_timeout       0.0  0.0   0   evlogd
>> 8527     1 syslog                        0.0  0.0   1   klogd
>> 8534     1 schedule_timeout       0.0  0.0   0   portmap
>> 8569     1 schedule_timeout       0.0  0.0   0   rngd
>> 8639     1 schedule_timeout       0.1  0.0  24   sshd
>> 8741  8639 schedule_timeout    0.0  0.0   0     sshd
>> 8743  8741 wait                        0.0  0.0   9       bash
>> 8857  8743 schedule_timeout    4.9  0.0   7         cp
>> 8664     1 schedule_timeout       0.0  0.0   0   xinetd
>> 8679     1 schedule_timeout       0.0  0.0   0   evlnotifyd
>> 8689     1 schedule_timeout       0.0  0.0   0   evlactiond
>> 8704     1 wait                           0.0  0.0   1   bash
>> 8882  8704 -                            0.0  0.0   2     ps
>>
>> If I run ps repeatedly, I always see process 8379 in 
>> journal_commit_transaction, and it is always taking between 12% and 20% 
>> of processor 0 up.  This process never completes.  I also see process 
>> 8847 in start_this_handle forever as well - so I believe they are related. 
>>
>> This system is using a 2.6.14 kernel.
>>     
>
> Please try to reproduce with a newer kernel, as this kind of problem
> might have been fixed already.
>
>
> Two tips for debugging this kind of issue:
> - you need to have detailed stack traces (e.g. sysrq-t) of all the
>   interesting processes
>
> - if a process is stuck inside a large function (e.g. 8379 in example)
>   you need to provide the exact line number.  this can be found by compiling
>   the kernel with CONFIG_DEBUG_INFO (-g flag to gcc) and then doing
>   "gdb vmlinux" and "p *(journal_commit_transaction+{offset})", where the
>   byte offset is printed in the sysrq-t output, and then include the code
>   surrounding that line from the source file
>
> - a process stuck in "start_this_handle()" is often just an innocent
>   bystander.  It is waiting for the currently committing transaction to
>   complete before it can start a new filesystem-modifying operation (handle).
>   That said, the journal handle acts like a lock and has been the cause of
>   many deadlock problems (e.g. process 1 holds lock, waits for handle;
>   process 2 holds transaction open waiting for lock).  pdflush might be one
>   of the "process 1" kind of tasks, and some other process is holding the
>   transaction open preventing it from completing.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
>
>
>   
Andreas,

Thanks for the information.

I am not able to update the entire kernel to a new version for a variety 
of reasons, however I can update certain parts in my system (such as the 
filesystem).  I did a diff of the 2.6.16 kernel against my kernel, and 
the changes to jbd were minimal.  I plan on looking at the latest 
versions of the kernel to determine if anything has changed since 2.6.16.

I took a look at the place that kjournald was stuck - it is in the 
journal_commit_transaction "while (comiit_transaction->t_updates)" loop 
and it is trying to "spin_lock(&journal->j_state_lock).  When I look at 
pdflush, it is also trying to take the journal->j_state_lock.  Do you 
have any tips on finding out which process might own journal->j_state_lock?

Thanks again,
John
