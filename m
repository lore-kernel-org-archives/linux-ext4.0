From: Benjamin LaHaise <bcrl@kvack.org>
Subject: high write latency bug in ext3 / jbd in 3.4
Date: Mon, 13 Jan 2014 15:13:20 -0500
Message-ID: <20140113201320.GD1214@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:45904 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaAMUNW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 15:13:22 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,

I've recently encountered a bug in ext3 where the occasional write is 
showing extremely high latency, on the order of 2.2 to 11 seconds compared 
to a more typical 200-300ms.  This is happening on a 3.4.67 kernel.  When 
this occurs, the system is writing to disk somewhere between 290-330MB/s.  
The test takes anywhere from 3 to 12 minutes into a run to trigger the 
high latency write.  During one of these high latency writes, vmstat reports 
0 blocks being written to disk.  The disk array being written to is able to 
write quite a bit faster (about ~770MB/s).

The setup is a bit complicated, but is completely reproducible.  The 
workload consists of about 8 worker threads creating and then writing out 
spool files that are a little under 8MB in size.  After each write, the file 
and the directory it is in are then fsync()d.  The latency measured is from 
the beginning open() of a spool file until the final fsync() completes.

Poking around the system with latencytop shows that sleep_on_buffer() is 
where all the latency is coming from, leading to log_wait_commit() showing 
the very high latency for the fsync()s.  This leads me to believe that jbd 
is somehow not properly flushing a buffer being waited on in a timely 
fashion.  Changing elevator in use has no effect.

Does anyone have any ideas on where to look in ext3 or jbd for something 
that might be causing this behaviour?  If I use ext4 to mount the ext3 
filesystem being tested, the problem goes away.  Testing on newer kernels 
is not very easy to do (the system has other dependencyies on the 3.4 
kernel).  Thoughts?

		-ben
-- 
"Thought is the essence of where you are now."
