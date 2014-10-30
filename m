From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Thu, 30 Oct 2014 19:24:37 -0400
Message-ID: <20141030232437.GF31927@thunk.org>
References: <54415991.1070907@pavlinux.ru>
 <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com>
 <544940EF.7090907@windriver.com>
 <alpine.DEB.2.11.1410261516020.5308@nanos>
 <544E7144.4080809@windriver.com>
 <alpine.DEB.2.11.1410291854090.5308@nanos>
 <54513BDA.1050804@windriver.com>
 <alpine.DEB.2.11.1410292013510.5308@nanos>
 <20141029231916.GD5000@thunk.org>
 <alpine.DEB.2.11.1410302204570.5308@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Friesen <chris.friesen@windriver.com>,
	Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
	rt-users <linux-rt-users@vger.kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410302204570.5308@nanos>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 30, 2014 at 10:11:26PM +0100, Thomas Gleixner wrote:
> 
> That's a way better explanation than what I saw in the commit logs and
> it actually maps to the observed traces and stackdumps.

I can't speak for Jan, but I suspect he didn't realize that there was
a problem.  The commit description in b34090e5e2 makes it clear that
the intent was a performance improvement, and not an attempt to fix a
potential deadlock bug.

Looking at the commit history, the problem was introduced in 2.6.27
(July 2008), in commit c851ed54017373, so this problem wasn't noticed
in the RHEL 6 and RHEL 7 enterprise linux QA runs, and it wasn't
noticed in all of the regression testing that we've been doing.

I've certainly seen this before.  Two years ago we found a bug that
was only noticed when we deployed ext4 in production at Google, and
stress tested it at Google scale with the appropriate monitoring
systems so we could find a bug that had existed since the very
beginning of ext3, and which had never been noticed in all of the
enterprise testing done by Red Hat, SuSE, IBM, HP, etc.  Actually, it
probably was noticed, but never in a reproducible way, and so it was
probably written off as some kind of flaky hardware induced
corruption.

The difference is that in this case, it seems that Chris and Kevin was
able to reproduce the problem reliably.  (It also might be that the RT
patch kits widens the race window and makes it much more likely to
trigger.)  Chris or Kevin, if you have time to try to create a
reliable repro that is small/simple enough that we could propose it as
an new test to add to xfstests, that would be great.  If you can't,
that's completely understable.

In the case I described above, it was an extremely hard to hit race
that only happened under high memory pressure, so we never able to
create a reliable repro.  Instead we had a theory that was consistent
pattern of metadata corruption we were seeing, deployed a kernel with
the fix, and after a few weeks were able to conclude we had finally
fixed the bug.  Welcome to file system debugging.  :-)

> Thanks for the clarification! I'm just getting nervous when 'picked
> some backports' magically 'fixes' an issue without a proper
> explanation.

Well, thanks to Chris for pointing out that b34090e5 seemed to make
the problem go away.  Once I looked at what that patch changed, it was
a lot more obvious what might have been going wrong.  It's always
helpful if you can beek at the answer key, even if it's a only
potential answer key.  :-)

Cheers,

						- Ted
