From: jim owens <jowens@hp.com>
Subject: Re: [Jfs-discussion] benchmark results
Date: Sat, 26 Dec 2009 11:00:59 -0500
Message-ID: <4B36333B.3030600@hp.com>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org> <20091225162238.GB19303@bitmover.com> <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Larry McVoy <lm@bitmover.com>, tytso@mit.edu,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:16187 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZLZQBG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Dec 2009 11:01:06 -0500
In-Reply-To: <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christian Kujau wrote:
 
> I was using "sync" to make sure that the data "should" be on the disks 

Good, but not good enough for many tests... info sync

CONFORMING TO
       POSIX.2

NOTES
       On Linux, sync is only guaranteed to  schedule  the  dirty  blocks  for
       writing;  it  can  actually take a short time before all the blocks are
       finally written.

This is consistent with all the feels-like-unix OSes I have used.

And to make it even more random, the hardware (drive/controller)
write cache state needs to be accounted for, and what the filesystem
does if anything to try to ensure device-cache-to-media consistency.

That does not mean I'm saying the tests are invalid or not useful,
only that people need to evaluate "what do they really tell me".

jim
