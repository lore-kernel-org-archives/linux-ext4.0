From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH]JBD2/JBD: race condition while writing updates to
	journal
Date: Sat, 18 Jul 2009 21:14:21 +0200
Message-ID: <20090718191421.GB1210@duck.suse.cz>
References: <4A3F3B32.9090606@gmail.com> <20090715144729.GC22826@atrey.karlin.mff.cuni.cz> <20090715181343.GF22826@atrey.karlin.mff.cuni.cz> <20090717013612.GF8508@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dingdinghua@nrchpc.ac.cn,
	dingdinghua <dingdinghua85@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbZGRTOX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2009 15:14:23 -0400
Content-Disposition: inline
In-Reply-To: <20090717013612.GF8508@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 16-07-09 21:36:12, Theodore Tso wrote:
> On Wed, Jul 15, 2009 at 08:13:43PM +0200, Jan Kara wrote:
> > >   Ted, I don't think this got merged...
> >   Ah, I see, jbd2 part got merged by you, I'm not sure about the jbd
> > part since I didn't see Andrew reply. I guess I'll create a tree for
> > ext3/jbd changes and merge this patch (and other ext3/jbd fixes I have
> > here) through it.
> 
> I did get a note from Andrew saying he had grabbed the patch.  It
> probably hasn't been published in his mmotm tree yet.
  Thanks for info. Yes, I can see the patch in mmotm now.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
