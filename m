From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Find the group descriptors on a 1k-block
 bigalloc,meta_bg filesystem
Date: Mon, 12 May 2014 10:07:31 -0400
Message-ID: <20140512140731.GD31376@thunk.org>
References: <20131220001541.GA10189@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34635 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaELOHd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 10:07:33 -0400
Content-Disposition: inline
In-Reply-To: <20131220001541.GA10189@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 04:15:42PM -0800, Darrick J. Wong wrote:
> On a filesystem with a 1k block size, the group descriptors live in
> block 2, not block 1.  If the filesystem has bigalloc,meta_bg set,
> however, the calculation of the group descriptor table location does
> not take this into account and returns the wrong block number.  Fix
> the calculation to return the correct value for this case.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
