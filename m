From: Jan Kara <jack@suse.cz>
Subject: ext4_map_blocks() and friends
Date: Thu, 8 Oct 2015 15:22:19 +0200
Message-ID: <20151008132219.GA591@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371AbbJHNWV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Oct 2015 09:22:21 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 47654AD21
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2015 13:22:19 +0000 (UTC)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

So I'm going through the twisty labyrinth of ext4_map_blocks() and
related functions to fix DAX related issues. Since I don't want to just
bolt changes DAX needs somewhere on the side of that monster (it has
already enough cruft bolted at various places) I'm looking into factoring
some parts out.

One thing I've noticed is the handling of delayed && unwritten extents.
Currently we have quite some code to handle this case and it seems a bit
disproportionate given how rare it is - AFAIU this can happen only when
someone fallocates blocks under delalloc blocks. Also I'm somewhat uneasy
that the whole unwritten extent gets marked as dealloc if any block in it
was delalloc. That seems to have a potential for delalloc accounting issues
(especially in bigalloc case), SEEK_DATA will report such unwritten extents
as delayed (only a potential performance issue when someone then reads
whole unwritten extent only to find out there's a bit of data in it),
FIEMAP won't report delalloc flag for such extent at all...

I see two solutions here:

1) We can fixup these issues (probably would need some massaging of extent
cache code, fixup in FIEMAP).

2) We could just forbid such state - we could do that by fsyncing() range
before it will be fallocated and exclude page faults for the file while
fallocate is running (using new i_mmap_sem ext4 will have similarly to xfs).

I'm in favor of solution 2) since IMHO fallocate under delalloc blocks
mostly signals an application problem and so performance doesn't matter.
But other's may have different opinion... Anyone?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
