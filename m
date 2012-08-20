From: Dave Chinner <david@fromorbit.com>
Subject: Re: Test 272 fails for ext3
Date: Tue, 21 Aug 2012 08:49:41 +1000
Message-ID: <20120820224941.GG19235@dastard>
References: <20120816092808.GA9057@quack.suse.cz>
 <20120816093757.GA11519@quack.suse.cz>
 <20120816224858.GY2877@dastard>
 <20120820162212.GA17354@quack.suse.cz>
 <20120820210638.GA4591@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, dmonakhov@openvz.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:9265 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618Ab2HTWto (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Aug 2012 18:49:44 -0400
Content-Disposition: inline
In-Reply-To: <20120820210638.GA4591@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 20, 2012 at 11:06:38PM +0200, Jan Kara wrote:
> On Mon 20-08-12 18:22:12, Jan Kara wrote:
> > On Fri 17-08-12 08:48:58, Dave Chinner wrote:
> > > On Thu, Aug 16, 2012 at 11:37:57AM +0200, Jan Kara wrote:
> > > >   Hello,
> > > > 
> > > >   I was looking into why test 272 from xfstests fails for ext3 and the
> > > > reason is that ext3 does not support direct IO to file with enabled data
> > > > journalling (open returns EINVAL because ->direct_IO callback is not
> > > > specified). So I was thinking how to accomodate this fact in the test -
> > > > the best I found was to just check using xfs_io whether O_DIRECT open
> > > > succeeds and perform the test only in that case. Attached patch does this
> > > > or do people have other ideas?
> > > 
> > > 
> > > # ext3 doesn't support direct IO in journalling mode
> > > ext3_write_opt_list="iflag=noatime conv=notrunc conv=fsync"
> > > ext4_write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
> > > 
> > > if [ $FSTYP = "ext3" ]; then
> > > 	write_opt_list="$ext3_write_opt_list"
> > > else
> > > 	write_opt_list="$ext4_write_opt_list"
> > > fi
> >   Yeah, this is probably simpler. Thanks for suggestion. BTW, ext4 also
> > does not support direct IO and data journalling but it silently falls back
> > to buffered IO. Anyway new patch is attached.
>   Hum, after testing this I realized why I did the things the original way.
> The test writes a message with title for each test so when direct IO tests
> are skipped outputs don't match.
> 
> After some thought I decided to change the test to output titles only to
> full output and keep compared output (almost) empty. Result is attached.

....
> --- a/272
> +++ b/272
> @@ -32,15 +32,18 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
> +write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
> +if [ $FSTYP = "ext3" ]; then
> +	# ext3 doesn't support direct IO in journalling mode
> +	write_opt_list="iflag=noatime conv=notrunc conv=fsync"
> +fi

Seems like asking for trouble duplicating the common options.

# ext3 doesn't support direct IO in journalling mode
write_opt_list="iflag=noatime conv=notrunc conv=fsync
[ $FSTYP = "ext4" ] && write_opt_list="$write_opt_list oflag=direct"

Otherwise looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
