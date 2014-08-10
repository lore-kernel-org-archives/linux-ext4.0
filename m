From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 09/21] e2fsck: check ea-in-inode regions for overlap
Date: Sun, 10 Aug 2014 18:35:16 -0400
Message-ID: <20140810223516.GU15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010555.2611.52850.stgit@birch.djwong.org>
 <20140808224358.GF11191@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53481 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaHJWfS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:35:18 -0400
Content-Disposition: inline
In-Reply-To: <20140808224358.GF11191@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 03:43:58PM -0700, Darrick J. Wong wrote:
> Ensure that the various blobs in the in-inode EA region do not overlap.
> 
> v2: Actually clear the magic number when we're clearing a bad inode EA
> region, not whatever comes after it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
