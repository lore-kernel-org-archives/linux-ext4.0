From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests-bld: add exclude file for data_journal_noleak
 tests
Date: Tue, 19 Jan 2016 09:16:44 +1100
Message-ID: <20160118221644.GB16611@dastard>
References: <20160112195248.GA1941@localhost.localdomain>
 <20160112203554.GH6033@dastard>
 <20160113165507.GC30894@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:8233 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180AbcARWRD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jan 2016 17:17:03 -0500
Content-Disposition: inline
In-Reply-To: <20160113165507.GC30894@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 13, 2016 at 11:55:07AM -0500, Theodore Ts'o wrote:
> On Wed, Jan 13, 2016 at 07:35:54AM +1100, Dave Chinner wrote:
> > On Tue, Jan 12, 2016 at 02:52:48PM -0500, Eric Whitney wrote:
> > > Duplicate the contents of the data_journal exclude file for the
> > > data_journal_noleak test case.  This will prevent failure reports from
> > > tests already known to exercise unsupported online defrag functionality.
> > > Add an explanatory comment to both exclude files for future reference.
> > > 
> > > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > 
> > Can you please make these changes directly to xfstests rather than
> > keeping information about what tests run under what circumstances in
> > some external test wrapper?  i.e. this can be implementing by adding
> > a _requires_no_data_journal() check and adding it to each test.
> 
> We've got a number of these exclusions, and some of them require
> making changes that have been rejected by you previously as adding too
> much hair that is ext4 specific.  (For example, ways of restricting
> the tests from using punch hole or collapse range.)
> 
> So I'm carrying a number of these patches out of tree since they've
> been rejected by upstream, and they are all necessary to make it to
> exclude certain tests based on the ext4 configuration.  I had assumed
> you were philosophically against these sorts of exclusions except by
> creating large numbers of extra xfstests groups,

No, like all patches that people propose for inclusion, I look at
them on a case by case basis and either take them or suggest
better/different ways to implement the desired functionality.

I'm always prepared to change my mind given sufficient
justification/evidence of the benefit of a change. For stuff like
test exclusions and config dependent test execution, the behaviour
of xfstests has always been in flux. The general rule of thumb we've
settled on recently is that if support/exclusion can be cleanly
implemented as a _requires rule, then that's the way it should be
done...

> What would actually be cool is some way of expressing in a config file
> tests that should be excluded given a certain file system
> configuration and kernel version ranges, which would also serve as
> documentation for when certain bugs were fixed/backported to the
> stable kernels. 

We already have expunge files for this. xfstests not in the business
of documenting what bug fixes are in what kernel - it's just a test
harness and a bunch of tests.

Fine grained execution environment constraints are the
responsibility of the user, not the test harness. i.e. The xfstests
harness can do coarse-grained "feature present" checks (i.e.
_requires rules), but information about known bugs in certain
envrionments needs to be provided to xfstests by the buggy
environment...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
