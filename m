From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/10] xfstests: Stress tests improments v5
Date: Tue, 26 Feb 2013 09:09:41 +1100
Message-ID: <20130225220941.GH5551@dastard>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
 <20130225154512.GA32171@thunk.org>
 <20130225212811.GY22182@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Dmitry Monakhov <dmonakhov@openvz.org>, dchinner@redhat.com
To: Ben Myers <bpm@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:31645 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab3BYWJp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 17:09:45 -0500
Content-Disposition: inline
In-Reply-To: <20130225212811.GY22182@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2013 at 03:28:11PM -0600, Ben Myers wrote:
> Hey Ted,
> 
> On Mon, Feb 25, 2013 at 10:45:12AM -0500, Theodore Ts'o wrote:
> > Hi, what's the status of this patch series?  It looks like Dmitry has
> > responded to all of Dave's concerns --- is that correct?
> > 
> > Is there anything else we need to do before these patches get merged
> > into the xfstests git tree?
> 
> I think we just need a review to see if Dave's concerns have been addressed and
> then we're ready to go.

That doesn't stop anyone else from reviewing it. I've got my hands
full right now, and doing stuff like reviewing patches that
nobody else seems to want to look at is something that I'm doing
when I have a little spare time.

I've already reviewed al the patches and the changes have been made,
so all my final review is going to be is validating the patches
apply and work as advertised, so anyone really can do that. I
couldn't do that last time around because the patches didn't apply
to my tree. Since then I haven't had a slot available to go back and
look at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
