From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: fix overly-pessimistic calculation of minimum
 size required
Date: Sun, 27 Apr 2014 00:35:37 -0400
Message-ID: <20140427043537.GC25172@thunk.org>
References: <1398566894-14576-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34923 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaD0Efk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Apr 2014 00:35:40 -0400
Content-Disposition: inline
In-Reply-To: <1398566894-14576-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 26, 2014 at 10:48:14PM -0400, Theodore Ts'o wrote:
> For extent-mapped file systems, we need to reserve some extra space in
> case we need to grow the extent tree.  Calculate the safety margin
> more intelligently, so we don't overestimate the amount of space
> required.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Reported-by: Dmitry Monakhov <dmonakhov@openvz.org>

I'm going to have to self-NACK this.  This patch causes the resize2fs
regression tests to fail.  (In fact, Dmitry's original patch also
causes the resize2fs regression tests to fail.)

The problem is kind of messy; when the file system starts at some
insanely large size, and we shrink it very small, we end up releasing
a lot of inode tables in the first block group (many for other block
groups).  But until we're 100% sure the resize will be successful, we
don't want to start overwriting those inode table blocks.

For this reason, if we try to constrain resize the file system down
from 2TB to 512MB in one shot, we need to do this in multiple steps.
I.e. by calling "resize2fs -M /dev/sdXX" multiple times.

There really isn't a good way around this, and in fact, if people are
going to be doing silly things like take a file system from 16T down
to 750MB, if they need to run resize2fs multiple times, that's fine.
It would be nice if you could shrink the file system down in a single
shot, but it's not high priority.

					- Ted
