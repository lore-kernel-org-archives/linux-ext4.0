From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2.4 0/3] mm/fs: Remove unnecessary waiting for stable
 pages
Date: Wed, 16 Jan 2013 20:43:52 -0800
Message-ID: <20130116204352.9d343964.akpm@linux-foundation.org>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
	<20130115144608.722180b7.akpm@linux-foundation.org>
	<20130116002246.GI6426@blackbox.djwong.org>
	<20130115163359.16d64ab4.akpm@linux-foundation.org>
	<20130117024902.GJ6426@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, viro@zeniv.linux.org.uk, rminnich@sandia.gov,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447Ab3AQEjX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jan 2013 23:39:23 -0500
In-Reply-To: <20130117024902.GJ6426@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jan 2013 18:49:02 -0800 "Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> > 
> > The problem back in 2001 was that we held lock_page() across the
> > duration of page writeback, so if another thread came in and tried to
> > dirty the page, it would block on lock_page() until IO completion.  I
> > can't remember whether writeback would also block read().  Maybe it did,
> > in which case the effects of this patchset won't be as dramatic as were
> > the effects of splitting PG_lock into PG_lock and PG_writeback.
> 
> Now that you've stirred my memory, I /do/ dimly recall that Linux waited for
> writeback back in the old days.  At least we'll be back to that.

Not really.  2.4 did writeback by walking a standalone list of
buffer_heads, without locking their containing page.  I removed all
that and did writeback of the page instead.  That immediately caused
this problem, because the 2.4 writepage held lock_page() across
writeout.  So I changed that to drop lock_page() immediately after
submission and added PG_writeback to flag the under-writeback state. 
The second change went in pretty much immediately - all within the
same 2.5.x release, probably.

> As a side note, the average latency of a write to a non-DIF disk dropped down
> to nearly nothing.

Some hard numbers in the changelog would be nice.  Did you try dbench-on-ext2?

> > 
> > Do we generate nice kernel messages (at mount or device-probe time)
> > which will permit people to work out which strategy their device/fs is
> > using?
> 
> No.  /sys/devices/virtual/bdi/*/stable_pages_required will tell you
> stable pages are on or not, but so far only ext3 uses snapshots and the rest
> just wait.  Do you think a printk would be useful?

Nope, if we can query the mode under /sys then that should be sufficient.
