From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: dump ext4 performance degrades linearly as disk fills
Date: Fri, 20 Jun 2014 20:38:49 -0400
Message-ID: <20140621003849.GA15531@thunk.org>
References: <d5c373beb24a9da86986ea43afe13594@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Joseph D. Wagner" <joe@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50677 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbaFUAix (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jun 2014 20:38:53 -0400
Content-Disposition: inline
In-Reply-To: <d5c373beb24a9da86986ea43afe13594@josephdwagner.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 19, 2014 at 11:42:38AM -0700, Joseph D. Wagner wrote:
> Hello Theo.
> 
> I know you're working-for-free and have other things to do besides
> work on my low priority problem.  However, I haven't heard from you.
> I just wanted to follow-up and make sure you got my attachment,
> not that anything fell through the cracks so-to-speak.

Sorry, I did get your attachment.  I've just been crazy busy as of
late.  Between work and several other projects, I just haven't had
time to get back to this.

Nothing really obvious is jumping out at me.  There are some
tracepoints we could set to try to analyze what might be happening,
but it's going to take a bit of time to describe how to do it, and
more time to analyze the results afterwards, which is why I haven't
gotten back to you.

The short version is we'd want to enable the tracepoints
"ext4_mballoc_alloc" and "ext4_read_block_bitmap_load" and grab some
trace output at the beginning of the backup, and at the end, and see
if anything obvious shows up.

Another experiment that might be worth trying to run the backup to 30%
or so, and then stop the backup, and rename the backup file so it's
not overwritten, and then start a fresh full backup.  What we would be
trying to determine is whether the decreased performance is due to the
disk space fillin gup, or due the size of the backup file that is
being written which is causing the slow down.

Cheers,

						- Ted
