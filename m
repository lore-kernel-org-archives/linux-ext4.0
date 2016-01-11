From: Dave Chinner <david@fromorbit.com>
Subject: Re: Consolidated file encryption interface/semantics?
Date: Tue, 12 Jan 2016 10:36:20 +1100
Message-ID: <20160111233620.GB6033@dastard>
References: <56943319.9080802@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56943319.9080802@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 11, 2016 at 11:56:25PM +0100, Richard Weinberger wrote:
> Hi!
> 
> I consider adding file encryption to UBIFS.
> While looking into ext4 and f2fs I realized that both
> use the same data structures/concepts.

When the ext4 code was first posted, I noted that 90% of the
implementation was not ext4 specific at all. I asked that the
encryption part of it be lifted to fs/ and the API made generic so
that it can be shared without needing to copy and re-review
encryption code (which is notoriously hard to get right) when others
implement the same fucntionality. This was considered SEP.

> f2fs copy&pasted a lot from ext4.

Yes, they did, even though I asked them not to, but to instead pull
all the code that is non-ext4 specific up to the VFS first and then
use that. Again, this was considered SEP.

> Before I do the next copy&paste, I'd to ask whether it would make sense
> to more parts of the ioctl() interface out to VFS?

Yes, unfortunately you're the first "somebody else" who is going to
have to deal with this problem. It's not just the API - most of the
encryption implementation is also copy and pasted, too.

This simply hasn't got to the top of my list of stuff to do for XFS
yet, so I haven't started down this path yet. However, if you do
start on the hard work  to pull all this stuff up into the VFS and
generic helpers, I'll do what I can to get the necessary parts of
XFS working with it as well....

[snip]

> So, the data structures are identical and AFAIK also the supported cipher modes are.
> But as both use their own ioctls having a single tool to control file encryption
> can be error prone in future.
> Interestingly the current ioctls for ext4 and f2fs resolve to the same integers,
> is this on purpose? :)

Yes, so that when someone factors it all into a generic
implementation the new "FS_IOC*" ioctl API will be binary compatible
with the existing ext4 and f2fs ioctl implementations and the
existing userspace tools will just continue to work.

> Wouldn't it be worthwhile having exactly the same ioctls such that util-linux could offer
> a decent file encryption tool which can be used by all file systems with file encryption
> support?

Yes, it should have been done that way in the first place.

> Another thing are semantics, ext4 implemented a policy which controls
> under which conditions encrypted files are allowed to be unlinked, moved, etc...
> f2fs adopted these from ext4. But can't we do that in VFS or at least
> agree one a policy and document it? :-)

Yes, we should. Having a single set of policies implemented and
enforced at the VFS is how this should be done. Users will
absolutely hate us if per-file encryption devolves into APIs and
policies that differ between filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
