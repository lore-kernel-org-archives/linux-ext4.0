From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 0/3] Fiemap, an extent mapping ioctl
Date: Wed, 10 Sep 2008 09:10:37 -0700
Message-ID: <20080910161037.GH4563@wotan.suse.de>
References: <20080825202250.GY3392@webber.adilger.int> <20080910124005.GA4563@wotan.suse.de> <20080910124934.GB4563@wotan.suse.de> <20080910134727.GA17498@infradead.org>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:39892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYIJQKj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2008 12:10:39 -0400
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
> 
> > 	__u32	fe_device;   /* device number for extent */
> 
> As sayd before please kill thise one.  It doesn't make any sense at all
> for any merged or near mainline FS.  It'd be an utterly stupid
> lustre-specific hack that still doesn't make much sense.
> 
> > * FIEMAP_EXTENT_NO_BYPASS
> > Direct access to the data in this extent is illegal or will have
> > undefined results.
> 
> Huh?  What is direct access?  Direct access as in bypassing the
> filesystem and writing to the blockdev directly always has undefined
> results.
> 
> > * FIEMAP_EXTENT_SECONDARY
> > The data for this extent is in secondary storage (e.g. HSM).  If the
> > data is not also in the filesystem, then FIEMAP_EXTENT_NO_BYPASS
> > should also be set.
> 
> No HSM in mainline, so please drop it.  We can add it once we get HSM
> support.
> 
> > * FIEMAP_EXTENT_NET
> >   - This will also set FIEMAP_EXTENT_NO_BYPASS
> > The data for this extent is not stored in a locally-accessible device.
> 
> Doesn't make any sense currently, please drop.
> 
> > * FIEMAP_EXTENT_DATA_COMPRESSED
> >   - This will also set FIEMAP_EXTENT_NO_BYPASS
> > The data in this extent has been compressed by the file system.
> 
> Add once we have users for it.

Ok, aside from NO_BYPASS all your proposed changes have been made. Not sure
about NO_BYPASS. Maybe we just update the description? In the meantime, can
we please just put this in -mm? I'll happily do a patch on top of it all to
rename EXTENT_NO_BYPASS once we agree on a name.

Please pull
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git fiemap
	--Mark

--
Mark Fasheh
