From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 0/3] Fiemap, an extent mapping ioctl
Date: Wed, 10 Sep 2008 10:07:19 -0400
Message-ID: <20080910140719.GQ21071@mit.edu>
References: <20080825202250.GY3392@webber.adilger.int> <20080910124005.GA4563@wotan.suse.de> <20080910124934.GB4563@wotan.suse.de> <20080910134727.GA17498@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48678 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbYIJOHl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2008 10:07:41 -0400
Content-Disposition: inline
In-Reply-To: <20080910134727.GA17498@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2008 at 09:47:27AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 10, 2008 at 05:49:34AM -0700, Mark Fasheh wrote:
> > * FIEMAP_FLAG_XATTR
> > If this flag is set, the extents returned will describe the inodes
> > extended attribute lookup tree, instead of it's data tree.
> 
> So does this actually make sense for any filesystem but XFS?  Still
> seems like a not too useful option for a highlevel generic interface.

Yes, Andreas has submitted a proposed extension which would make this
make sense for ext4.

> > 	__u32	fe_device;   /* device number for extent */
> 
> As sayd before please kill thise one.  It doesn't make any sense at all
> for any merged or near mainline FS.  It'd be an utterly stupid
> lustre-specific hack that still doesn't make much sense.

As a suggestion, how about adding some __u32 and __u64 reserved
fields, some of which are reserved for use by the filesystem (i.e.,
you have to check f_type as returned by statfs to know what can be
used), and some for future generic expansions to the generic FIEMAP
interface.  When designing a userspace interfaces, leaving room in
data structures for future expansion is a good thing, since it can
avoid needing to have multiple versions of an interface when we need
to expand the data structure.

While I can understand not wanting to have any new kernel functions
without any mainline users for that interface, leaving a few reserved
fields in data structures is just a smart thing to do, and has little
or no downsides.

Whether or not we explicitly define bitfields like
FIEMAP_EXTENT_SECONDARY is much less of an issue, since we can always
grab a bit position later without changing the size of the interface.
But if it turns out we want to add something like some way of
identifying which physical device is used by for a particular extent
--- something which btrfs will need, by the way --- not having room in
the data structure will just bite us later.  So why not reserve some
room now?

Interface minimalism to allow for flexibility later is one thing; but
taken to extremes, it it's just stupid.  For example, if we didn't
have any filesystems that needed 64-bit fields in mainline, would that
be a justification for making data structures to use 32-bit fields and
forcing a flag data interface change in the future.  Sometimes we can
look ahead just a little bit and design interfaces which are foward
compatible.  And it's pretty clear that btrfs will need something like
fe_device, although whether it should be a 32-bit index or something
else like a 128-bit UUID admittedly might not be clear at the moment.
But leaving room in the data structure for future growth is just a
intelligent thing to do.

Regards,

					- Ted
