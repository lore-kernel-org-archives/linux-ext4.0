From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 39/74] e2fsck: remove uninit block bitmap calculation
Date: Sat, 11 Jan 2014 14:08:32 -0500
Message-ID: <20140111190832.GE1582@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012239.30655.16666.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47575 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaAKTIf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 14:08:35 -0500
Content-Disposition: inline
In-Reply-To: <20131211012239.30655.16666.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:22:39PM -0800, Darrick J. Wong wrote:
> Since libext2fs now detects a BLOCK_UNINIT group and calculates the
> group's block bitmap, we no longer need to emulate this behavior in
> e2fsck.  We can simply compare the found block map against the
> filesystem's, and proceed from there.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
