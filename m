From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: (resend) extent header problems following shrink with resize2fs
Date: Thu, 25 Dec 2008 08:09:58 -0500
Message-ID: <20081225130958.GH9871@mit.edu>
References: <87abanbfvo.fsf@burly.wgtn.ondioline.org> <20081223061833.GQ23723@mit.edu> <877i5ozprb.fsf@burly.wgtn.ondioline.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Paul Collins <paul@burly.ondioline.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:36356 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbYLYNME (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Dec 2008 08:12:04 -0500
Content-Disposition: inline
In-Reply-To: <877i5ozprb.fsf@burly.wgtn.ondioline.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 25, 2008 at 08:18:48PM +1300, Paul Collins wrote:
> My real concern, which I didn't highlight well and buried way down in my
> original report to boot, was e2fsck blowing up like it did.  Hardware
> being what it is, I imagine at some point extent headers will get
> corrupted, and losing one file is of course preferable to losing the
> entire filesystem.

Yeah, I know about that problem.  It was highlighted recently but what
with the end of the year coming up I haven't had a chance to fix it
yet.  It's an embarassing oversight on my part; I didn't notice that I
failed to handle this case because it happens relatively rarely that
an extent tree has a depth >= 2 in the first place, since this error
only happens when an non-leaf interior node gets corrupted.  I had
left it as an "we'll handle this later" case, and I never got back to
it.  The short-term workaround is simply to use debugfs and use the
clri function:

debugfs -w /dev/sdb1
debugfs: clri <38979>
debugfs: quit

... and then run e2fsck.  I'll get this fixed in the next maintenance
release of e2fsprogs, though, which will be out soon.  We have a few
ext4 related problems that I really need to get fixed and out the
door.

	   	      	      	    	    	- Ted
