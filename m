From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Mon, 18 Jun 2012 23:12:42 -0400
Message-ID: <20120619031241.GA3884@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
 <20120619015745.GJ25389@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Spelic <spelic@shiftmail.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2FSDMx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2012 23:12:53 -0400
Content-Disposition: inline
In-Reply-To: <20120619015745.GJ25389@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 18 2012 at  9:57pm -0400,
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jun 18, 2012 at 11:33:50PM +0200, Spelic wrote:
>
> > Please note that since I am above MD raid5 (I believe this is the
> > reason), the passdown of discards does not work, as my dmesg says:
> > [160508.497879] device-mapper: thin: Discard unsupported by data
> > device (dm-1): Disabling discard passdown.
> > but AFAIU, unless there is a thinp bug, this should not affect the
> > unmapping of thin blocks by fstrimming xfs... and in fact ext4 is
> > able to do that.
> 
> Does ext4 report that same error?

That message says the underlying device doesn't support discards
(because it is an MD device).  But the thinp device still has discards
enabled -- it just won't pass the discards down to the underlying data
device.

So yes, it'll happen with ext4 -- it is generated when the thin-pool
device is loaded (which happens independent of the filesystem that is
layered ontop).

The discards still inform the thin-pool that the corresponding extents
are no longer allocated.
