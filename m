From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: fix block bitmap initialization under
 sparse_super2
Date: Mon, 12 May 2014 10:16:18 -0400
Message-ID: <20140512141618.GE31376@thunk.org>
References: <20140501231720.892.58712.stgit@birch.djwong.org>
 <20140501231734.892.13049.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34652 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492AbaELOQU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 10:16:20 -0400
Content-Disposition: inline
In-Reply-To: <20140501231734.892.13049.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 04:17:34PM -0700, Darrick J. Wong wrote:
> The ext4_bg_has_super() function doesn't know about the new rules for
> where backup superblocks go on a sparse_super2 filesystem.  Therefore,
> block bitmap initialization doesn't know that it shouldn't reserve
> space for backups in groups that are never going to contain backups.
> The result of this is e2fsck complaining about the block bitmap being
> incorrect (fortunately not in a way that results in cross-linked
> files), so fix the whole thing.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
