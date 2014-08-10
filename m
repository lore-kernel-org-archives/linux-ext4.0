From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/21] e2fsck: check inline dir size is a multiple of 4
Date: Sun, 10 Aug 2014 18:47:11 -0400
Message-ID: <20140810224711.GD15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010655.2611.5690.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53538 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaHJWrO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:47:14 -0400
Content-Disposition: inline
In-Reply-To: <20140805010655.2611.5690.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:06:55PM -0700, Darrick J. Wong wrote:
> Directory entries must have a size that's a multiple of 4; therefore
> the inline directory structure must also have a size that is a muliple
> of 4.  Since e2fsck doesn't check this, we should check that now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
