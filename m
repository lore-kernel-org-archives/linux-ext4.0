From: Nick Piggin <npiggin@suse.de>
Subject: Re: IO error semantics
Date: Tue, 26 Jan 2010 04:59:54 +1100
Message-ID: <20100125175954.GC2018@laptop>
References: <4B4EEE86.7080807@hitachi.com>
 <20100114141803.GB3146@quack.suse.cz>
 <20100118051847.GA8678@laptop>
 <20100118060518.GA9151@laptop>
 <20100118122437.GF7264@discord.disaster>
 <20100118140039.GA13909@laptop>
 <D65C918F-8CCD-4626-BA84-FD0410A5E81F@cam.ac.uk>
 <4B5DB78D.2090408@redhat.com>
 <20100125174723.GB28459@thunk.org>
 <4B5DD9DB.7070300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Anton Altaparmakov <aia21@cam.ac.uk>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	linux-fsdevel@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34230 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0AYR76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jan 2010 12:59:58 -0500
Content-Disposition: inline
In-Reply-To: <4B5DD9DB.7070300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 25, 2010 at 12:50:19PM -0500, Ric Wheeler wrote:
> On 01/25/2010 12:47 PM, tytso@mit.edu wrote:
> >On Mon, Jan 25, 2010 at 10:23:57AM -0500, Ric Wheeler wrote:
> >>
> >>For permanent write errors, I would expect any modern drive to do a
> >>sector remapping internally. We should never need to track this kind
> >>of information for any modern device that I know of (S-ATA, SAS,
> >>SSD's and raid arrays should all handle this).
> >
> >... and if the device is run out of all of its blocks in its spare
> >blocks pool, it's probably well past the time to replace said disk.
> >
> >BTW, I really liked Dave Chinner's summary of the issues involved; I
> >ran into Kawai-san last week at Linux.conf.au, and we discussed pretty
> >much the same thing over lunch.  (i.e., that it's a hard problem, and
> >in some cases we need to retry the writes, such as a transient FC path
> >problem --- but some kind of write throttling is critical or we could
> >end up choking the VM due to too many pages getting dirtied and no way
> >of cleaning them.)
> >
> >						- Ted
> 
> Also note that retrying writes (or reads for that matter) often are
> counter productive. For those of us who have suffered with trying to
> migrate data off of an old, failing disk onto a new, shiny one,
> excessive retries can be painful...

That is probably true most of the time. So some sane defaults should
be attempted that work for most cases.

After that, retrying I was imagining should be driven by the
application. So: attempting to read or fsync again.

What should not happen is for the page to be marked !dirty or !uptodate.
This randomly breaks write to read consistency without necessarily even
any error reported, so it seems really hard for an app to do the right
thing there.

