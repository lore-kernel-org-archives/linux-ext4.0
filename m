From: tytso@mit.edu
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Sun, 30 May 2010 17:25:02 -0400
Message-ID: <20100530212502.GQ26177@thunk.org>
References: <4C001888.8020006@jaysonking.com>
 <4C0018E1.5060007@jaysonking.com>
 <20100529004913.GL26177@thunk.org>
 <4C0070D8.8060500@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
To: "Jayson R. King" <dev@jaysonking.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C0070D8.8060500@jaysonking.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 28, 2010 at 08:41:44PM -0500, Jayson R. King wrote:
> 
> The difference is that, 2.6.27's write_cache_pages() in
> page-writeback.c still updates wbc->nr_to_write, since the patch
> which changed that behavior was dropped from .27-rc2 due to the XFS
> regression it causes on mainline. ext4 appears to want the behavior
> of write_cache_pages which does not update wbc->nr_to_write. This
> write_cache_pages_da() does what ext4 wants, without introducing the
> XFS regression. So I believe it is needed.

Ah, OK.  So I understand the motivation now, and that's a valid
concern.  The question is now: how much the goal of the 2.6.27 stable
branch to fix bugs, and how much is it to get the best possible
performance, at least with respect to ext4?  It's going to be harder
and harder to backport fixes to 2.6.27, and I can speak from
experience that it's very easy to introduce regressions while trying
to do backports, since sometimes an individual upstream commit can end
up introducing a regression, and while we do try to document
regression fixes in later commits, sometimes the documentation isn't
complete.

I just spent the better part of a day trying to fix up a backport
series for 2.6.32.  When I was engaged in this particular exercise, it
turns out a particular commit to fix a quota deadlock introduced a
regression, and the fix to that introduced yet another, and there were
three or four patches that all needed to be pulled in at once.  Except
initially I missed one, and that caused an i_blocks corruption issue
when using fallocate() that took me several hours and a reverse
git-bisection to find.  (And this is one set of fixes that will
probably never be able to go into 2.6.27.y, since these changes also
interlock with probably a dozen or so quota changes that have also
gone in over the last couple of kernel releases.)

I'll also add that simply testing using dbench, as you said you used
in another e-mail message, really isn't good enough to find all
possible regressions (it wouldn't have found the i_blocks corruption
problem in my initial set of 2.6.32 ext4 backports patches, for
example, since dbench only tests a very limited set of fs operations,
which doesn't include fallocate, or quotas, or mmap for that matter.)

What I would recommend is using the XFSQA (also sometimes known
xfstests) test suite to make sure that your changes are sound.  Dbench
will sometimes find issues, yes, but in my experience it's not the
best tool.  The fsstress program, which is called in a number of
different configurations by xfstests, has found all sorts of problems
that other thing shaven't been able to find.  Run it on at least a
2-core system, or preferably a 4-core or 8-core system if you have it.
I generally run tests using both 4k and 1k blocksize file systems to
make sure there aren't problems where the fs blocksize is less than
the pagesize.

If you are willing to take on the support burden of ext4 for 2.6.27,
and do a lot of testing, I at least wouldn't have any objection to
these patches.  It's really a question of risk vs. reward for the
users of the 2.6.27 stable tree, plus a question of someone willing to
take on the support/debugging burden, and how much testing is done to
appropriate tilt the risk/reward balance.

Regards,

						- Ted
