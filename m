From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] filefrag: minor code fixes and cleanups
Date: Fri, 1 Aug 2014 22:09:40 -0400
Message-ID: <20140802020940.GF27252@thunk.org>
References: <1406751951-23059-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, David Sterba <dsterba@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41264 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbaHBCJo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2014 22:09:44 -0400
Content-Disposition: inline
In-Reply-To: <1406751951-23059-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 30, 2014 at 02:25:49PM -0600, Andreas Dilger wrote:
> Print filefrag_fiemap() error message to stderr instead of stdout.
> 
> Only call ioctl(EXT3_IOC_GETFLAGS) for ext{2,3,4} filesystems to
> decide if the ext2 indirect block allocation heuristic shold be used.
> 
> Properly handle the the force_bmap (-B) option.
> 
> Exit with a positive error number instead of a negative one.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

						- Ted
