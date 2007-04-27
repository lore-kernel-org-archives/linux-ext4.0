From: Mike Galbraith <efault@gmx.de>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 11:23:41 +0200
Message-ID: <1177665821.6462.9.camel@Homer.simpson.net>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54805 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755517AbXD0JXp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 05:23:45 -0400
In-Reply-To: <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-04-27 at 01:33 -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 09:59:27 +0200 Mike Galbraith <efault@gmx.de> wrote:
> 
> > Greetings,
> > 
> > As subject states, my GUI is going away for extended periods of time
> > when my very full and likely highly fragmented (how to find out)
> > filesystem is under heavy write load.  While write is under way, if
> > amarok (mp3 player) is running, no song change will occur until write is
> > finished, and the GUI can go _entirely_ comatose for very long periods.
> > Usually, it will come back to life after write is finished, but
> > occasionally, a complete GUI restart is necessary.
> 
> I'd be suspecting a GUI bug if a restart is necessary.  Perhaps it went to
> lunch for so long in the kernel that some time-based thing went bad.

Yeah, there have been some KDE updates, maybe something went south.  I
know for sure that nothing this horrible used to happen during IO.  But
then when I used to regularly test IO, my disk heads didn't have to
traverse nearly as much either.

> Right.  One possibility here is that bonnie is stuffing new dirty blocks
> onto the committing transaction's ordered-data list and JBD commit is
> livelocking.  Only we're not supposed to be putting those blocks on that
> list.
> 
> Another livelock possibility is that bonnie is redirtying pages faster than
> commit can write them out, so commit got livelocked:
> 
> When I was doing the original port-from-2.2 I found that an application
> which does
> 
> 	for ( ; ; )
> 		pwrite(fd, "", 1, 0);
> 
> would permanently livelock the fs.  I fixed that, but it was six years ago,
> and perhaps we later unfixed it.

I'll try that.

> It would be most interesting to try data=writeback.

Seems somewhat better, but nothing close to tolerable.  I still had to
hot-key to a VT and kill the bonnie.

> hm, fsync.
> 
> Aside: why the heck do applications think that their data is so important
> that they need to fsync it all the time.  I used to run a kernel on my
> laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
> pleasurable.

I thought unkind thoughts when I saw those traces :)

	Thanks,

	-Mike
