From: Neil Brown <neilb@suse.de>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Tue, 12 May 2009 09:38:21 +1000
Message-ID: <18952.46829.115084.46432@notabene.brown>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	<20090511083754.GA29082@mit.edu>
	<20090511100624.GB6585@logfs.org>
	<20090511112729.GD29082@mit.edu>
	<20090511120936.GB6277@mit.edu>
	<87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com>
	<20090511142740.GC6277@mit.edu>
	<4A08365F.5040805@redhat.com>
	<20090511145059.GD6277@mit.edu>
	<20090511150040.GF8112@parisc-linux.org>
	<87f94c370905111147t77250b92pc511ef9c6c0e7e42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
	Ric Wheeler <rwheeler@redhat.com>,
	"J?rn Engel" <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux RAID <linux-raid@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884AbZEKXiI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 19:38:08 -0400
In-Reply-To: message from Greg Freemyer on Monday May 11
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday May 11, greg.freemyer@gmail.com wrote:
> 
> And since the mdraid layer is not currently planning to track what has
> been discarded over time, when a re-shape comes along, it will
> effectively un-trim everything and rewrite 100% of the FS.

You might not call them "plans" exactly, but I have had thoughts
about tracking which part of an raid5 had 'live' data and which were
trimmed.  I think that is the only way I could support TRIM, unless
devices guarantee that all trimmed blocks read a zeros, and that seems
unlikely.
You are right that the granularity would have to be at least
one stripe.
And a re-shape would be interesting, wouldn't it!  We could probably
avoid instantiating every trimmed block, but in general quite a few
would get instantiated.. I hadn't thought about that...

NeilBrown
