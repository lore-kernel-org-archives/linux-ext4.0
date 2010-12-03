From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] ext4: Set barrier=0 when block device does not
	advertise flush support
Date: Fri, 3 Dec 2010 01:14:45 -0800
Message-ID: <20101203091445.GK18195@tux1.beaverton.ibm.com>
References: <20101203001659.GI18195@tux1.beaverton.ibm.com> <20101203070950.GA19071@infradead.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59863 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676Ab0LCJOp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Dec 2010 04:14:45 -0500
Content-Disposition: inline
In-Reply-To: <20101203070950.GA19071@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 03, 2010 at 02:09:50AM -0500, Christoph Hellwig wrote:
> On Thu, Dec 02, 2010 at 04:16:59PM -0800, Darrick J. Wong wrote:
> > If the user tries to enable write flushes with "barrier=1" and the underlying
> > block device does not support flushes, print a message and set barrier=0.
> 
> That doesn't make any sense at all with the ne wFLUSH+FUA code, which is
> designed to make the cache flushing entirely transparanent.  Basically
> with the new code the barrier option should become a no-op and always
> enabled.

Are we ready to remove the barrier= mount option at this point?  How many users
exist who use barrier=0 to speed up write performance when they're willing to
take on the added safety risk?

I've noticed that provisioning goes faster if one mounts the filesystem with
barrier=0; so long as the control software turns barriers on after the deploy
finishes and always restarts the deploy after a failure, a power failure on the
client system won't cause problems.  Unfortunately, there doesn't seem to be
any other way to communicate that relaxation to the code.

Personally I'd rather the knob remain in ext4 on the grounds that I know my
workloads and can judge the appropriate level of risk, especially since ext4
picks the safe option by default.  However, I'd prefer /proc/mounts not
misrepresent the status of flush support, to the best of ext4's knowledge.

--D
