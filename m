From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 16:43:32 +0200
Message-ID: <20080421144332.GA21028@one.firstfloor.org>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <87ej9085dq.fsf@basil.nowhere.org> <20080421023342.GC9700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:60415 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYDUOiA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 10:38:00 -0400
Content-Disposition: inline
In-Reply-To: <20080421023342.GC9700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> snaphot was taken.  Even if it has been remounted read-only at this
> point, this gets really dicey.  Consider that with certain types of
> corruption, if the filesystem continues to get modified, the
> corruption can get worse.

I see, but perhaps you could do that on at least some common
type of corruptions and only give up in the extreme cases?

Mind you I don't have a good feeling what common and uncommon 
types are.

> 
> > Or perhaps just tell the kernel which objects is suspicious and
> > should be EIOed.
> 
> Yeah; you could do that, as long as it's not a guarantee that all of
> the objects which were suspicious were found.  It would also be

Ok to do the 100% job you probably need metadata checksums and always
validate on initial read.

-Andi

