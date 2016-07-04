From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] ext4: correct error value of function verifying
 dx checksum
Date: Sun, 3 Jul 2016 21:12:11 -0400
Message-ID: <20160704011211.GC17739@thunk.org>
References: <1467591304-4981-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32934 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbcGDBMP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jul 2016 21:12:15 -0400
Content-Disposition: inline
In-Reply-To: <1467591304-4981-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 04, 2016 at 09:15:04AM +0900, Daeho Jeong wrote:
> ext4_dx_csum_verify() returns the success return value in two checksum
> verification failure cases. We need to set the return values to zero
> as failure like ext4_dirent_csum_verify() returning zero when failing
> to find a checksum dirent at the tail.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
