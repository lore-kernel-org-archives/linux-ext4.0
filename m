From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fsck repair takes very long for 1,761 inodes containing
 multiply-claimed blocks on ext4
Date: Fri, 17 Apr 2015 17:08:51 -0400
Message-ID: <20150417210851.GB9700@thunk.org>
References: <CAD-ux60opdAx0+t3EmwR1GWT6t3rZv7CXhxNNbwQLKX6jz_z7Q@mail.gmail.com>
 <20150415190614.GA11592@birch.djwong.org>
 <20150416150045.GB7445@thunk.org>
 <CAD-ux61ti+D7_O2Xrtap5WEi7aFryQ4JoX4eO+J7dcuJS=DZag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Akos Csete <akos.csete@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45535 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbbDQVJO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2015 17:09:14 -0400
Content-Disposition: inline
In-Reply-To: <CAD-ux61ti+D7_O2Xrtap5WEi7aFryQ4JoX4eO+J7dcuJS=DZag@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 17, 2015 at 04:05:04PM -0400, Akos Csete wrote:
> 
> Could I then just wipe the inodes of the older files (and restore them
> later from backup) and let the new file claim those blocks? Or are the
> new file's claim to those blocks suspect?

OK, if the mod times are different, then it probably wasn't a case of
an inode getting written to the wrong place on disk.  What probably
did happen is the block allocation bitmaps got corrupted, and so
blocks that were in use (and should have been marked in use) were not,
so they got used for some other inode.

So yes, you can try wiping the inodes for the older files, and hope
for the best, but it may be that some of the newer files may end up
getting corrupted.  So you might want to do some spot checks
afterwards.  And if you have backups, this might be a good time to
consider going to your backup tapes....

						- Ted
