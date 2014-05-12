From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] check: add support for an external file containing
 tests to exclude
Date: Mon, 12 May 2014 08:42:32 -0400
Message-ID: <20140512124232.GB31376@thunk.org>
References: <20140416001530.GU15995@dastard>
 <1397624302-9577-1-git-send-email-tytso@mit.edu>
 <20140416064018.GJ15995@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34506 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbaELMmj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 08:42:39 -0400
Content-Disposition: inline
In-Reply-To: <20140416064018.GJ15995@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 16, 2014 at 04:40:18PM +1000, Dave Chinner wrote:
> On Wed, Apr 16, 2014 at 12:58:22AM -0400, Theodore Ts'o wrote:
> > Currently the -X option is intended to specify a set of expunging
> > files which are stored in each test/* subdirectory.  As described in
> > the commit description for 0b1e8abd4, in order to exclude the test
> > generic/280, the -X option is used as follows:
> > 
> >     $ cat tests/generic/3.0-stable-avoid
> >     280
> >     $ sudo ./check -X 3.0-stable-avoid generic/280
> > 
> > However, it is sometimes useful to store the set of expunged tests in
> > a single file, outside of tests/* subdirectories.  This commit enables
> > the following:
> > 
> >     $ cat /root/conf/data_journal.exclude
> >     generic/068
> >     ext4/301
> >     $ sudo ./check -E /root/conf/data_journal.exclude -g auto
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

This patch has apparently not hit the xfstests repository.  Would you
like me to resend it?

Thanks,

						- Ted
