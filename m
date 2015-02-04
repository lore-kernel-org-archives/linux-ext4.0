From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Writes blocked on wait_for_stable_page (Writes of less than page
 size sometimes take too long)
Date: Wed, 4 Feb 2015 12:02:51 -0500
Message-ID: <20150204170251.GG2509@thunk.org>
References: <54C93169.3000600@codeaurora.org>
 <54C93811.1040107@codeaurora.org>
 <20150128213914.GE9976@birch.djwong.org>
 <54C96F87.7000502@codeaurora.org>
 <54C97262.3010406@codeaurora.org>
 <20150128235705.GI21455@birch.djwong.org>
 <20150201023723.GB3070@thunk.org>
 <54D15F0D.6030109@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53478 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526AbbBDRC5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Feb 2015 12:02:57 -0500
Content-Disposition: inline
In-Reply-To: <54D15F0D.6030109@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 03, 2015 at 03:51:41PM -0800, Nikhilesh Reddy wrote:
> >
> >I won't give any warrantees, of course, since the AOSP kernel doesn't
> >build on x86 and so I can't easily run regression tests on it.  So if
> >it breaks, you will get to keep both pieces.  I will try to at least
> >look at bug reports, though, and I can say that 3.18 backport on the
> >stock 3.10 kernel survives xfstests much better than the 3.10 version
> >of ext4, since a modern xfstests very quickly caused the stock 3.10
> >kernel to panic.  :-)

Note: I managed to patch/bludgeon the AOSP kernel so it will build on
x86 (apparently some Nvidia engineers wasn't very careful about adding
Tegra support without breaking x86 builds, boo hiss), and so I was
able to run a quick smoke test using kvm-xfstests.  "kvm-xfstests
smoke" runs most of the tests successfully, modulo a few expected
failures, but then the kernel locks up after executing "echo 3 >
/proc/sys/vm/drop_caches; cat /proc/slabinfo" in the test framework,
which happens just before it halts the VM.

I suspect there is a bug in my commit (f9f56f19dc) which lets ext4 use
the older shrinker API which is used by the 3.10 kernel.  It's on my
todo list to look at, but I'm in Mountain View this week and my time
has been almost toally sucked up by meetings, so I haven't gotten to
it yet.

So in case you end up doing some testing of the 3.10 backport branch,
I thought I should give you a quick heads up.

Cheers,

						- Ted
