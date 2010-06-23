From: Jan Kara <jack@suse.cz>
Subject: Re: Updated ext4 quota design document
Date: Wed, 23 Jun 2010 14:30:14 +0200
Message-ID: <20100623123014.GA13649@quack.suse.cz>
References: <E1OQg7e-0001mI-AB@closure.thunk.org>
 <20100622142047.GF3338@quack.suse.cz>
 <20100622200853.GD6843@thunk.org>
 <20100622202927.GA9413@quack.suse.cz>
 <20100622215200.GE6843@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0FWMai (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jun 2010 08:30:38 -0400
Content-Disposition: inline
In-Reply-To: <20100622215200.GE6843@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 22-06-10 17:52:00, tytso@mit.edu wrote:
> On Tue, Jun 22, 2010 at 10:29:27PM +0200, Jan Kara wrote:
> >   With metadata which get journaled it should be quite easy. JBD already
> > must know before you go and modify buffer contents - that's why
> > journal_get_write_access and friends exist. It also makes sure that your
> > data cannot be modified from the moment the buffer enters commit upto the
> > moment the commit is finished. So you can use buffer commit hook to compute
> > and store block checksum safely.
> 
> True, but we're also interested in making sure this feature can be
> used in the non-journal case as well....
  Ah, I forgot about that... Doing per-block checksums in that case would
be indeed more complicated. So computing checksum for each dquot is
probably simpler.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
