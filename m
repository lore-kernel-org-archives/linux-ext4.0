From: Theodore Tso <tytso@mit.edu>
Subject: Re: What happened to data=guarded?
Date: Tue, 11 Aug 2009 14:57:03 -0400
Message-ID: <20090811185703.GQ1756@mit.edu>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908111535.37927.elendil@planet.nl> <20090811133721.GD29224@think> <200908111654.38217.elendil@planet.nl> <878whqgyid.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frans Pop <elendil@planet.nl>,
	Chris Mason <chris.mason@oracle.com>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44596 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZHKS5N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2009 14:57:13 -0400
Content-Disposition: inline
In-Reply-To: <878whqgyid.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2009 at 05:29:14PM +0200, Andi Kleen wrote:
> > Good to hear. I've so far stayed with data=ordered as I think I'd prefer 
> > data=guarded over data=writeback. I'll certainly give it a try when it's 
> > available.
> 
> Same here. data=writeback already cost me a few files after crashes here :/

What sort of files were you losing?  I don't know if we can improve
the implied flush hueristics, but we should at least try to see if we
do something about it.

						- Ted
