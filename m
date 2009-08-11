From: Andi Kleen <andi@firstfloor.org>
Subject: Re: What happened to data=guarded?
Date: Tue, 11 Aug 2009 21:09:35 +0200
Message-ID: <20090811190935.GB21252@basil.fritz.box>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908111535.37927.elendil@planet.nl> <20090811133721.GD29224@think> <200908111654.38217.elendil@planet.nl> <878whqgyid.fsf@basil.nowhere.org> <20090811185703.GQ1756@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	Frans Pop <elendil@planet.nl>,
	Chris Mason <chris.mason@oracle.com>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:35865 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZHKTJi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 15:09:38 -0400
Content-Disposition: inline
In-Reply-To: <20090811185703.GQ1756@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2009 at 02:57:03PM -0400, Theodore Tso wrote:
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

Common case is something patched or git checkout shortly (but not
as short as in seconds) before the crash.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
