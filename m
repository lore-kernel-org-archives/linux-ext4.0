From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/3] bdi: Track users that require stable page writes
Date: Fri, 2 Nov 2012 00:15:30 +0100
Message-ID: <20121101231530.GC31937@quack.suse.cz>
References: <20121101075805.16153.64714.stgit@blackbox.djwong.org>
 <20121101075813.16153.94581.stgit@blackbox.djwong.org>
 <5092BDA2.6090001@panasas.com>
 <20121101185756.GI19591@blackbox.djwong.org>
 <5092FE22.30906@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
	lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org,
	ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mfasheh-IBi9RG/b67k@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org,
	martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5092FE22.30906-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu 01-11-12 15:56:34, Boaz Harrosh wrote:
> On 11/01/2012 11:57 AM, Darrick J. Wong wrote:
> > On Thu, Nov 01, 2012 at 11:21:22AM -0700, Boaz Harrosh wrote:
> >> On 11/01/2012 12:58 AM, Darrick J. Wong wrote:
> >>> This creates a per-backing-device counter that tracks the number of users which
> >>> require pages to be held immutable during writeout.  Eventually it will be used
> >>> to waive wait_for_page_writeback() if nobody requires stable pages.
> >>>
> >>
> >> There is two things I do not like:
> >> 1. Please remind me why we need the users counter?
> >>    If the device needs it, it will always be needed. The below 
> >>    queue_unrequire_stable_pages call at blk_integrity_unregister
> >>    only happens at device destruction time, no?
> >>
> >>    It was also said that maybe individual filesystems would need
> >>    stable pages where other FSs using the same BDI do not. But
> >>    since the FS is at the driving seat in any case, it can just
> >>    do wait_for_writeback() regardless and can care less about
> >>    the bdi flag and the other FSs. Actually all those FSs already
> >>    do this this, and do not need any help. So this reason is
> >>    mute.
> > 
> > The counter exists so that a filesystem can forcibly enable stable page writes
> > even if the underlying device doesn't require it, because the generic fs/mm
> > waiting only happens if stable_pages_required=1.  The idea here was to allow a
> > filesystem that needs stable page writes for its own purposes (i.e. data block
> > checksumming) to be able to enforce the requirement even if the disk doesn't
> > care (or doesn't exist).
> > 
> 
> But the filesystem does not need BDI flag to do that, It can just call
> wait_on_page_writeback() directly and or any other waiting like cifs does,
> and this way will not affect any other partitions of the same BDI. So this flag
> is never needed by the FS, it is always to service the device.
  But if they use some generic VFS functions, these VFS functions need to
know whether to wait or not - e.g. grab_cache_page_write_begin() or
block_page_mkwrite().

> > But maybe there are no such filesystems?
> > 
> 
> Exactly, all the FSs that do care, already take care of it.
  I'm not exactly sure whether FSs that do care didn't start to use generic
functions which now always call wait_on_page_writeback() for quite a few
releases...

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
