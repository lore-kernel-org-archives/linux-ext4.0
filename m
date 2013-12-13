From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/74] misc: use the checksum predicate function, not raw
 flag tests
Date: Thu, 12 Dec 2013 23:34:10 -0500
Message-ID: <20131213043410.GD23888@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011935.30655.61763.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39575 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3LMEeM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 23:34:12 -0500
Content-Disposition: inline
In-Reply-To: <20131211011935.30655.61763.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:19:35PM -0800, Darrick J. Wong wrote:
> metadata_csum implies uninit_bg, and in fact forces the bit off for
> rocompat with older implementations.  Therefore, to detect the
> presence of checksums, we should use the predicate function to decide
> if group descriptor checksums are turned on, not open-coded flag
> tests.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied to the next branch.

				- Ted
