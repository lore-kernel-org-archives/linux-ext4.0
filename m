From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Work on ext4
Date: Fri, 25 Jul 2014 11:41:42 -0400
Message-ID: <20140725154142.GU1865@thunk.org>
References: <CAPDOMVi_qXwY3R2fYiSwu9Bs2fA4kwamt3TKzVEZOZmuaLkbMA@mail.gmail.com>
 <20140725145946.GT1865@thunk.org>
 <CAPDOMVgmkoXQxGODzVaYWYykPWVmpG=jyKNbGv5=3BZ=XQnGrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nick Krause <xerofoify@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56793 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbaGYPlp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 11:41:45 -0400
Content-Disposition: inline
In-Reply-To: <CAPDOMVgmkoXQxGODzVaYWYykPWVmpG=jyKNbGv5=3BZ=XQnGrg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 11:22:02AM -0400, Nick Krause wrote:
> I was being sloppy. I screwed up if you want my help still, please
> let me known.

Well, tell you what.  Why don't you start by downloading the following
git repository:

git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

And then start by trying to use kvm-xfstests.  There are some tests
which are known failures; some are false positives, some are just bugs
that we haven't gotten around to fixing.  (This is especially true for
bigalloc, which has a number of failures that still need to be tracked
down.)

The main rule that we follow is that we don't want to see any
regressions.  So extending kvm-xfstests by writing a script which
analyzes the output of the get-results scripts so that regressions can
be automatically flagged would be a good and useful thing to add.

Another thing that would be useful is a script which automates using
kvm-xfstests to drive "git bisect".  Typically what happens after we
discover a regression is to try to check and see of the failure is
easily replicable using a single xfstests, and then to start bisecting
from the baseline run where the test was successful, to try to find
the guilty bisect.  Automating this would be very useful.

This will hopefully get you started on the testing side of things,
which is also a good way to start learning about how ext4 works.

Cheers,

						- Ted
