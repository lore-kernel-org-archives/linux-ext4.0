From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/47] libext2fs: refactor extent head creation
Date: Tue, 2 Dec 2014 22:55:26 -0500
Message-ID: <20141203035526.GT13618@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215132.883.2460.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36112 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaLCDz3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 22:55:29 -0500
Content-Disposition: inline
In-Reply-To: <20141107215132.883.2460.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:51:32PM -0800, Darrick J. Wong wrote:
> Don't open-code the creation of the extent tree header, since
> ext2fs_extent_open2() knows how to take care of this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
