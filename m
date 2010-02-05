From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: fix delalloc retry loop logic v2
Date: Thu, 4 Feb 2010 22:55:19 -0500
Message-ID: <20100205035519.GM25885@thunk.org>
References: <87zl3qrwnx.fsf@openvz.org>
 <87sk9irve0.fsf@openvz.org>
 <87y6j9qlwq.fsf@linux.vnet.ibm.com>
 <20100204194559.GL25885@thunk.org>
 <87636cwu08.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34070 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab0BEDzY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Feb 2010 22:55:24 -0500
Content-Disposition: inline
In-Reply-To: <87636cwu08.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 05, 2010 at 12:50:15AM +0300, Dmitry Monakhov wrote:
> BTW. I want to deploy automated testing suite in order to test some devel
> trees on daily basis in order to avoid obvious regressions (f.e. when i
> broke ext3+quota). Do you know a good one?

My general rule is that I won't push a patch set to Linus until I run
it against the XFSQA test suite.  There has been talk about adding
generic quota tests (as opposed to the XFS-specific quota tests, since
XFS has its own quota system different from the one used by other
Linux file systems) to XFSQA, and I think there are a few, but clearly
we need to add more.

So if you want to make the biggest impact in terms of trying to avoid
regressions, helping to contribute more tests to the XFSQA test suite
would be the most useful thing to do.  Right now Eric is the only ext4
developer is really familiar with the test suites, and he's added a
few tests, but he's super busy as of late.  I've dabbled with the test
suites a little, and made a few changes, but I haven't added a new
test before, and I'm also super busy as of late.  :-(

> Currently i'm looking in to autotest.kernel.org

Personally, I don't find frameworks for running automated tests to be
that useful.  They have their place, but the problem isn't really
running the tests; the challenge is getting someone to actually *look*
at the results.  Having a set of tests which is easy to set up, and
easy to run, is far more important.

If someone sets up autotest, but I don't have an occasion to look at
the results, it's not terribly useful.  If it's really easy for me to
run the XFSQA test suite, then I'll run it every couple of patches
that I add to the ext4 patch queue, and run the complete set before I
push a set of patches to Linus.  That's **far** more useful.

Automated tests are good, but they tend to be too noisy, and so no one
ever bothers to look at the output.  A useful automated system would
only run tests that had clear and unambiguous failures; be able to
tolerate it if some test starts to fail and still be useful, and then
be able to do git-style bisection searches so it can say, "test NNN
started failing at commit XXX", "test MMM started failing at commit
YYY", etc.  If it then mailed the results the relevant maintainer and
to the people who were the patch authors and the people who signed off
on the patch, then it would have a *chance* of being something that
people actually would pay attention to.  Unfortunately, I don't know
of any automated test framework which fits this bill.  :-(

So instead, I use the discpline of "make check" between almost every
single commit for e2fsprogs, and running "xfsqa -g quick" between most
patches (because the tests take a lot longer to run, I can't afford to
do it between every single patch), and "xfsqa -g auto" before I submit
a patchset to Linus (the most comprehensive set of tests, but it takes
hours so I have to run them overnight).

						- Ted
