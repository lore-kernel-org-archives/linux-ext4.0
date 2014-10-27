From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Mon, 27 Oct 2014 10:22:28 -0600
Message-ID: <544E7144.4080809@windriver.com>
References: <544156FE.7070905@windriver.com> <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com> <alpine.DEB.2.11.1410261516020.5308@nanos>
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
In-Reply-To: <alpine.DEB.2.11.1410261516020.5308@nanos>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/26/2014 08:25 AM, Thomas Gleixner wrote:
> On Thu, 23 Oct 2014, Chris Friesen wrote:
>> On 10/17/2014 12:55 PM, Austin Schuh wrote:
>>> Use the 121 patch.  This sounds very similar to the issue that I helped
>>> debug with XFS.  There ended up being a deadlock due to a bug in the
>>> kernel work queues.  You can search the RT archives for more info.
>>
>> I can confirm that the problem still shows up with the rt121 patch. (And
>> also with Paul Gortmaker's proposed 3.4.103-rt127 patch.)
>
>> We added some instrumentation and it looks like we've tracked down the problem.
>> Figuring out how to fix it is proving to be tricky.
>>
>> Basically it looks like we have a circular dependency involving the
>> inode->i_data_sem rt_mutex, the PG_writeback bit, and the BJ_Shadow list.  It
>> goes something like this:
>>
>> jbd2_journal_commit_transaction:
>> 1) set page for writeback (set PG_writeback bit)
>> 2) put jbd2 journal head on BJ_Shadow list
>> 3) sleep on PG_writeback bit waiting for page writeback complete
>>
>> ext4_da_writepages:
>> 1) ext4_map_blocks() acquires inode->i_data_sem for writing
>> 2) do_get_write_access() sleeps waiting for jbd2 journal head to come off
>> the BJ_Shadow list
>>
>> At this point the flush code can't run because it can't acquire
>> inode->i_data_sem for reading, so the page will never get written out.
>> Deadlock.
>
> Sorry, I really cannot map that sparse description to any code
> flow. Proper callchains for the involved parts might help to actually
> understand what you are looking for.

There are details (stack traces, etc.) in the first message in the thread:
http://www.spinics.net/lists/linux-rt-users/msg12261.html


Originally we had thought that nfsd might have been implicated somehow, 
but it seems like it was just a trigger (possibly by increasing the rate 
of sync I/O).

In the interest of full disclosure I should point out that we're using a 
modified kernel so there is a chance that we have introduced the problem 
ourselves.  That said, we have not made significant changes to either 
ext4 or jbd2.  (Just a couple of minor cherry-picked bugfixes.)


The relevant code paths are:

Journal commit.  The important thing here is that we set the 
PG_writeback on a page, put the jbd2 journal head on BJ_Shadow list, 
then sleep waiting for page writeback complete.  If the page writeback 
never completes, then the journal head never comes off the BJ_Shadow list.


jbd2_journal_commit_transaction
     journal_submit_data_buffers
         journal_submit_inode_data_buffers
             generic_writepages
                 set_page_writeback(page) [PG_writeback]
     jbd2_journal_write_metadata_buffer
         __jbd2_journal_file_buffer(jh_in, transaction, BJ_Shadow);

     journal_finish_inode_data_buffers
         filemap_fdatawait
             filemap_fdatawait_range
                 wait_on_page_writeback(page)
                     wait_on_page_bit(page, PG_writeback) <--stuck here
     jbd2_journal_unfile_buffer(journal, jh) [delete from BJ_Shadow list]



We can get to the code path below a couple of different ways (see 
further down).  The important stuff here is:
1) There is a code path that takes i_data_sem and then goes to sleep 
waiting for the jbd2 journal head to be removed from the BJ_Shadow list. 
  If the journal head never comes off the list, the sema will never be 
released.
2) ext4_map_blocks() always takes a read lock on i_data_sem.  If the 
sema is held by someone waiting for the journal head to come off the 
list, it will block.

ext4_da_writepages
     write_cache_pages_da
         mpage_da_map_and_submit
             ext4_map_blocks
                 down_read((&EXT4_I(inode)->i_data_sem))
                 up_read((&EXT4_I(inode)->i_data_sem))
                 down_write((&EXT4_I(inode)->i_data_sem))
                 ext4_ext_map_blocks
                     ext4_mb_new_blocks
                         ext4_mb_mark_diskspace_used
                             __ext4_journal_get_write_access
                                 jbd2_journal_get_write_access
                                     do_get_write_access
                                         wait on BJ_Shadow list



One of the ways we end up at ext4_da_writepages() is via the page 
writeback thread.  If i_data_sem is already held by someone that is 
sleeping, this can result in pages not getting written out.

bdi_writeback_thread
     wb_do_writeback
         wb_check_old_data_flush
             wb_writeback
                 __writeback_inodes_wb
                     writeback_sb_inodes
                         writeback_single_inode
                             do_writepages
                                 ext4_da_writepages


Another way to end up at ext4_da_writepages() is via sync writev() 
calls.  In the traces from my original report this ended up taking the 
sema and then going to sleep waiting for the journal head to get removed 
from the BJ_Shadow list.

sys_writev
     vfs_writev
         do_readv_writev
             do_sync_readv_writev
                 ext4_file_write
                     generic_file_aio_write
                         generic_write_sync
                             ext4_sync_file
                                 filemap_write_and_wait_range
                                      __filemap_fdatawrite_range
                                          do_writepages
                                              ext4_da_writepages


Chris
