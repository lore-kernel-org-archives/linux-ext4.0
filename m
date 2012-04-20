From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not
 empty
Date: Fri, 20 Apr 2012 12:12:11 +1000
Message-ID: <20120420021211.GD9541@dastard>
References: <20120412160658.GA9697@gmail.com>
 <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi>
 <alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi>
 <4F901E0C.3010008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jouko Orava <jouko.orava@helsinki.fi>, linux-ext4@vger.kernel.org,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:9610 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab2DTCMQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 22:12:16 -0400
Content-Disposition: inline
In-Reply-To: <4F901E0C.3010008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 19, 2012 at 09:15:40AM -0500, Eric Sandeen wrote:
> On 4/19/12 8:10 AM, Jouko Orava wrote:
> > I'd also like to point at the real bug here, in Jouni's original strace:
> > 
> > 	writev(3, [{"\0\0\0\0\0\0\0\0", 8}, {"", 2147483648}], 2) = -2147483640
> > 
> > The syscall returns a negative value, which is not the actual number of
> > bytes written (since it is 32-bit wrapped), and errno has not been
> > changed. There is no way for userspace to handle this result correctly!
> > 
> > There is no way anyone sane should just gloss over this saying
> > "programmer fault, you're doing it wrong".
> > This is a real bug, and deserves fixing sooner rather than later.
> 
> Agreed, I think Dave was a little to quick on the draw on his reply.  :)

I was pointing the -EFAULT error in the second syscall which was
just being passed the 2GB sized buffer, not the above error from the
first syscall.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
