From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix inode checksum calculation problem of inode in
 some range of inode size
Date: Thu, 1 Dec 2016 11:51:49 -0500
Message-ID: <20161201165149.cfaehwinobvi4aut@thunk.org>
References: <1479860927-4459-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Youngjin Gil <youngjin.gil@samsung.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50566 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753128AbcLAQvz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 11:51:55 -0500
Content-Disposition: inline
In-Reply-To: <1479860927-4459-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 23, 2016 at 09:28:46AM +0900, Daeho Jeong wrote:
> We've fixed the race condition problem in calculating ext4 checksum
> value in commit b47820edd163 ("ext4: avoid modifying checksum fields
> directly during checksum veficationon"). However, by this change,
> when calculating the checksum value of inode whose i_extra_size is
> less than 4, we couldn't calculate the checksum value in a proper way.
> This problem was found and reported by Nix, Thank you.
> 
> Reported-by: Nix <nix@esperi.org.uk>
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
