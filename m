From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Wed, 29 Oct 2014 19:05:27 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1410291854090.5308@nanos>
References: <544156FE.7070905@windriver.com> <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com> <alpine.DEB.2.11.1410261516020.5308@nanos> <544E7144.4080809@windriver.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, rt-users <linux-rt-users@vger.kernel.org>
To: Chris Friesen <chris.friesen@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:58041 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaJ2SFl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Oct 2014 14:05:41 -0400
In-Reply-To: <544E7144.4080809@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 Oct 2014, Chris Friesen wrote:
> There are details (stack traces, etc.) in the first message in the thread:
> http://www.spinics.net/lists/linux-rt-users/msg12261.html
> 
> 
> Originally we had thought that nfsd might have been implicated somehow, but it
> seems like it was just a trigger (possibly by increasing the rate of sync
> I/O).
> 
> In the interest of full disclosure I should point out that we're using a
> modified kernel so there is a chance that we have introduced the problem
> ourselves.  That said, we have not made significant changes to either ext4 or
> jbd2.  (Just a couple of minor cherry-picked bugfixes.)

I don't think it's an ext4/jdb2 problem.
 
> The relevant code paths are:
> 
> Journal commit.  The important thing here is that we set the PG_writeback on a
> page, put the jbd2 journal head on BJ_Shadow list, then sleep waiting for page
> writeback complete.  If the page writeback never completes, then the journal
> head never comes off the BJ_Shadow list.

And that's what you need to investigate.

The rest of the threads being stuck waiting for the journal writeback
or inode->sem are just the consequence of it and have nothing to do
with the root cause of the problem.

ftrace with the block/writeback/jdb/ext4/sched tracepoints enabled
should provide a first insight into the issue.

Thanks,

	tglx
