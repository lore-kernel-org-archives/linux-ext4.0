From: Jan Kara <jack@suse.cz>
Subject: Re: What happened to data=guarded?
Date: Tue, 11 Aug 2009 17:34:25 +0200
Message-ID: <20090811153425.GB26070@atrey.karlin.mff.cuni.cz>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908111535.37927.elendil@planet.nl> <20090811133721.GD29224@think> <200908111654.38217.elendil@planet.nl> <878whqgyid.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frans Pop <elendil@planet.nl>,
	Chris Mason <chris.mason@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53468 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZHKPeY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 11:34:24 -0400
Content-Disposition: inline
In-Reply-To: <878whqgyid.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Frans Pop <elendil@planet.nl> writes:
> 
> > On Tuesday 11 August 2009, Chris Mason wrote:
> >> On Tue, Aug 11, 2009 at 03:35:36PM +0200, Frans Pop wrote:
> >> > Somewhat unrelated, but what happened to the data=guarded patches
> >> > Chris Mason proposed back in April?
> >>
> >> I missed 2.6.31 but plan on sending for 2.6.32.  I promised to send
> >> along a forward port of the patches a while back, but I finally have
> >> one in testing here.  It should go out shortly.
> >
> > Good to hear. I've so far stayed with data=ordered as I think I'd prefer 
> > data=guarded over data=writeback. I'll certainly give it a try when it's 
> > available.
> 
> Same here. data=writeback already cost me a few files after crashes here :/
  In this regard, data=guarded need not be better than data=writeback.
We push out the data in guarded mode as late as in writeback mode
(that's where the performance benefit comes from ;). The difference is
that we increase i_size only after data are safely on disk so we cannot
expose old data.
  So security-wise, guarded mode is as safe as ordered mode but in other
aspects its more like data=writeback.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
