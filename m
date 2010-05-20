From: tytso@mit.edu
Subject: Re: ext4 df regression introduced by commit 9d0be50
Date: Thu, 20 May 2010 19:32:45 -0400
Message-ID: <20100520233245.GG16634@thunk.org>
References: <20100510180531.GA13538@untroubled.org>
 <20100520161121.GB28963@atrey.karlin.mff.cuni.cz>
 <20100520163214.GC28770@untroubled.org>
 <20100520205911.GA2317@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55635 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab0ETXcs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 19:32:48 -0400
Content-Disposition: inline
In-Reply-To: <20100520205911.GA2317@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 20, 2010 at 02:59:11PM -0600, Bruce Guenter wrote:
> On Thu, May 20, 2010 at 10:32:14AM -0600, Bruce Guenter wrote:
> > IIRC this only affects NFS clients.  The same test running locally on
> > the server doesn't show the same problem.  I will retest shortly and
> > confirm (and also test with 2.6.34).
> 
> Sorry, I was mistaken.  Running 'df' either locally or remotely shows
> the same results.
> 
> I have been unable to reproduce the problem with a simplified test
> program as of yet, and have so far been unable to reproduce the problem
> with 2.6.34 with any program either.
> 
> Hopefully this means the problem has been solved, but I'll let you know
> if it reappears in 2.6.34

Sorry for not responding right away; I've been a bit swamped lately
and this fell through the cracks in my inbox.

Yes this is fixed in 2.6.34.  The fix for your problem was commit
d330a5be.  If I have a moment to breathe I'll try to get that
backported to the 2.6.33 stable series, but upgrading to 2.6.34 works
too.  :-)

					- Ted
