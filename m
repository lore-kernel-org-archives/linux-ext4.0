From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Date: Tue, 4 Apr 2017 14:31:38 -0400
Message-ID: <20170404183138.GC14303@fieldses.org>
References: <20170321163011.GA16666@fieldses.org>
 <1490117004.2542.1.camel@redhat.com>
 <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com>
 <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com>
 <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com>
 <20170330161231.GA9824@fieldses.org>
 <1490898932.2667.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490898932.2667.1.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 30, 2017 at 02:35:32PM -0400, Jeff Layton wrote:
> On Thu, 2017-03-30 at 12:12 -0400, J. Bruce Fields wrote:
> > On Thu, Mar 30, 2017 at 07:11:48AM -0400, Jeff Layton wrote:
> > > On Thu, 2017-03-30 at 08:47 +0200, Jan Kara wrote:
> > > > Because if above is acceptable we could make reported i_version to be a sum
> > > > of "superblock crash counter" and "inode i_version". We increment
> > > > "superblock crash counter" whenever we detect unclean filesystem shutdown.
> > > > That way after a crash we are guaranteed each inode will report new
> > > > i_version (the sum would probably have to look like "superblock crash
> > > > counter" * 65536 + "inode i_version" so that we avoid reusing possible
> > > > i_version numbers we gave away but did not write to disk but still...).
> > > > Thoughts?
> > 
> > How hard is this for filesystems to support?  Do they need an on-disk
> > format change to keep track of the crash counter?  Maybe not, maybe the
> > high bits of the i_version counters are all they need.
> > 
> 
> Yeah, I imagine we'd need a on-disk change for this unless there's
> something already present that we could use in place of a crash counter.

We could consider using the current time instead.  So, put the current
time (or time of last boot, or this inode's ctime, or something) in the
high bits of the change attribute, and keep the low bits as a counter.

Then as long as we trust our clock, we're no longer at risk of reusing
an i_version value.

> > I guess we just want to have some back-of-the-envelope estimates of
> > maximum number of i_version increments possible between crashes and
> > maximum number of crashes possible over lifetime of a filesystem, to
> > decide how to split up the bits.
> > 
> > I wonder if we could get away with using the new crash counter only for
> > *new* values of the i_version?  After a crash, use the on disk i_version
> > as is, and put off using the new crash counter until the next time the
> > file's modified.
> > 
> 
> That sounds difficult to get right. Suppose I have an inode that has not
> been updated in a long time. Someone writes to it and then queries the
> i_version. How do I know whether there were crashes since the last time
> I updated it? Or am I misunderstanding what you're proposing here?

I believe Jan was suggesting that we keep the i_version as-is on disk
but combine with with the crash counter when it's queried.

I was suggesting instead that on write, when we bump the i_version, we
replace the simple increment by something that increments *and* sticks
the current crash counter (or maybe just a time) in the high bits.  And
that combination will be what goes in i_version and is written to disk.

That guarantees that we never reuse an old value when we increment.

It also avoids having to invalidate absolutely every cache, even of
completely static files.

Clients could still see the change attribute go backwards, though, if
they query a file with dirty data and the server crashes before it
writes out the new change attribute.

Also, they could fail to detect data that reverted after boot if they
cache data while the file's dirty on the server side, and the server
crash preserves the i_version update but not the new data.

Presumably both are possible already for ctime (depending on the
filesystem), and I'm not convinced they're a big problem.

In both cases the reading client is caching while somebody's still
writing, and as long as the writer comes back and finishes its job,
readers will thereafter see the right thing.  So I think it's adequate
for close-to-open.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
