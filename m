From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/18] e2fsck: perform implied cluster allocations when
 filling a directory hole
Date: Sat, 26 Jul 2014 16:08:46 -0400
Message-ID: <20140726200846.GL6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003357.28334.84385.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58640 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbaGZUIs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 16:08:48 -0400
Content-Disposition: inline
In-Reply-To: <20140726003357.28334.84385.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:33:57PM -0700, Darrick J. Wong wrote:
> If we're filling a directory hole, we need to perform an implied
> cluster allocation to satisfy the bigalloc rule of mapping only one
> pblk to a logical cluster.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
