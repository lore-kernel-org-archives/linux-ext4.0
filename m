From: Dave Chinner <david@fromorbit.com>
Subject: Re: Extremely slow remounts with concurrent I/O
Date: Thu, 13 Mar 2014 18:19:25 +1100
Message-ID: <20140313071925.GI6851@dastard>
References: <20140305141343.GA26225@xanadu.blop.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>
To: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37403 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbaCMHTa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2014 03:19:30 -0400
Content-Disposition: inline
In-Reply-To: <20140305141343.GA26225@xanadu.blop.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 05, 2014 at 03:13:43PM +0100, Lucas Nussbaum wrote:
> TL;DR: we experience long temporary hangs when doing multiple mount -o
> remount at the same time as other I/O on an ext4 filesystem.
> 
> Hi,
> 
> When starting hundreds of LXC containers simultaneously on a system, the
> boot of some containers was hanging. We tracked this down to an
> initscript's use of mount -o remount, which was hanging in D state.
> 
> We reproduced the problem outside of LXC, with the script available at
> [0]. That script initiates 1000 mount -o remount, and performs some
> writes using a big cp to the same filesystem during the remounts.
....
> Some other things we tried:
> 1) we tried to 'sync' after removing the files, and dropping the caches
> (as shown in the commented lines in [0]). That makes the problem disappear
> (or at least makes it less frequent). The overall script execution is
> actually faster with the post-rm sync and dropping caches than without
> them!
> 
> 2) We tried switching to the noop scheduler (instead of cfq). The problem
> could still be reproduced. A btrace dump with noop is available at [2].
> 
> 3) We tried with ext3 instead of ext4. The problem could never be
> reproduced.
> 
> 4) We tried on different machines, and we could reproduce the problem.
> However, on a machine with SSD drives, we were not able to reproduce the
> problem.
> 
> Any ideas?

If this really is caused by sync on ext4 being slow while there are
concurrent writers, then perhaps:

http://marc.info/?l=linux-ext4&m=139388721931428&w=2

is a possible fix...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
