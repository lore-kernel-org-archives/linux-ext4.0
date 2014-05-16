From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfstests: new mailing list
Date: Sat, 17 May 2014 08:19:30 +1000
Message-ID: <20140516221930.GA8554@dastard>
References: <20140516044611.GA8206@dastard>
 <20140516054009.GA17647@infradead.org>
 <alpine.LFD.2.00.1405161047010.2099@localhost.localdomain>
 <20140516085320.GA29279@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Luk?? Czerner <lczerner@redhat.com>, fstests@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140516085320.GA29279@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 16, 2014 at 01:53:20AM -0700, Christoph Hellwig wrote:
> On Fri, May 16, 2014 at 10:48:42AM +0200, Luk?? Czerner wrote:
> > > > As requested I've created a new mailing list for xfstests
> > > > development and discussion. Reflecting the fact that the test
> > > > harness is not really XFS specific anymore, the list is:
> > > > 
> > > > 	fstests@vger.kernel.org
> > > 
> > > Isn't there an "x" missing somewhere?
> > 
> > It's intentional and it is "Reflecting the fact that the test
> > harness is not really XFS specific anymore", even though the test
> > suite itself keep the name xfstests.
> > 
> > This way it's more obvious to people that this is in fact not xfs
> > specific.
> 
> Having the name different from the project it is for is stupid.  Either
> rename the test suite, or use the same name for the mailing list.

Renaming the test suite take a lot more work - .e.g renaming/moving
source trees and a fixing all the documentation that points to it...

So, small steps.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
