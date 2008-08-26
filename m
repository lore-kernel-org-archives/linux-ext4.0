From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck shouln't consider superblock summaries as fatal
Date: Tue, 26 Aug 2008 13:04:20 -0400
Message-ID: <20080826170420.GE8720@mit.edu>
References: <20080826104502.GH3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60283 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752303AbYHZREX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 13:04:23 -0400
Content-Disposition: inline
In-Reply-To: <20080826104502.GH3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2008 at 04:45:02AM -0600, Andreas Dilger wrote:
> Running e2fsck on a quiescent (but mounted) filesystem fails in the
> common case where the superblock inode and block count summaries are
> wrong.  The kernel doesn't update these values except at unmount time.
> If there are other errors in the filesystem then they will already
> cause e2fsck to consider the filesystem invalid, so these minor errors
> should not.

Sure, but *when* would it ever be safe to run e2fsck without -n on a
mounted filesystem?  What's the scenario where this would matter?  And
on an unmounted filesystem, if the block counts are wrong, and the
user refuses to fix them the filesystem technically really isn't 100%
valid.

					- Ted
