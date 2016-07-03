From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: avoid modifying checksum fields directly during
 checksum verification
Date: Sun, 3 Jul 2016 18:05:13 -0400
Message-ID: <20160703220513.GB17739@thunk.org>
References: <1465971173-5612-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: darrick.wong@oracle.com, linux-ext4@vger.kernel.org,
	Youngjin Gil <youngjin.gil@samsung.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59798 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbcGCWFT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jul 2016 18:05:19 -0400
Content-Disposition: inline
In-Reply-To: <1465971173-5612-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 15, 2016 at 03:12:53PM +0900, Daeho Jeong wrote:
> We temporally change checksum fields in buffers of some types of
> metadata into '0' for verifying the checksum values. By doing this
> without locking the buffer, some metadata's checksums, which are
> being committed or written back to the storage, could be damaged.
> In our test, several metadata blocks were found with damaged metadata
> checksum value during recovery process. When we only verify the
> checksum value, we have to avoid modifying checksum fields directly.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>

Applied, thanks!

						- Ted
