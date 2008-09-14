From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sun, 14 Sep 2008 09:48:59 -0400
Message-ID: <20080914134859.GB21746@infradead.org>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080913212903.GF26128@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Sep 13, 2008 at 05:29:03PM -0400, Theodore Tso wrote:
> Part of the problem/frustration as we go around and round fs-devel is
> that some people would request new features to support new
> filesystems, and other people have been rejecting new features because
> it makes the interface more complicated.
> 
> In fact, the previous version of the patch had a flag for compression,
> but Cristoph Hellwig objected because he claimed there were no users
> for it.

Let's make it clear, I've said to not add it unless we have users.  And
What Anton brought up is exactly the reason for that - to support
encrypted extents we actually need more information in the structure.
That's why we need to have this broad and sometimes a little slow
discussion on fsdevel instead of just rushing in some flag for future
use that won't make any sense in the end.

(and btw, it's Christoph)

