From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: journal has aborted
Date: Mon, 7 Jul 2014 11:53:10 -0400
Message-ID: <20140707155310.GB8254@thunk.org>
References: <20140703134338.GE2374@thunk.org>
 <20140703161551.5fd13245@archvile>
 <87tx6yzdxz.fsf@openvz.org>
 <20140704114031.2915161a@archvile>
 <87r421zavi.fsf@openvz.org>
 <20140704132802.0d43b1fc@archvile>
 <20140704122022.GC10514@thunk.org>
 <20140704154559.026331ec@archvile>
 <20140704184539.GA11103@thunk.org>
 <20140707141701.2f9529af@archvile>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: David Jander <david@protonic.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49108 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaGGPxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2014 11:53:16 -0400
Content-Disposition: inline
In-Reply-To: <20140707141701.2f9529af@archvile>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An update from today's ext4 concall.  Eric Whitney can fairly reliably
reproduce this on his Panda board with 3.15, and definitely not on
3.14.  So at this point there seems to be at least some kind of 3.15
regression going on here, regardless of whether it's in the eMMC
driver or the ext4 code.  (It also means that the bug fix I found is
irrelevant for the purposes of working this issue, since that's a much
harder to hit, and that bug has been around long before 3.14.)

The problem in terms of narrowing it down any further is that the
Pandaboard is running into RCU bugs which makes it hard to test the
early 3.15-rcX kernels.  There is some indication that the bug showed
up in the ext4 patches which Linus pulled at the beginning of
3.15-rc3.  However, due to the ARM (or at least Pandaboard) RCU bugs,
it's not possible to bisect test this on the Pandaboard.

And on the x86_64, it takes most of a day to confirm the absence of a
test failure.  (Although this is with a HDD, so assuming that we don't
have an eMMC as well as an ext4 regression in 3.15, it seems likely
that the problem is with some kind of ext4 regression sometime between
3.14 and 3.15.

So we are making progress, but it's slow.  Hopefuly we'll know more in
the near future.

Thanks to everyone who has been working on this bug!

Cheers,

					- Ted
