From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] blkid: fix ZFS device detection
Date: Sun, 6 Mar 2016 18:10:25 -0500
Message-ID: <20160306231025.GA30238@thunk.org>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38266 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbcCFXKa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 18:10:30 -0500
Content-Disposition: inline
In-Reply-To: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 05, 2016 at 05:38:31PM -0700, Andreas Dilger wrote:
> From: Andreas Dilger <andreas.dilger@intel.com>
> 
> While the main blkid functionality is in util-linux, there is still
> use for blkid on non-Linux platforms.
> 
> Fix the ZFS device detection by looking at multiple uberblocks to
> see if any are present, rather than looking for the ZFS boot block
> which is not always present.
> 
> There are slots for up to 128 uberblocks, but the first 4 are not
> written to disk on a newly-formatted filesystem, so check several
> of them at different offsets within the uberblock array.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

Thanks, applied.

					- Ted
