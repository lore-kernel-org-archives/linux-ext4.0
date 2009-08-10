From: Pavel Machek <pavel@ucw.cz>
Subject: Re: What happened to data=guarded?
Date: Mon, 10 Aug 2009 18:42:05 +0200
Message-ID: <20090810164205.GC1505@ucw.cz>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908111535.37927.elendil@planet.nl> <20090811133721.GD29224@think> <200908111654.38217.elendil@planet.nl> <878whqgyid.fsf@basil.nowhere.org> <20090811185703.GQ1756@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	Frans Pop <elendil@planet.nl>,
	Chris Mason <chris.mason@oracle.com>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41643 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbZHKVCQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 17:02:16 -0400
Content-Disposition: inline
In-Reply-To: <20090811185703.GQ1756@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 2009-08-11 14:57:03, Theodore Tso wrote:
> On Tue, Aug 11, 2009 at 05:29:14PM +0200, Andi Kleen wrote:
> > > Good to hear. I've so far stayed with data=ordered as I think I'd prefer 
> > > data=guarded over data=writeback. I'll certainly give it a try when it's 
> > > available.
> > 
> > Same here. data=writeback already cost me a few files after crashes here :/
> 
> What sort of files were you losing?  I don't know if we can improve
> the implied flush hueristics, but we should at least try to see if we
> do something about it.

IIRC... the flush heuristics invoke async flush, so you can still lose
data if you are unlucky, no?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
