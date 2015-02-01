From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Writes blocked on wait_for_stable_page (Writes of less than page
 size sometimes take too long)
Date: Sat, 31 Jan 2015 21:37:23 -0500
Message-ID: <20150201023723.GB3070@thunk.org>
References: <54C93169.3000600@codeaurora.org>
 <54C93811.1040107@codeaurora.org>
 <20150128213914.GE9976@birch.djwong.org>
 <54C96F87.7000502@codeaurora.org>
 <54C97262.3010406@codeaurora.org>
 <20150128235705.GI21455@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikhilesh Reddy <reddyn@codeaurora.org>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47319 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbbBACh3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Jan 2015 21:37:29 -0500
Content-Disposition: inline
In-Reply-To: <20150128235705.GI21455@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 28, 2015 at 03:57:05PM -0800, Darrick J. Wong wrote:
> Yes, that wait_for_page_writeback() was replaced with a call to
> wait_for_stable_page() upstream, so it'll probably work for your 3.10
> kernel.
> 
> (I also wonder why not jump to a newer LTS kernel, but that's neither
> here nor there.)

Nikhilesh said that he was using a 64-bit android device.  I'm going
to guess it is based off of the AOSP kernel for the Nexus 9, which is
a 64-bit android device that uses 3.10 as a base.  It's not *really* a
3.10 kernel, though, becausre it looks like bits and pieces of the VFS
was forward ported to a somewhat newer version so they could backport
F2FS to the Nexus 9 kernel.  But I'm guessing he's using it because
there are device drivers he needs that might not be available without
a lot of forward-porting work on a newer kernel.

If you are interested in trying to use a somewhat newer version of
ext4, I just *happen* to have a backport of the 3.18 version of ext4
on top of a stock version of 3.10.  You can find it at the
backport-to-3.10 branch of the ext4.git tree on git.kernel.org.

If you are starting from the AOSP version of the Nexus 9 kernel, the
patch series from that branch won't apply 100% cleanly, because of the
changes resulting from the F2FS backport.  It's relatively
straight-forward though to use the backport-to-3.10 patch series as a
model to get a version of 3.18 ext4 on top of the AOSP kernel, though;
it's mostly dropping or reworking patches that were no longer
necessary thanks to the F2FS backport.

If there is interest, I can look into what might be involved in making
a git repo of an AOSP kernel with the 3.18 ext4 code backported to it
available.

I won't give any warrantees, of course, since the AOSP kernel doesn't
build on x86 and so I can't easily run regression tests on it.  So if
it breaks, you will get to keep both pieces.  I will try to at least
look at bug reports, though, and I can say that 3.18 backport on the
stock 3.10 kernel survives xfstests much better than the 3.10 version
of ext4, since a modern xfstests very quickly caused the stock 3.10
kernel to panic.  :-)

						- Ted
						
