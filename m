From: Ben Myers <bpm@sgi.com>
Subject: Re: Test 272 fails for ext3
Date: Tue, 18 Sep 2012 16:26:40 -0500
Message-ID: <20120918212640.GW3274@sgi.com>
References: <20120816092808.GA9057@quack.suse.cz>
 <20120816093757.GA11519@quack.suse.cz>
 <20120816224858.GY2877@dastard>
 <20120820162212.GA17354@quack.suse.cz>
 <20120820210638.GA4591@quack.suse.cz>
 <20120820224941.GG19235@dastard>
 <20120821080338.GA7537@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	dmonakhov@openvz.org, xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:42500 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754802Ab2IRV0o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 17:26:44 -0400
Content-Disposition: inline
In-Reply-To: <20120821080338.GA7537@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 21, 2012 at 10:03:39AM +0200, Jan Kara wrote:
> On Tue 21-08-12 08:49:41, Dave Chinner wrote:
> > On Mon, Aug 20, 2012 at 11:06:38PM +0200, Jan Kara wrote:
> > ....
> > > --- a/272
> > > +++ b/272
> > > @@ -32,15 +32,18 @@ tmp=/tmp/$$
> > >  status=1	# failure is the default!
> > >  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > >  
> > > +write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
> > > +if [ $FSTYP = "ext3" ]; then
> > > +	# ext3 doesn't support direct IO in journalling mode
> > > +	write_opt_list="iflag=noatime conv=notrunc conv=fsync"
> > > +fi
> > 
> > Seems like asking for trouble duplicating the common options.
> > 
> > # ext3 doesn't support direct IO in journalling mode
> > write_opt_list="iflag=noatime conv=notrunc conv=fsync
> > [ $FSTYP = "ext4" ] && write_opt_list="$write_opt_list oflag=direct"
> > 
> > Otherwise looks fine.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
>   OK, I've updated the test as you suggested. Result is attached.

Committed to git://oss.sgi.com/xfs/cmds/xfstests.git, master branch.
