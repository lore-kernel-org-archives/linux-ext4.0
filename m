From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH -v2] check: add support for an external file containing
 tests to exclude
Date: Tue, 13 May 2014 08:00:27 +1000
Message-ID: <20140512220027.GM26353@dastard>
References: <20140416001530.GU15995@dastard>
 <1397624302-9577-1-git-send-email-tytso@mit.edu>
 <20140416064018.GJ15995@dastard>
 <20140512124232.GB31376@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:50085 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbaELWBC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 18:01:02 -0400
Content-Disposition: inline
In-Reply-To: <20140512124232.GB31376@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2014 at 08:42:32AM -0400, Theodore Ts'o wrote:
> On Wed, Apr 16, 2014 at 04:40:18PM +1000, Dave Chinner wrote:
> > On Wed, Apr 16, 2014 at 12:58:22AM -0400, Theodore Ts'o wrote:
> > > Currently the -X option is intended to specify a set of expunging
> > > files which are stored in each test/* subdirectory.  As described in
> > > the commit description for 0b1e8abd4, in order to exclude the test
> > > generic/280, the -X option is used as follows:
> > > 
> > >     $ cat tests/generic/3.0-stable-avoid
> > >     280
> > >     $ sudo ./check -X 3.0-stable-avoid generic/280
> > > 
> > > However, it is sometimes useful to store the set of expunged tests in
> > > a single file, outside of tests/* subdirectories.  This commit enables
> > > the following:
> > > 
> > >     $ cat /root/conf/data_journal.exclude
> > >     generic/068
> > >     ext4/301
> > >     $ sudo ./check -E /root/conf/data_journal.exclude -g auto
> > > 
> > > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > 
> > Looks good.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> This patch has apparently not hit the xfstests repository.  Would you
> like me to resend it?

No, I just haven't done an xfstests update for the past couple of
weeks because there haven't been a lot of patches and I've been busy
with other stuff. I'll do one later in the week.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
