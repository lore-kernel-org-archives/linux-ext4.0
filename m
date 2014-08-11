From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 11 Aug 2014 16:10:30 -0400
Message-ID: <20140811201030.GH6553@thunk.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042643.2441.79312.stgit@birch.djwong.org>
 <20140811052151.GA2808@birch.djwong.org>
 <20140811062415.GG15431@thunk.org>
 <20140811063120.GB2808@birch.djwong.org>
 <20140811143423.GB3506@thunk.org>
 <20140811180509.GE2808@birch.djwong.org>
 <20140811183258.GF6553@thunk.org>
 <20140811185532.GA1695@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55191 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbaHKUKe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 16:10:34 -0400
Content-Disposition: inline
In-Reply-To: <20140811185532.GA1695@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 11:55:32AM -0700, Darrick J. Wong wrote:
> I was expecting 16 groups (32M readahead) to win, but as the observations in my
> spreadsheet show, 2MB tends to win.  I _think_ the reason is that if we
> encounter indirect map blocks or ETB blocks, they tend to be fairly close to
> the file blocks in the block group, and if we're trying to do a large readahead
> at the same time, we end up with a largeish seek penalty (half the flexbg on
> average) for every ETB/map block.

Hmm, that might be an argument for not trying to increase the flex_bg
size, since we want to keep seek distances within a flex_bg to be
dominated by settling time, and not by the track-to-track
accelleration/coasting/deaccelleration time.

> I figured out what was going on with the 1TB SSD -- it has a huge RAM cache big
> enough to store most of the metadata.  At that point, reads are essentially
> free, but readahead costs us ~1ms per fadvise call. 

Do we understand why fadvise() takes 1ms?   Is that something we can fix?

And readahead(2) was even worse, right?

							- Ted
