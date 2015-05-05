From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/35] undo-io: add new calls to and speed up the undo io
 manager
Date: Tue, 5 May 2015 10:20:25 -0400
Message-ID: <20150505142025.GB12468@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023506.25243.44459.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45866 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993156AbbEEOU1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:20:27 -0400
Content-Disposition: inline
In-Reply-To: <20150402023506.25243.44459.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:35:06PM -0700, Darrick J. Wong wrote:
> Implement pass-through calls for discard, zero-out, and readahead in
> the IO manager so that we can take advantage of any underlying
> support.
> 
> Furthermore, improve tdb write-out speed by disabling locking and only
> fsyncing at the end -- we don't care about locking because having
> multiple writers to the undo file will produce an undo database full
> of garbage blocks; and we only need to fsync at the end because if we
> fail before the end, our undo file will lack the necessary superblock
> data that e2undo requires to do replay safely.  Without this, we call
> fsync four times per tdb update(!)  This reduces the overhead of using
> undo_io while converting a 2TB FS to metadata_csum from 3+ hours to 55
> minutes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
