From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Wed, 29 Oct 2014 13:11:22 -0600
Message-ID: <54513BDA.1050804@windriver.com>
References: <544156FE.7070905@windriver.com> <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com> <alpine.DEB.2.11.1410261516020.5308@nanos> <544E7144.4080809@windriver.com> <alpine.DEB.2.11.1410291854090.5308@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Austin Schuh <austin@peloton-tech.com>, <pavel@pavlinux.ru>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	<linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>,
	rt-users <linux-rt-users@vger.kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1410291854090.5308@nanos>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/29/2014 12:05 PM, Thomas Gleixner wrote:
> On Mon, 27 Oct 2014, Chris Friesen wrote:
>> There are details (stack traces, etc.) in the first message in the thread:
>> http://www.spinics.net/lists/linux-rt-users/msg12261.html
>>
>>
>> Originally we had thought that nfsd might have been implicated somehow, but it
>> seems like it was just a trigger (possibly by increasing the rate of sync
>> I/O).
>>
>> In the interest of full disclosure I should point out that we're using a
>> modified kernel so there is a chance that we have introduced the problem
>> ourselves.  That said, we have not made significant changes to either ext4 or
>> jbd2.  (Just a couple of minor cherry-picked bugfixes.)
>
> I don't think it's an ext4/jdb2 problem.

If we turn off journalling in ext4 we can't reproduce the problem.  Not 
conclusive, I'll admit...but interesting.

>> The relevant code paths are:
>>
>> Journal commit.  The important thing here is that we set the PG_writeback on a
>> page, put the jbd2 journal head on BJ_Shadow list, then sleep waiting for page
>> writeback complete.  If the page writeback never completes, then the journal
>> head never comes off the BJ_Shadow list.
>
> And that's what you need to investigate.
>
> The rest of the threads being stuck waiting for the journal writeback
> or inode->sem are just the consequence of it and have nothing to do
> with the root cause of the problem.
>
> ftrace with the block/writeback/jdb/ext4/sched tracepoints enabled
> should provide a first insight into the issue.

It seems plausible that the reason why page writeback never completes is 
that it's blocking trying to take inode->i_data_sem for reading, as seen 
in the following stack trace (from a hung system):

[<ffffffff8109cd0c>] rt_down_read+0x2c/0x40
[<ffffffff8120ac91>] ext4_map_blocks+0x41/0x270
[<ffffffff8120f0dc>] mpage_da_map_and_submit+0xac/0x4c0
[<ffffffff8120f9c9>] write_cache_pages_da+0x3f9/0x420
[<ffffffff8120fd30>] ext4_da_writepages+0x340/0x720
[<ffffffff8111a5f4>] do_writepages+0x24/0x40
[<ffffffff81191b71>] writeback_single_inode+0x181/0x4b0
[<ffffffff811922a2>] writeback_sb_inodes+0x1b2/0x290
[<ffffffff8119241e>] __writeback_inodes_wb+0x9e/0xd0
[<ffffffff811928e3>] wb_writeback+0x223/0x3f0
[<ffffffff81192b4f>] wb_check_old_data_flush+0x9f/0xb0
[<ffffffff8119403f>] wb_do_writeback+0x12f/0x250
[<ffffffff811941f4>] bdi_writeback_thread+0x94/0x320

I have ftrace logs for two of the three components that we think are 
involved.  I don't have ftrace logs for the above writeback case.  My 
instrumentation was set up to end tracing when someone blocked for 5 
seconds trying to get inode->i_data_sem, and it happened to be an nfsd 
task instead of the page writeback code.  I could conceivably modify the 
instrumentation to only get triggered by page writeback blocking.


For what it's worth, I'm currently testing a backport of commit b34090e 
from mainline (which in turn required backporting commits e5a120a and 
f5113ef).  It switches from using the BJ_Shadow list to using the 
BH_Shadow flag on the buffer head.  More interestingly, waiters now get 
woken up from journal_end_buffer_io_sync() instead of from 
jbd2_journal_commit_transaction().

So far this seems to be helping a lot.  It's lasted about 15x as long 
under stress as without the patches.

Chris
