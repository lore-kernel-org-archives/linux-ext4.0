From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: add support for resizing filesystems with
 ea_inode feature
Date: Mon, 24 Jul 2017 00:08:37 -0400
Message-ID: <20170724040837.fq3snzdro6exk2xx@thunk.org>
References: <20170715003849.1982-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52748 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbdGXEIj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Jul 2017 00:08:39 -0400
Content-Disposition: inline
In-Reply-To: <20170715003849.1982-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 14, 2017 at 05:38:49PM -0700, Tahsin Erdogan wrote:
> Resizing filesystems with ea_inode feature was disallowed so far
> because the code for updating the ea entries was missing. This patch
> adds that support.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.  I do have a few comments; if you can look into
providing some test cases, that would be great.  Also, although this
isn't first change that we've added to resize2fs which has this
property, it used to be that if resize2fs was interrupted, the user
could usually recover by running e2fsck.  With ea_inode, there will be
cases where resize2fs getting interrupted could result in the file
system's extended attributes getting pretty badly scrambled.

Using an undo file is one way to solve the problem; so perhaps
something we should consider is making the undo file enabled by
default.  (Although then we need to figure out where to put it; the
current directory might not be the right place, especially if it
happens to be /tmp.)

					- Ted
