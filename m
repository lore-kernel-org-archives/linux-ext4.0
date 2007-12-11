From: Christian Casteyde <casteyde.christian@free.fr>
Subject: Re: [Bug 9546] New: Huge latency in concurrent I/O when using data=ordered
Date: Tue, 11 Dec 2007 23:44:47 +0100
Message-ID: <200712112344.47907.casteyde.christian@free.fr>
References: <bug-9546-27@http.bugzilla.kernel.org/> <20071211133127.432592c1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g19.free.fr ([212.27.42.27]:41380 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073AbXLKWn0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Dec 2007 17:43:26 -0500
In-Reply-To: <20071211133127.432592c1.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK for reply to all. I'm using the first mail received.

> Interesting that data=writeback helped this.  You don't give a lot of
> details, but I assume that data=writeback made a large difference here?

Well, my measures were taken by counting seconds from the desktop clock,
so the precision is roughly 1s. Here are the effective results from the 3 
journaling modes I have done yesterday :

Times in seconds:
ordered mode :	17	5	38	19	33
journal mode :		6	1	5	6	5
writeback mode :	4	1	7	6	8

I do not remember exactly the operation sequence, but the beginning was 
opening Konqueror, opening the bookmarks menu, loading a page, and opening 
another tab.

As you can see anyway, ordered is completely broken, opening the menu is near 
1s in journal and writeback mode, which is perfectly acceptable for a user 
(after all, the computer is loaded, and interactivity is not simply running 
interactive tasks at real time priority, so the the user can understand it 
reacts slower). Launching Konqueror in 4 to 6 seconds is a good time, given 
that the cache is poisoned by the writing process. Opening another tab or a 
web page is tolerable within 5-6s, even if this is still a little too long, 
specially for opening another tab of an already running process (2-3s would 
be a perfect value I think, but this is another story to get this). Certainly 
5-6s of latency is due to the block size used by the writing process, and 
tuning the kernel to get lower results would be dangerous for general 
performances. I could do tests by asking dd to write more but smaller blocks 
to check this idea.

As far as writeback is concerned, the latency reduction was not clear as you 
can see, at least with my mesurement procedure. For performance of the 
**writing process**, it was nearly the same as ordered. I havn't written the 
timings results for the writing process, since I was still investigating at 
that time. But I used :

time dowrite.sh

to time it, and I got real time, as well as dd output (records written, MB/s, 
and journal was half as ordered). So writeback and ordered seemed the same at 
this level, and journal mode was effectively twice slower. It was clear there 
was twice as most write operations, that was the expected behaviour.

I could redo the tests, with a more formal approach (that is: fixing the 
operations order done in Konqueror, and noting the times for the writing 
process), it's easy. In fact, I'm considering doing another script simulating 
Konqueror / user activities and timing them automatically, just to get a 
reproduceable benchmark suite.

Please note that not all programs are affected (for instance kmail was quite 
quick), so the kernel does a good job to run programs that do not many I/Os 
when the fs is stressed by another process. The difference with konqueror is 
it is opening several files (block dump says), so my guess is that processes 
doing small I/O operations are not given "journal access" fairly enough in 
ordered mode.

Indeed, I imagine (without knowing any internals of course) that the data 
writing is indeed scheduled correctly by the disk scheduler, and that the 
writing process is throttled, but the priority informations are lost when 
metadata are written in ordered mode, because all I/Os are mixed for 
metadata. Therefore, the writing process manages to fill the journal quite 
easily. With journal and writeback mode, all data may be written 
sequentially, in the context of the issuing process, so priorities may be 
tracked on the whole writing process. Then the writing process is prempted 
correctly to the benefits of Konqueror. This is of course just "black box" 
hypothesis...

CC
