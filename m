From: Theodore Tso <tytso@mit.edu>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Sun, 10 Aug 2008 14:22:31 -0400
Message-ID: <20080810182231.GB15353@mit.edu>
References: <E1KSEkA-00009o-CV@closure.thunk.org> <489F2B38.3060104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47421 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752223AbYHJSWe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Aug 2008 14:22:34 -0400
Content-Disposition: inline
In-Reply-To: <489F2B38.3060104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 10, 2008 at 12:54:00PM -0500, Eric Sandeen wrote:
> 
> Hm, and I tried writing out 10 files in order as a simple test but
> umount/remount brought me back many 0-byte files, I need to update my
> patchset I guess.  :)
> 

One of the questions in my mind is whether this is a regression
triggered by the some of our most recent patches....  since I only
have 2.2% files reported a fragmented by e2fsck, and if this problem
had always been there, I would have expected a much higher
fragmentation number.  So if you have some older kernels, you might
want to see if you can replicate the problem.  I've since found that
just doing a copy via "(tar -cf - -C / usr/include ) | tar -C /mnt -xf -)"
is sufficient to see the problem.  Just add a "sync; sleep 5" before 
the umount.  :-)

							- Ted
