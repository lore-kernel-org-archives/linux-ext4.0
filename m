From: Jan Kara <jack@suse.cz>
Subject: Re: high write latency bug in ext3 / jbd in 3.4
Date: Tue, 28 Jan 2014 00:55:18 +0100
Message-ID: <20140127235518.GB7020@quack.suse.cz>
References: <20140113201320.GD1214@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbaA0XzU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jan 2014 18:55:20 -0500
Content-Disposition: inline
In-Reply-To: <20140113201320.GD1214@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Mon 13-01-14 15:13:20, Benjamin LaHaise wrote:
> I've recently encountered a bug in ext3 where the occasional write is 
> showing extremely high latency, on the order of 2.2 to 11 seconds compared 
> to a more typical 200-300ms.  This is happening on a 3.4.67 kernel.  When 
> this occurs, the system is writing to disk somewhere between 290-330MB/s.  
> The test takes anywhere from 3 to 12 minutes into a run to trigger the 
> high latency write.  During one of these high latency writes, vmstat reports 
> 0 blocks being written to disk.  The disk array being written to is able to 
> write quite a bit faster (about ~770MB/s).
> 
> The setup is a bit complicated, but is completely reproducible.  The 
> workload consists of about 8 worker threads creating and then writing out 
> spool files that are a little under 8MB in size.  After each write, the file 
> and the directory it is in are then fsync()d.  The latency measured is from 
> the beginning open() of a spool file until the final fsync() completes.
> 
> Poking around the system with latencytop shows that sleep_on_buffer() is 
> where all the latency is coming from, leading to log_wait_commit() showing 
> the very high latency for the fsync()s.  This leads me to believe that jbd 
> is somehow not properly flushing a buffer being waited on in a timely 
> fashion.  Changing elevator in use has no effect.
  I'm not sure if you haven't switched to ext4 as others have suggested in
this thread. If not:
  1) Since the stall is so long, can you run
     'echo w >/proc/sysrq-trigger'
     when the stall happens and send the stack traces from kernel log?
  2) Are you running with 'barrier' option?

> Does anyone have any ideas on where to look in ext3 or jbd for something 
> that might be causing this behaviour?  If I use ext4 to mount the ext3 
> filesystem being tested, the problem goes away.  Testing on newer kernels 
> is not very easy to do (the system has other dependencyies on the 3.4 
> kernel).  Thoughts?
  My suspicion is we are hanging on writing the 'commit' block of a
transaction. That issues a cache flush to the storage and that can take
quite a bit of time if we are unlucky.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
