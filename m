From: Chris Friesen <chris.friesen@windriver.com>
Subject: RT/ext4/jbd2 circular dependency (was: Re: Hang writing to nfs-mounted
 filesystem from client)
Date: Thu, 23 Oct 2014 11:54:55 -0600
Message-ID: <544940EF.7090907@windriver.com>
References: <544156FE.7070905@windriver.com> <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
	<linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>,
	rt-users <linux-rt-users@vger.kernel.org>
To: Austin Schuh <austin@peloton-tech.com>, <pavel@pavlinux.ru>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/17/2014 12:55 PM, Austin Schuh wrote:
> Use the 121 patch.  This sounds very similar to the issue that I helped
> debug with XFS.  There ended up being a deadlock due to a bug in the
> kernel work queues.  You can search the RT archives for more info.

I can confirm that the problem still shows up with the rt121 patch. (And
also with Paul Gortmaker's proposed 3.4.103-rt127 patch.)

We added some instrumentation and it looks like we've tracked down the problem.
Figuring out how to fix it is proving to be tricky.

Basically it looks like we have a circular dependency involving the
inode->i_data_sem rt_mutex, the PG_writeback bit, and the BJ_Shadow list.  It
goes something like this:

jbd2_journal_commit_transaction:
1) set page for writeback (set PG_writeback bit)
2) put jbd2 journal head on BJ_Shadow list
3) sleep on PG_writeback bit waiting for page writeback complete

ext4_da_writepages:
1) ext4_map_blocks() acquires inode->i_data_sem for writing
2) do_get_write_access() sleeps waiting for jbd2 journal head to come off
the BJ_Shadow list

At this point the flush code can't run because it can't acquire
inode->i_data_sem for reading, so the page will never get written out.
Deadlock.


The following is a more detailed timeline with information from added trace
events:

 nfsd-2012  [003] ....1..  8612.903541: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903546: ext4_map_blocks_up_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903559: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903565: ext4_map_blocks_up_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903611: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903616: ext4_map_blocks_up_write: dev 147,3 ino 2097161
<...>-5960  [004] ....1..  8612.903628: jbd2_submit_inode_data: dev 147,3 ino 2097160
<...>-5960  [004] ....111  8612.903651: jbd2_list_add_bjshadow: adding jh ffff880415350000 to transaction ffff880415391180 BJ_Shadow list
<...>-5960  [004] ....111  8612.903653: jbd2_list_add_bjshadow: adding jh ffff8803eb08dbd0 to transaction ffff880415391180 BJ_Shadow list
<...>-5960  [004] ....111  8612.903655: jbd2_list_add_bjshadow: adding jh ffff8803eb08d150 to transaction ffff880415391180 BJ_Shadow list
<...>-5960  [004] ....111  8612.903656: jbd2_list_add_bjshadow: adding jh ffff8803eb08d0e0 to transaction ffff880415391180 BJ_Shadow list
<...>-5960  [004] ....111  8612.903657: jbd2_list_add_bjshadow: adding jh ffff88031c9449a0 to transaction ffff880415391180 BJ_Shadow list
 nfsd-2012  [003] ....1..  8612.903658: ext4_map_blocks_down_write: dev 147,3 ino 2097161
<...>-5960  [004] ....111  8612.903658: jbd2_list_add_bjshadow: adding jh ffff88031c944310 to transaction ffff880415391180 BJ_Shadow list
 nfsd-2012  [003] ....1..  8612.903665: ext4_map_blocks_up_write: dev 147,3 ino 2097161
<...>-5960  [004] ....1..  8612.903696: jbd2_finish_inode_data: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903706: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903714: ext4_map_blocks_up_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903802: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903814: ext4_map_blocks_up_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903960: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.903983: ext4_map_blocks_up_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.904311: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.904318: ext4_map_blocks_up_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.904331: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.904337: ext4_map_blocks_up_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.904399: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.904408: ext4_map_blocks_up_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.904678: ext4_map_blocks_down_write: dev 147,3 ino 2097161
 nfsd-2012  [003] ....1..  8612.904772: ext4_map_blocks_up_write: dev 147,3 ino 2097161
<...>-2015  [007] ....1..  8612.934515: ext4_map_blocks_down_write: dev 147,3 ino 2097161
<...>-2015  [007] ....1..  8612.934525: jbd2_list_sleep_bjshadow: waiting for jh ffff8803eb08dbd0 from transaction ffff880415391180 to be removed from BJ_Shadow list



Timeline:

pid 5960 is [jbd2/drbd3-8]
pid 2015 is [nfsd]
pid 2012 is [nfsd]

pid 5960:
8612.903628: jbd2_submit_inode_data for inode 2097160.
	     This is right before calling journal_submit_inode_data_buffers(), which
             ends up calling set_page_writeback().
8612.903653: Add jh ffff8803eb08dbd0 to BJ_Shadow list.
	     This is in bd2_journal_write_metadata_buffer() right before calling
             __jbd2_journal_file_buffer().
8612.903696: This is in journal_finish_inode_data_buffers(), right before calling
             filemap_fdatawait() which ends up calling wait_on_page_bit(page,
             PG_writeback)
<we see no more logs for pid 5960 after this>


pid 2015:
8612.934515: takes write lock on inode->i_data_sem for inode 2097161
8612.934525: goes to sleep waiting for jh ffff8803eb08dbd0 to be removed from
             BJ_Shadow list
<we see no more logs for pid 2015 after this>

pid 2012:
8617.963896: hits 5-sec retry limit and stops the trace.  This means it blocked
             trying to get a read lock on inode->i_data_sem for inode 2097161
             at time 8612.963.


Chris
