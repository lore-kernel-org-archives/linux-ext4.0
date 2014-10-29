From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Wed, 29 Oct 2014 20:26:36 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1410292013510.5308@nanos>
References: <544156FE.7070905@windriver.com> <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com> <alpine.DEB.2.11.1410261516020.5308@nanos> <544E7144.4080809@windriver.com>
 <alpine.DEB.2.11.1410291854090.5308@nanos> <54513BDA.1050804@windriver.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, rt-users <linux-rt-users@vger.kernel.org>
To: Chris Friesen <chris.friesen@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:58414 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaJ2T0q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Oct 2014 15:26:46 -0400
In-Reply-To: <54513BDA.1050804@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 29 Oct 2014, Chris Friesen wrote:
> On 10/29/2014 12:05 PM, Thomas Gleixner wrote:
> It seems plausible that the reason why page writeback never completes is that
> it's blocking trying to take inode->i_data_sem for reading, as seen in the
> following stack trace (from a hung system):
> 
> [<ffffffff8109cd0c>] rt_down_read+0x2c/0x40
> [<ffffffff8120ac91>] ext4_map_blocks+0x41/0x270
> [<ffffffff8120f0dc>] mpage_da_map_and_submit+0xac/0x4c0
> [<ffffffff8120f9c9>] write_cache_pages_da+0x3f9/0x420
> [<ffffffff8120fd30>] ext4_da_writepages+0x340/0x720
> [<ffffffff8111a5f4>] do_writepages+0x24/0x40
> [<ffffffff81191b71>] writeback_single_inode+0x181/0x4b0
> [<ffffffff811922a2>] writeback_sb_inodes+0x1b2/0x290
> [<ffffffff8119241e>] __writeback_inodes_wb+0x9e/0xd0
> [<ffffffff811928e3>] wb_writeback+0x223/0x3f0
> [<ffffffff81192b4f>] wb_check_old_data_flush+0x9f/0xb0
> [<ffffffff8119403f>] wb_do_writeback+0x12f/0x250
> [<ffffffff811941f4>] bdi_writeback_thread+0x94/0x320

Well, the point is that the JBD write out is not completed. The above
is just the consequence. So really looking at ext4 inode write backs
and something stuck on BJ_Shadow or the inode sem is the wrong
place. It's all just caused by the JDB writeout not being completed
for whatever reason.
 
> For what it's worth, I'm currently testing a backport of commit b34090e from
> mainline (which in turn required backporting commits e5a120a and f5113ef).  It
> switches from using the BJ_Shadow list to using the BH_Shadow flag on the
> buffer head.  More interestingly, waiters now get woken up from
> journal_end_buffer_io_sync() instead of from
> jbd2_journal_commit_transaction().
> 
> So far this seems to be helping a lot.  It's lasted about 15x as long under
> stress as without the patches.

I fear that this is just papering over the problem, but you have to
talk to the jbd2 folks about that.

I personally prefer a reasonable explanation for the current behaviour
rather than a magic "solution" to the problem. But that's up to you.

Thanks,

	tglx
