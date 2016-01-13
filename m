From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld: add exclude file for data_journal_noleak
 tests
Date: Wed, 13 Jan 2016 11:55:07 -0500
Message-ID: <20160113165507.GC30894@thunk.org>
References: <20160112195248.GA1941@localhost.localdomain>
 <20160112203554.GH6033@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35312 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbcAMQzK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jan 2016 11:55:10 -0500
Content-Disposition: inline
In-Reply-To: <20160112203554.GH6033@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 13, 2016 at 07:35:54AM +1100, Dave Chinner wrote:
> On Tue, Jan 12, 2016 at 02:52:48PM -0500, Eric Whitney wrote:
> > Duplicate the contents of the data_journal exclude file for the
> > data_journal_noleak test case.  This will prevent failure reports from
> > tests already known to exercise unsupported online defrag functionality.
> > Add an explanatory comment to both exclude files for future reference.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> 
> Can you please make these changes directly to xfstests rather than
> keeping information about what tests run under what circumstances in
> some external test wrapper?  i.e. this can be implementing by adding
> a _requires_no_data_journal() check and adding it to each test.

We've got a number of these exclusions, and some of them require
making changes that have been rejected by you previously as adding too
much hair that is ext4 specific.  (For example, ways of restricting
the tests from using punch hole or collapse range.)

So I'm carrying a number of these patches out of tree since they've
been rejected by upstream, and they are all necessary to make it to
exclude certain tests based on the ext4 configuration.  I had assumed
you were philosophically against these sorts of exclusions except by
creating large numbers of extra xfstests groups, which is something
that I don't believe is maintainable from my perspective --- or at
least, it's easier for me to carry these patches out of tree than to
be constantly updating a groups file and then having to modulate which
groups to include or exclude on a fs config file.

The _require_data_journal_noleak annotation is certainly more
acceptable from my perspective, but I had assumed you were
philosophically against such changes, so I had stopped trying to get
these sorts of changes upstream.

Also, in this specific case, we may end up dropping this change
anyway, since if the bug fix has perculated all the way back to all of
the stable kernel trees, the need for the data_journal_noleak
configuration will go away, since at the moment I'm only interested in
supporting the kvm-xfstests for mainline plus the long term stable
kernel trees.

What would actually be cool is some way of expressing in a config file
tests that should be excluded given a certain file system
configuration and kernel version ranges, which would also serve as
documentation for when certain bugs were fixed/backported to the
stable kernels.  The question though is whether such a thing belongs
in core xfstests, or in the test runners.  I had assumed that
philosophically you were against pushing this sort of thing into
xfstests, but if this is something you would be interested in, perhaps
we can work on this and try to get something upstream to xfstests
which is a superset of the current exclusion rules we have in
kvm-xfstests.

Cheers,

						- Ted
