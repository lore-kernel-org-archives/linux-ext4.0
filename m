From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: [PATCH 4/5] libext2fs: Implement
 ext2fs_find_first_zero_generic_bmap().
Date: Mon, 26 Mar 2012 16:53:56 +0300
Message-ID: <20120326135355.GB2180@cc.hut.fi>
References: <20120310213321.GK6961@sli.dy.fi>
 <20120310213740.GO6961@sli.dy.fi>
 <5E845FD5-30E4-47A1-AF8E-70A288E3442D@dilger.ca>
 <20120312191514.GS6961@sli.dy.fi>
 <20120323223331.GA8554@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-02.aalto.fi ([130.233.228.121]:49699 "EHLO
	smtp-out-02.aalto.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab2CZNx5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Mar 2012 09:53:57 -0400
Content-Disposition: inline
In-Reply-To: <20120323223331.GA8554@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 23, 2012 at 06:33:31PM -0400, Ted Ts'o wrote:
> It would then be very easy to build iterators on *top* of
> find_first_zero() and find_first_set(), and in fact this could be used
> to replace some of the places where we are using a sorted list (i.e.,
> the badblocks list).  So that sounds like a good idea, and I can
> definitely think of some places where we could use that code today.
> 
> So I plan to pull in your patch series and then we can further enhance
> this with iterator support afterwards.  Sami, if you'd be interested
> in implementing iterators, that would be great!

Just to be on the same page, what is the motivation for iterators? Is
it performance, making the code cleaner or facilitating further
functionality?

If it's driven by performance concerns, it would be good to first have
a case where they cause performance problems. Otherwise it would be
good to first figure out a program in the e2fsprogs suite that
exercises (or could exercise) the code in question, just for testing.

My work on inode allocation was actually entirely driven by a friend's
observation that resize2fs took 16 CPU hours to shrink a filesystem.
Profile-guided optimization is something I generally do a lot, but I'm
not averse to doing other kinds of useful coding tasks for useful open
source projects.

	Sami
