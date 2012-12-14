From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide
 stable pages during write
Date: Thu, 13 Dec 2012 17:48:06 -0800
Message-ID: <50CA8556.7030905@mit.edu>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org> <20121213080811.23360.98131.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50046 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2LNBsJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2012 20:48:09 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1976472pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2012 17:48:09 -0800 (PST)
In-Reply-To: <20121213080811.23360.98131.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/13/2012 12:08 AM, Darrick J. Wong wrote:
> Several complaints have been received regarding long file write latencies when
> memory pages must be held stable during writeback.  Since it might not be
> acceptable to stall programs for the entire duration of a page write (which may
> take many milliseconds even on good hardware), enable a second strategy wherein
> pages are snapshotted as part of submit_bio; the snapshot can be held stable
> while writes continue.
> 
> This provides a band-aid to provide stable page writes on jbd without needing
> to backport the fixed locking scheme in jbd2.  A mount option is added to ext4
> to allow administrators to enable it there.

I'm a bit confused as to what it has to do with ext3.  Wouldn't this be
useful as a mount option everywhere, though?

If this becomes widely used, would it be better to snapshot on
wait_for_stable_page instead of on io submission?

FWIW, I'm about to pound pretty hard on this whole patchset on a box
that doesn't need stable pages.  I'll let you know how it goes.

--Andy
