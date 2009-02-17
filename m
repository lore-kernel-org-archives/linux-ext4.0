From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: sync-Regression in 2.6.28.2?
Date: Tue, 17 Feb 2009 15:17:23 +1100
Message-ID: <200902171517.23980.nickpiggin@yahoo.com.au>
References: <20090127093533.GB7037@charite.de> <20090209134958.GP27548@charite.de> <20090215134235.GB15398@charite.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Federico Cuello <fedux@lugmen.org.ar>,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>, stable@kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752516AbZBQESJ@vger.kernel.org>
In-Reply-To: <20090215134235.GB15398@charite.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 16 February 2009 00:42:35 Ralf Hildebrandt wrote:
> * Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>:
> > > This patch seems good to me. If you would care to add a changelog and
> > > Signed-off-by: line, then we could get it merged?
> > >
> > > I am not too sure about this bug. I have reproduced a strange hang with
> > > ext4 (which does include sys_sync and write_cache_pages traces), and
> > > also turned up a lockdep report. Also, we haven't seen any reports of
> > > this problem on other filesystems. So it could be an ext4 bug.
> > >
> > > Your traces also have lots of tasks hung waiting for page lock. It is
> > > possible that wakeups get lost, which is fixed by this commit in
> > > mainline
> > > 777c6c5f1f6e757ae49ecca2ed72d6b1f523c007
> > >
> > > Which might also be your bug.
> > >
> > >
> > > Any chance you can test this patch (as well as the existing patches
> > > you are using to fix write_cache_pages?).
> >
> > I could test 2.6.28.4
>
> Still there in 2.6.28.5 :(

I believe it is basically a deadlock in ext4 due to the cyclic writeback
change.

http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=2acf2c261b823d9d9ed954f348b97620297a36b5

ext4 guys, is this correct? Is there a minimal fix that can be made for
.stable kernels?
