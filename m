From: tytso@mit.edu
Subject: Re: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Thu, 28 Jan 2010 02:53:28 -0500
Message-ID: <20100128075328.GG28459@thunk.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
 <201001251119.o0PBJDXw012169@demeter.kernel.org>
 <20100127130625.GQ7517@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Godfrey <godfrey@isl.stanford.edu>,
	linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41824 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab0A1IfX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jan 2010 03:35:23 -0500
Content-Disposition: inline
In-Reply-To: <20100127130625.GQ7517@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 27, 2010 at 02:06:25PM +0100, Andre Noll wrote:
> On 11:19, bugzilla-daemon@bugzilla.kernel.org wrote:
> > After kill -9 of the sync run it took about 20 minutes before 
> > it died.
> 
> I was seeing similar behaviour on one of our servers, and changing
> the io scheduler to noop fixed things for me. So it seems to be an
> issue with cfq which is somehow triggered by ext4 but not by ext3.
> 
> To change the IO scheduler, just execute
> 
> 	echo noop > /sys/block/sda/queue/scheduler
> 
> (replace sda if necessary).

Andre or Michael.  If switching away from cfq helps, that's
definitely... interesting.  Given that cfq is the default scheduler, I
definitely want to understand what might be going on here.  Are either
if you able to run blktrace so we can get a sense of what is going on
under the cfq and deadline/noop I/O schedulers?

And in both of your cases, were you using a new file system freshly
created using mke2fs -t ext4, or was this a ext2/ext3 filesystem that
was converted for use under ext4?

Thanks,

					- Ted
