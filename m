From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Wed, 29 Oct 2014 21:31:33 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1410292125530.5308@nanos>
References: <544156FE.7070905@windriver.com> <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com> <alpine.DEB.2.11.1410261516020.5308@nanos> <544E7144.4080809@windriver.com>
 <alpine.DEB.2.11.1410291854090.5308@nanos> <54513BDA.1050804@windriver.com> <alpine.DEB.2.11.1410292013510.5308@nanos> <54514B71.7000809@windriver.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, rt-users <linux-rt-users@vger.kernel.org>
To: Chris Friesen <chris.friesen@windriver.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <54514B71.7000809@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 29 Oct 2014, Chris Friesen wrote:
> On 10/29/2014 01:26 PM, Thomas Gleixner wrote:
> > On Wed, 29 Oct 2014, Chris Friesen wrote:
> > > On 10/29/2014 12:05 PM, Thomas Gleixner wrote:
> > > It seems plausible that the reason why page writeback never completes is
> > > that
> > > it's blocking trying to take inode->i_data_sem for reading, as seen in the
> > > following stack trace (from a hung system):
> > > 
> > > [<ffffffff8109cd0c>] rt_down_read+0x2c/0x40
> > > [<ffffffff8120ac91>] ext4_map_blocks+0x41/0x270
> > > [<ffffffff8120f0dc>] mpage_da_map_and_submit+0xac/0x4c0
> > > [<ffffffff8120f9c9>] write_cache_pages_da+0x3f9/0x420
> > > [<ffffffff8120fd30>] ext4_da_writepages+0x340/0x720
> > > [<ffffffff8111a5f4>] do_writepages+0x24/0x40
> > > [<ffffffff81191b71>] writeback_single_inode+0x181/0x4b0
> > > [<ffffffff811922a2>] writeback_sb_inodes+0x1b2/0x290
> > > [<ffffffff8119241e>] __writeback_inodes_wb+0x9e/0xd0
> > > [<ffffffff811928e3>] wb_writeback+0x223/0x3f0
> > > [<ffffffff81192b4f>] wb_check_old_data_flush+0x9f/0xb0
> > > [<ffffffff8119403f>] wb_do_writeback+0x12f/0x250
> > > [<ffffffff811941f4>] bdi_writeback_thread+0x94/0x320
> > 
> > Well, the point is that the JBD write out is not completed. The above
> > is just the consequence. So really looking at ext4 inode write backs
> > and something stuck on BJ_Shadow or the inode sem is the wrong
> > place. It's all just caused by the JDB writeout not being completed
> > for whatever reason.
> 
> I'll willingly confess my ignorance of filesystem code before I started
> looking at this issue.  I was under the impression that the above stack trace
> (for the "flush-147:3" task, in this case) was performing the write out of the
> page that had been flagged for writeback by JBD...is that not the case?  If
> not, then could you point me in the right direction?

jbd2_journal_commit_transaction
    journal_submit_data_buffers
        journal_submit_inode_data_buffers
            generic_writepages
                set_page_writeback(page) [PG_writeback]

generic_writepages() is issuing the writeout to the block layer and
the underlying physical device.

    journal_finish_inode_data_buffers
        filemap_fdatawait
            filemap_fdatawait_range
                wait_on_page_writeback(page)
                    wait_on_page_bit(page, PG_writeback) <--stuck here

That parts waits for the IO completion. And because that thing is
stuck everything else gets stuck as well.

Thanks,

	tglx
