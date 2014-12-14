From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/47] misc: don't allow mk_hugefiles unless the fs
 supports extents
Date: Sat, 13 Dec 2014 21:51:35 -0500
Message-ID: <20141214025135.GD29787@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215224.883.32873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54829 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaLNCvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 21:51:42 -0500
Content-Disposition: inline
In-Reply-To: <20141107215224.883.32873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:52:24PM -0800, Darrick J. Wong wrote:
> The current mk_hugefile code in mke2fs doesn't support creating
> non-extent files, so disable the functionality when we're mkfs'ing
> without extent support.
> 
> The fallocate patches further on will eliminate the need for this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
