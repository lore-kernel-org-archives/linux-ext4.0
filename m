From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 3/3] ext4: Return error code from ext4_mb_good_group()
Date: Mon, 8 Jun 2015 11:42:36 -0400
Message-ID: <20150608154236.GF19168@thunk.org>
References: <1433266205-24513-1-git-send-email-lczerner@redhat.com>
 <1433266205-24513-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53101 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbbFHPmi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 11:42:38 -0400
Content-Disposition: inline
In-Reply-To: <1433266205-24513-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 02, 2015 at 07:30:05PM +0200, Lukas Czerner wrote:
> Currently ext4_mb_good_group() only returns 0 or 1 depending on whether
> the allocation group is suitable for use or not. However we might get
> various errors and fail while initializing new group including -EIO
> which would never get propagated up the call chain. This might lead to
> an endless loop at writeback when we're trying to find a good group to
> allocate from and we fail to initialize new group (read error for
> example).
> 
> Fix this by returning proper error code from ext4_mb_good_group() and
> using it in ext4_mb_regular_allocator(). In ext4_mb_regular_allocator()
> we will always return only the first occurred error from
> ext4_mb_good_group() and we only propagate it back  to the caller if we
> do not get any other errors and we fail to allocate any blocks.
> 
> Note that with other modes than errors=continue, we will fail
> immediately in ext4_mb_good_group() in case of error, however with
> errors=continue we should try to continue using the file system, that's
> why we're not going to fail immediately when we see an error from
> ext4_mb_good_group(), but rather when we fail to find a suitable block
> group to allocate from due to an problem in group initialization.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
