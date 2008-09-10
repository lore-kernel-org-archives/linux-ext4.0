From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Fiemap, an extent mapping ioctl
Date: Wed, 10 Sep 2008 10:11:02 -0400
Message-ID: <20080910141102.GA22654@infradead.org>
References: <20080825202250.GY3392@webber.adilger.int> <20080910124005.GA4563@wotan.suse.de> <20080910124934.GB4563@wotan.suse.de> <20080910134727.GA17498@infradead.org> <20080910140719.GQ21071@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55080 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYIJOLU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 10:11:20 -0400
Content-Disposition: inline
In-Reply-To: <20080910140719.GQ21071@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2008 at 10:07:19AM -0400, Theodore Tso wrote:
> As a suggestion, how about adding some __u32 and __u64 reserved
> fields, some of which are reserved for use by the filesystem (i.e.,
> you have to check f_type as returned by statfs to know what can be
> used), and some for future generic expansions to the generic FIEMAP
> interface.  When designing a userspace interfaces, leaving room in
> data structures for future expansion is a good thing, since it can
> avoid needing to have multiple versions of an interface when we need
> to expand the data structure.
> 
> While I can understand not wanting to have any new kernel functions
> without any mainline users for that interface, leaving a few reserved
> fields in data structures is just a smart thing to do, and has little
> or no downsides.

Leaving some spare space in the structure is fine with me, although I
doubt we'll ever use it for a scheme like that, more like other things.

> Interface minimalism to allow for flexibility later is one thing; but
> taken to extremes, it it's just stupid.  For example, if we didn't
> have any filesystems that needed 64-bit fields in mainline, would that
> be a justification for making data structures to use 32-bit fields and
> forcing a flag data interface change in the future.  Sometimes we can
> look ahead just a little bit and design interfaces which are foward
> compatible.  And it's pretty clear that btrfs will need something like
> fe_device, although whether it should be a 32-bit index or something
> else like a 128-bit UUID admittedly might not be clear at the moment.
> But leaving room in the data structure for future growth is just a
> intelligent thing to do.

No, if you look at btrfs or the not public bit for mirrored allocations
groups in XFS you'll notice that an extent can be happily on more than
once device.  So to support this we'd need a list of device plus a field
for the algorithm how to balance it over the devices.

