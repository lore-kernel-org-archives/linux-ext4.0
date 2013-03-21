From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 299-305: remove fio config files after finished
 test
Date: Thu, 21 Mar 2013 13:47:42 +1100
Message-ID: <20130321024742.GM17758@dastard>
References: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com>
 <20130321010902.GH17758@dastard>
 <514A6B5F.7000705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:5675 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab3CUCrq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 22:47:46 -0400
Content-Disposition: inline
In-Reply-To: <514A6B5F.7000705@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 20, 2013 at 09:07:27PM -0500, Eric Sandeen wrote:
> On 3/20/13 8:09 PM, Dave Chinner wrote:
> > On Tue, Mar 19, 2013 at 05:30:50PM +0800, Zheng Liu wrote:
> >> From: Zheng Liu <wenqing.lz@taobao.com>
> >>
> >> After finished test, temporarily fio config file should be removed.
> >>
> >> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> >> ---
> >>  299 | 2 +-
> >>  300 | 2 +-
> >>  301 | 2 +-
> >>  302 | 2 +-
> >>  303 | 2 +-
> >>  304 | 2 +-
> >>  305 | 1 +
> >>  7 files changed, 7 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/299 b/299
> >> index 4305ead..9d0c32f 100644
> >> --- a/299
> >> +++ b/299
> >> @@ -32,7 +32,7 @@ echo "QA output created by $seq"
> >>  here=`pwd`
> >>  tmp=/tmp/$$
> >>  status=1	# failure is the default!
> >> +trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
> > 
> > Umm, wouldn't this be better:
> > 
> > -trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > +trap "rm -f $tmp*; exit \$status" 0 1 2 3 15
> > 
> 
> Naming the files $tmp.fio would have worked too, but *shrug*
> doesn't seem that critical.  Still:
> 
> >      2. You can safely create temporary files that are not part of the
> >         filesystem tests (e.g. to catch output, prepare lists of things
> >         to do, etc.) in files named $tmp.<anything>.  The standard test
> >         script framework created by "new" will initialize $tmp and
> >         cleanup on exit.

Good point. With that in mind, I think renaming the fio files is the
right thing to do, not changing the traps to have to handle
arbitrary tmp file names...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
