From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6 v4] Lazy itable initialization for Ext4
Date: Tue, 28 Sep 2010 11:05:24 -0400
Message-ID: <20100928150524.GD7865@thunk.org>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
 <20100928040142.GA7865@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41092 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab0I1PF1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Sep 2010 11:05:27 -0400
Content-Disposition: inline
In-Reply-To: <20100928040142.GA7865@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 28, 2010 at 12:01:42AM -0400, Ted Ts'o wrote:
> Why are they strange?  Because this was running under KVM, and there
> were no underlying hardware problems in the host OS.
> 
> The other two times I got a hard hang at XFStests 219 and 83, and the
> system was caught in such a type look that magic-sysrq wasn't working
> correctly.
> 
> I've XFStests in this setup before applying these patches, and things
> worked fine.  I'm currently rolling back the patches and trying
> another xfstests runs just to make sure the problem wasn't introduced
> by some patch, but for now, it looks there might be a problem
> somewhere.  And unfortunately, since it's not happening in a regular
> location or test, and the system is so badly locked up sysrq doesn't
> work, finding it may be intersting....

I've just tried bisecting the patches, and tried applying the first
three (well, two since I combined patches #2 and #3).  Simply enabling
the init_itables code wasn't enough to trigger the problem.  It looks
like the problem is in the last three patches (probably in one of the
patches where we convert ext4 to use sb_issue_zeroout, either the
extent or the resize code).

What I'll probably do (unless we find the problem very quickly) is to
reorder things so that we take the init_itable patch and the sysfs
feature patch, and put the rest into the unstable portion of the patch
queue.  That way I can work on the rest of the ext4 patches for the
merge window, without getting blocked on this patch series.  And if we
don't manage to figure out what went wrong, while it would be nice to
simplify the code for 2.6.36, it won't be the end of the world if they
need to wait until the next cycle.

				- Ted
