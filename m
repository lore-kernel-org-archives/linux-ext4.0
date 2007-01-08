From: Pavel Machek <pavel@ucw.cz>
Subject: Re: How git affects kernel.org performance
Date: Mon, 8 Jan 2007 14:59:52 +0100
Message-ID: <20070108135952.GF25857@elf.ucw.cz>
References: <1168140954.2153.1.camel@nigel.suspend2.net> <45A08269.4050504@zytor.com> <45A083F2.5000000@zytor.com> <Pine.LNX.4.64.0701062130260.3661@woody.osdl.org> <20070107085526.GR24090@1wt.eu> <20070107011542.3496bc76.akpm@osdl.org> <20070108030555.GA7289@in.ibm.com> <20070108125819.GA32756@thunk.org> <20070108134147.GB5291@linuxtv.org> <20070108135622.GD32756@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44041 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751516AbXAHOBX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jan 2007 09:01:23 -0500
To: Theodore Tso <tytso@mit.edu>, Johannes Stezenbach <js@linuxtv.org>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Andrew Morton <akpm@osdl.org>, Willy Tarreau <w@1wt.eu>,
	Linus Torvalds <torvalds@osdl.org>,
	"H. Peter Anvin" <hpa@zytor.com>, git@vger.kernel.org,
	nigel@nigel.suspend2.net, "J.H." <warthog9@kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	webmaster@kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070108135622.GD32756@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> > Would e2fsck -D help? What kind of optimization
> > does it perform?
> 
> It will help a little; e2fsck -D compresses the logical view of the
> directory, but it doesn't optimize the physical layout on disk at all,
> and of course, it won't help with the lack of readahead logic.  It's
> possible to improve how e2fsck -D works, at the moment, it's not
> trying to make the directory be contiguous on disk.  What it should
> probably do is to pull a list of all of the blocks used by the
> directory, sort them, and then try to see if it can improve on the
> list by allocating some new blocks that would make the directory more
> contiguous on disk.  I suspect any improvements that would be seen by
> doing this would be second order effects at most, though.

...sounds like a job for e2defrag, not e2fsck...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
