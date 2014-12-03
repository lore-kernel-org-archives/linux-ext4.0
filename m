From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 49/47] libext2fs: don't report garbage inodes with really
 large inodes
Date: Tue, 2 Dec 2014 22:18:18 -0500
Message-ID: <20141203031818.GO13618@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141127000136.GP10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36032 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaLCDSZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 22:18:25 -0500
Content-Disposition: inline
In-Reply-To: <20141127000136.GP10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2014 at 04:01:36PM -0800, Darrick J. Wong wrote:
> If the inode size is large enough that there are fewer than two inodes
> per block, don't report an inode checksum failure as a garbage inode
> during the scan because the "more than half are broken" criteria that
> we use to decide if a block of inodes is garbage doesn't really apply.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
