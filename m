From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH,RFC] ext4: add lazytime mount option
Date: Thu, 13 Nov 2014 16:34:50 -0500
Message-ID: <20141113213450.GA28780@thunk.org>
References: <1415765227-9561-1-git-send-email-tytso@mit.edu>
 <20141113064150.GI28565@dastard>
 <20141113163511.GA15585@thunk.org>
 <20141113204832.GJ28565@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57339 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933636AbaKMVex (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 16:34:53 -0500
Content-Disposition: inline
In-Reply-To: <20141113204832.GJ28565@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2014 at 07:48:32AM +1100, Dave Chinner wrote:
> However, we'd be fools to ignore the development of relatime, which
> in it's original form never updated the atime until m/ctime updated.
> 3 years after it was introduced, relatime was changed to limit the
> update delay to 24 hours (before it was made the default) so that
> applications that required regular updates to timestamps didn't
> silently stop working.
> 
> So perhaps what we should simply define "lazytime" policy to be
> "only update timestamps once a day or whenever the inode is
> otherwise modified, whichever comes first".

Yes, that's reasonable thing to do.  Right after I hit send on my last
email I thought about adding a tunable that would do this sort of time
delay, but making it be a hard-coded 24 hours is simpler.

> lazytime isn't POSIX compliant as it is implemented in the patch.
> sync() won't write back inodes with lazy timestamp updates as they
> are not tracked in dirty lists or the ext4 journal, therefore a
> crash after a sync() can still lose timestamp updates from before
> the sync() ran.

Good point, I had fixed it for fsync(), but not for sync();
fortunately it's easy enough to make sure this gets fixed if we
implement it at the VFS Layer.

> w.r.t. default behaviour, like relatime, I think this it will be a
> couple of years before we can consider it to be a default.  We'll
> need to shake out it's impact on the Real World first....

Fair enough, although that will only work if distributions actually
enable it by default so we get that real world experience.  Otherwise,
we'll not gain any experience wrt to Real World impact.

What I'm thinking about doing is adding a way to enable lazytime via a
flag in the ext4 superblock, which in turn can be set by tune2fs or
mke2fs (if so enabled by /etc/mke2fs.conf), so that we _can_ get this
real world experience.

Cheers,

						- Ted
