From: Jan Kara <jack@suse.cz>
Subject: Re: writev corruption and 64-bit quota patches for 2.6.33-rc1?
Date: Wed, 9 Dec 2009 11:58:52 +0100
Message-ID: <20091209105851.GC4863@quack.suse.de>
References: <20091208110043.GC4095@quack.suse.de>
 <20091208212109.GT27692@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47807 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbZLIK6v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 05:58:51 -0500
Content-Disposition: inline
In-Reply-To: <20091208212109.GT27692@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 08-12-09 16:21:09, tytso@mit.edu wrote:
> On Tue, Dec 08, 2009 at 12:00:43PM +0100, Jan Kara wrote:
> >   Hi Ted,
> > 
> >   do you plan on merging my fixes for writev filesystem corruption and
> > 64-bit quota patches? The writev patch is independent of any other patch
> > and should go in ASAP, 64-bit quota patch depends on generic quota code
> > change so either I can merge it or you can merge a bit later (it's a small
> > change for ext4).
> 
> Why don't I take the writev patch, and let you merge the 64-bit quota
> patch along with the generic quota changes?  Does that make sense?
  Yes, fine for me. I just didn't want to merge ext4 quota changes without
your approval.

> The only thing that worries me a tiny bit is that there are some quota
> bug fixes which the OpenVZ folks have submitted, that I need to review
> and haven't gotten to yet, and there's a chance they may conflict with
> your 64-bit ext4 quota changes.  But I'm sure we can deal with any
> potential merge conflicts should they come up.
  Yes, I need to take a look at those as well. So far they don't seem to be
conflicting AFAICS.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
