From: Jan Kara <jack@suse.cz>
Subject: Re: Hole punching and mmap races
Date: Fri, 18 May 2012 15:32:50 +0200
Message-ID: <20120518133250.GC5589@quack.suse.cz>
References: <20120515224805.GA25577@quack.suse.cz>
 <20120516021423.GO25351@dastard>
 <20120516130445.GA27661@quack.suse.cz>
 <20120517074308.GQ25351@dastard>
 <20120517232829.GA31028@quack.suse.cz>
 <20120518101210.GX25351@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	Hugh Dickins <hughd@google.com>, linux-mm@kvack.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966056Ab2ERNdL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 May 2012 09:33:11 -0400
Content-Disposition: inline
In-Reply-To: <20120518101210.GX25351@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 18-05-12 20:12:10, Dave Chinner wrote:
> On Fri, May 18, 2012 at 01:28:29AM +0200, Jan Kara wrote:
> > On Thu 17-05-12 17:43:08, Dave Chinner wrote:
> > > On Wed, May 16, 2012 at 03:04:45PM +0200, Jan Kara wrote:
> > > > On Wed 16-05-12 12:14:23, Dave Chinner wrote:
> > > IIRC, it's a rare case (that I consider insane, BTW):  read from a
> > > file with into a buffer that is a mmap()d region of the same file
> > > that has not been faulted in yet.....
> >   With punch hole, the race is less insane - just punching hole in the area
> > which is accessed via mmap could race in a bad way AFAICS.
> 
> Seems the simple answer to me is to prevent page faults while hole
> punching, then....
  Yes, that's what I was suggesting in the beginning :) And I was asking
whether people are OK with another lock in the page fault path (in
particular in ->page_mkwrite) or whether someone has a better idea (e.g.
taking mmap_sem in the hole punching path seems possible but I'm not sure
whether that would be considered acceptable abuse).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
