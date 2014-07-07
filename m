From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: journal has aborted
Date: Mon, 7 Jul 2014 18:56:19 -0400
Message-ID: <20140707225619.GD8254@thunk.org>
References: <20140703161551.5fd13245@archvile>
 <87tx6yzdxz.fsf@openvz.org>
 <20140704114031.2915161a@archvile>
 <87r421zavi.fsf@openvz.org>
 <20140704132802.0d43b1fc@archvile>
 <20140704122022.GC10514@thunk.org>
 <20140704154559.026331ec@archvile>
 <20140704184539.GA11103@thunk.org>
 <20140707141701.2f9529af@archvile>
 <20140707155310.GB8254@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>
To: David Jander <david@protonic.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49827 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaGGW4Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2014 18:56:25 -0400
Content-Disposition: inline
In-Reply-To: <20140707155310.GB8254@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 07, 2014 at 11:53:10AM -0400, Theodore Ts'o wrote:
> An update from today's ext4 concall.  Eric Whitney can fairly reliably
> reproduce this on his Panda board with 3.15, and definitely not on
> 3.14.  So at this point there seems to be at least some kind of 3.15
> regression going on here, regardless of whether it's in the eMMC
> driver or the ext4 code.  (It also means that the bug fix I found is
> irrelevant for the purposes of working this issue, since that's a much
> harder to hit, and that bug has been around long before 3.14.)
> 
> The problem in terms of narrowing it down any further is that the
> Pandaboard is running into RCU bugs which makes it hard to test the
> early 3.15-rcX kernels.....

In the hopes of making it easy to bisect, I've created a kernel branch
which starts with 3.14, and then adds on all of the ext4-related
commits since then.   You can find it at:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git test-mb_generate_buddy-failure

https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/log/?h=test-mb_generate_buddy-failure

Eric, can you see if you can repro the failure on your Panda Board?
If you can, try doing a bisection search on these series:

git bisect start
git bisect good v3.14
git bisect bad test-mb_generate_buddy-failure

Hopefully if it is caused by one of the commits in this series, we'll
be able to pin point it this way.

Thanks!!

						- Ted
