From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Tue, 22 Apr 2008 15:48:51 +0100
Message-ID: <20080422144851.GD4849@shareable.org>
References: <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org> <20080420234241.GB23292@shareable.org> <20080421080111.GD14446@one.firstfloor.org> <1208798974.14123.28.camel@localhost> <480CD18F.7000108@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>,
	Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:48318 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbYDVOtM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 10:49:12 -0400
Content-Disposition: inline
In-Reply-To: <480CD18F.7000108@firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andi Kleen wrote:
> > Is there a reason why this isn't being done other than performance?
> 
> One reason against it is that in many (but not all) setups to guarantee
> reaching the platter you have to disable the write cache, and at least
> for consumer level hard disks disk vendors generally do not recommend
> doing this because it significantly lowers the MTBF of the disk.

I think the MTBF argument is a bit spurious, because guaranteeing it
reaches the platter with all modern disks is possible, with the
appropriate kernel changes, and does not require the write cache to be
disabled.

TBH, I think the reason is it's simply never been implemented.  There
are other strategies for mitigating data loss, after all, and
filesystem structure is not at risk; barriers are fine for that.

Right now, you have the choice of 'disable write cache' or 'fsync
flushes sometimes but not always, depending on lots of factors'.

The option 'fsync flushes always, write cache enabled' isn't
implemented, though most hardware supports it.

Btw, on Darwin (Mac OS X) it _is_ because of performance that fsync()
doesn't issue a flush to platter.  It has an fcntl(F_FULLSYNC) which
is documented to do the latter.

-- Jamie
