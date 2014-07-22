From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/24] e2fsck: skip clearing bad extents if bitmaps are
 unreadable
Date: Tue, 22 Jul 2014 13:58:24 -0400
Message-ID: <20140722175824.GK25291@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225304.31374.95208.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50563 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaGVUea (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:34:30 -0400
Content-Disposition: inline
In-Reply-To: <20140718225304.31374.95208.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:53:04PM -0700, Darrick J. Wong wrote:
> If the bitmaps are known to be unreadable, don't bother clearing them;
> just mark fsck to restart itself after pass 5, by which time the
> bitmaps should be fixed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
