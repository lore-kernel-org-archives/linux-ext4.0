From: Jan Kara <jack@suse.cz>
Subject: Re: What happened to data=guarded?
Date: Wed, 12 Aug 2009 22:37:56 +0200
Message-ID: <20090812203756.GA10729@duck.suse.cz>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908111535.37927.elendil@planet.nl> <20090811133721.GD29224@think> <200908111654.38217.elendil@planet.nl> <878whqgyid.fsf@basil.nowhere.org> <20090811185703.GQ1756@mit.edu> <20090810164205.GC1505@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	Frans Pop <elendil@planet.nl>,
	Chris Mason <chris.mason@oracle.com>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42724 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZHLUh5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2009 16:37:57 -0400
Content-Disposition: inline
In-Reply-To: <20090810164205.GC1505@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 10-08-09 18:42:05, Pavel Machek wrote:
> On Tue 2009-08-11 14:57:03, Theodore Tso wrote:
> > On Tue, Aug 11, 2009 at 05:29:14PM +0200, Andi Kleen wrote:
> > > > Good to hear. I've so far stayed with data=ordered as I think I'd prefer 
> > > > data=guarded over data=writeback. I'll certainly give it a try when it's 
> > > > available.
> > > 
> > > Same here. data=writeback already cost me a few files after crashes here :/
> > 
> > What sort of files were you losing?  I don't know if we can improve
> > the implied flush hueristics, but we should at least try to see if we
> > do something about it.
> 
> IIRC... the flush heuristics invoke async flush, so you can still lose
> data if you are unlucky, no?
  Of course you can but it can happen in data=ordered mode as well (if the
machine crashes before the transaction is committed). The percieved
difference is in the fact that kjournald starts its commit every 5 seconds
while pdflush starts writeback every 30-35 seconds. So if you use
data=guarded/writeback mode and set dirty_expire_centisecs to 500, the
experience wrt. data loss is going to be similar to data=ordered mode.
fsync with heavy background writers won't be that painful as in data=ordered
mode but apart from that the performance will be probably comparable.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
