From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RT/ext4/jbd2 circular dependency (was: Re: Hang writing to
 nfs-mounted filesystem from client)
Date: Sun, 26 Oct 2014 15:25:38 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1410261516020.5308@nanos>
References: <544156FE.7070905@windriver.com> <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, rt-users <linux-rt-users@vger.kernel.org>
To: Chris Friesen <chris.friesen@windriver.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <544940EF.7090907@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 23 Oct 2014, Chris Friesen wrote:
> On 10/17/2014 12:55 PM, Austin Schuh wrote:
> > Use the 121 patch.  This sounds very similar to the issue that I helped
> > debug with XFS.  There ended up being a deadlock due to a bug in the
> > kernel work queues.  You can search the RT archives for more info.
> 
> I can confirm that the problem still shows up with the rt121 patch. (And
> also with Paul Gortmaker's proposed 3.4.103-rt127 patch.)
 
> We added some instrumentation and it looks like we've tracked down the problem.
> Figuring out how to fix it is proving to be tricky.
> 
> Basically it looks like we have a circular dependency involving the
> inode->i_data_sem rt_mutex, the PG_writeback bit, and the BJ_Shadow list.  It
> goes something like this:
> 
> jbd2_journal_commit_transaction:
> 1) set page for writeback (set PG_writeback bit)
> 2) put jbd2 journal head on BJ_Shadow list
> 3) sleep on PG_writeback bit waiting for page writeback complete
> 
> ext4_da_writepages:
> 1) ext4_map_blocks() acquires inode->i_data_sem for writing
> 2) do_get_write_access() sleeps waiting for jbd2 journal head to come off
> the BJ_Shadow list
> 
> At this point the flush code can't run because it can't acquire
> inode->i_data_sem for reading, so the page will never get written out.
> Deadlock.

Sorry, I really cannot map that sparse description to any code
flow. Proper callchains for the involved parts might help to actually
understand what you are looking for.
 
Thanks,

	tglx
