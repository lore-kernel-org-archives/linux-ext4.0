From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix partial cluster handling for bigalloc file
 systems
Date: Thu, 13 Mar 2014 23:35:11 -0400
Message-ID: <20140314033511.GA27678@thunk.org>
References: <20140312212736.GA2284@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41190 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbaCNDfN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2014 23:35:13 -0400
Content-Disposition: inline
In-Reply-To: <20140312212736.GA2284@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2014 at 05:27:36PM -0400, Eric Whitney wrote:
> Commit 9cb00419fa, which enables hole punching for bigalloc file
> systems, exposed a bug introduced by commit 6ae06ff51e in an earlier
> release.  When run on a bigalloc file system, xfstests generic/013, 068,
> 075, 083, 091, 100, 112, 127, 263, 269, and 270 fail with e2fsck errors
> or cause kernel error messages indicating that previously freed blocks
> are being freed again.
> 
> The latter commit optimizes the selection of the starting extent in
> ext4_ext_rm_leaf() when hole punching by beginning with the extent
> supplied in the path argument rather than with the last extent in the
> leaf node (as is still done when truncating).  However, the code in
> rm_leaf that initially sets partial_cluster to track cluster sharing on
> extent boundaries is only guaranteed to run if rm_leaf starts with the
> last node in the leaf.  Consequently, partial_cluster is not correctly
> initialized when hole punching, and a cluster on the boundary of a
> punched region that should be retained may instead be deallocated.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
