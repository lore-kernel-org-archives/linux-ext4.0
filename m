From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: high write latency bug in ext3 / jbd in 3.4
Date: Mon, 13 Jan 2014 17:52:19 -0500
Message-ID: <20140113225219.GD11207@thunk.org>
References: <20140113201320.GD1214@kvack.org>
 <99F82313-71DA-43E6-A071-05507183D481@dilger.ca>
 <20140113211610.GE1214@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48166 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaAMWwV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 17:52:21 -0500
Content-Disposition: inline
In-Reply-To: <20140113211610.GE1214@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 13, 2014 at 04:16:10PM -0500, Benjamin LaHaise wrote:
> 
> I'm leaning towards doing this.  The main reason for not doing so was 
> primarily that a few of the tweaks that I had been made to ext3 would 
> have to be ported to ext4.  Thankfully, I think we're still in an early 
> enough stage of release that I should be able to do so.  The changes 
> are pretty specific, mostly allocator tweaks to improve the on-disk 
> layout for our specific use-case.

We have been thinking about making some changes to the block
allocator, so I'd be interested in hearing what tweaks you made and a
bit more about your use case that drove the need for these allocator
tweaks.

> I had hoped to use ext4, but the recommended fsck after changing the 
> various feature bits is a non-starter during our upgrade process (a 22 
> minute outage isn't acceptable).

You can move to ext4 without necessarily using those features which
require an fsck after the upgrade process.  That's hwo we handled the
upgrade to ext4 at Google.  New disks were formatted using ext4, but
for legacy file systems, we enabled extents feature (maybe one or two
other ones, but that was the main one) and then remounted those file
systems using ext4.  We called file systems which were upgraded in
this way "ext2-as-ext4", and our benchmarking indicated that for our
workload, that "ext2-as-ext4" got roughly half the performance gained
when comparing file systems still using ext2 with newly formated file
systems using ext4.

Given that file systems on a server got reformatted when it needs some
kind of hardware repairs, betewen hardware refresh and disks getting
reformatted as part of the refresh, the percentage of file systems
running in "ext2-as-ext4" dropped fairly quickly.

Mike Rubin gave a presentation about this two years ago at the LF
Collab Summit that went into a lot more detail about how ext4 was
adopted by Google.  That presentation is available here:

	http://www.youtube.com/watch?v=Wp5Ehw7ByuU

Cheers,

						- Ted
