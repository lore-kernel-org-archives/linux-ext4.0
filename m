From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Fri, 31 Oct 2014 01:16:52 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1410310101540.5308@nanos>
References: <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com> <alpine.DEB.2.11.1410261516020.5308@nanos> <544E7144.4080809@windriver.com> <alpine.DEB.2.11.1410291854090.5308@nanos>
 <54513BDA.1050804@windriver.com> <alpine.DEB.2.11.1410292013510.5308@nanos> <20141029231916.GD5000@thunk.org> <alpine.DEB.2.11.1410302204570.5308@nanos> <20141030232437.GF31927@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Friesen <chris.friesen@windriver.com>,
	Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
	rt-users <linux-rt-users@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20141030232437.GF31927@thunk.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,

On Thu, 30 Oct 2014, Theodore Ts'o wrote:
> On Thu, Oct 30, 2014 at 10:11:26PM +0100, Thomas Gleixner wrote:
> > 
> > That's a way better explanation than what I saw in the commit logs and
> > it actually maps to the observed traces and stackdumps.
> 
> I can't speak for Jan, but I suspect he didn't realize that there was
> a problem.  The commit description in b34090e5e2 makes it clear that
> the intent was a performance improvement, and not an attempt to fix a
> potential deadlock bug.

Indeed. The changelog does not look like a bug fix. That's why I was
worried about Chris 'magic resolution' report.
 
> The difference is that in this case, it seems that Chris and Kevin was
> able to reproduce the problem reliably.  (It also might be that the RT
> patch kits widens the race window and makes it much more likely to
> trigger.)

We've seen that before. RT indeed makes race conditions more prominent
by opening way more race windows than a mainline kernel ever does.

But there is a caveat. With the recent per cpu assumptions RT might
very well run into some completely not mainline relevant RT specific
pitfalls. And that's becoming worse with every day that RT is out of
tree. But that's a totally different story.

Thanks again for your profound analysis of the issue at hand!

	tglx
