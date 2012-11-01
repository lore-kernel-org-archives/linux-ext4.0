From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: Wed, 31 Oct 2012 23:49:42 -0700
Message-ID: <20121101064942.GF19576@blackbox.djwong.org>
References: <20121101015015.GA28919@thunk.org>
 <20121101061212.16497.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, tm@tao.ma
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:41748 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2KAGtu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2012 02:49:50 -0400
Content-Disposition: inline
In-Reply-To: <20121101061212.16497.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 01, 2012 at 02:12:12AM -0400, George Spelvin wrote:
> > This one was cc'ed to stable@vger.kernel.org.  But when you said "I
> > notice, that neither of thse have made it into 2.6.5", I assume you
> > meant 3.5?
> 
> Whoops, typo!  I meant 3.6.5, the very latest just-out-today stable
> kernel.
> 
> Quite a few 3.6.x kernels have come out since that patch was Cc'ed,
> and it keeps not being included.  So I wondered.
> 
> > So that means it should eventually make it to the 3.4.x and 3.6.x
> > kernels.
> 
> That's what I thought, but I didn't want to pester Greg until I was sure
> of your intentions.
> 
> > At this point I'll just include it in the patches to be sent to Linus
> > at the next merge window, mainly because I don't have the time to run
> > a separate regression test run just for this patch, and it's only a
> > cosmetic issue, right?
> 
> Well, it causes the file system to be marked dirty and unnecessarily
> checked on reboot, which I contend is a bug, but it's not a data-loss
> bug.
> 
> I do worry that it could cause file lookup to fail when it shouldn't,
> which *is* effectively a data-loss bug, even if the data reappears
> on reboot.  But I'd have to understand the problem and fix better to
> know if that actually happens; I haven't observed it.

Yes, it would be useful to know what's going on with this directory file, since
it seems to fallback to linear scan, yet e2fsck -D doesn't fix it.  What I was
/going/ for was that the kernel would notice a bad directory and flag it for
fsck on reboot.  Upon reboot, fsck would be run, notice the bad dir, and feed
it to the directory rebuilder to get it fixed for good.  However, there doesn't
seem to be any real checksum mismatch, so the rebuild doesn't happen.

Also ... refresh my memory -- some files have disappeared as a result of this
happening?

--D
