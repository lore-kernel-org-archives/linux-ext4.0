From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Thu, 19 Dec 2013 15:37:56 +1100
Message-ID: <20131219043756.GY31386@dastard>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
 <20131217223050.GB20579@dastard>
 <20131218023143.GA24491@parisc-linux.org>
 <20131218050127.GA15289@thunk.org>
 <20131218142749.GA9207@parisc-linux.org>
 <20131219020759.GA27469@thunk.org>
 <20131219041240.GA19166@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10113 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab3LSEiA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Dec 2013 23:38:00 -0500
Content-Disposition: inline
In-Reply-To: <20131219041240.GA19166@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 18, 2013 at 09:12:41PM -0700, Matthew Wilcox wrote:
> On Wed, Dec 18, 2013 at 09:07:59PM -0500, Theodore Ts'o wrote:
> > On Wed, Dec 18, 2013 at 07:27:49AM -0700, Matthew Wilcox wrote:
> > > 
> > > I think there is a callback in xip_file_write(), and it's get_xip_mem().
> > > From what you're saying, it sounds like it's just not doing enough.
> > 
> > The problem is that git_xip_mem() is called before we write to the
> > memory, right?
> > 
> > We need to convert the uninit extents to be marked as initialized in
> > *after* the write has been sent to the storage medium.
> 
> Now that I've spent the best part of a day looking at the ext4 code, I
> still don't think there's a problem here.  With the way the XIP code is
> currently written (calling ext4_get_block with create=1), we won't get an
> uninitialised extent in the caller.  Instead, we'll get one that's been
> zeroed (the zeroing is part of patch 3/3 and done only for xip files).

You will with XFS. And you will when an application uses fallocate()
to allocate the space before the write(2) call. So it's irrelevant
what the write call does - the generic infrastructure needs to
handle the fact that it can be writing into an unwritten region and
be required to call a filesystem specific IO completion handler to
deal with it.

> As I understand it, when ext4 uses direct I/O, it can pass
> ext4_get_block_write() as the get_block method, which uses the
> magic EXT4_GET_BLOCKS_IO_CREATE_EXT flag to permit the allocation of
> uninitialised extents.  But the regular ext4_get_block cannot create
> uninitialised extents (it can return them in the case of create=0,
> and we handle that correctly as a hole).

Stop thinking that ext4 is the entire world. XFS creates unwritten
extents via the direct IO getblock callout when create=1 is set an
dthe write lands in a hole. It then uses the IO completion callout
ot convert them to written extents once the write IO is complete.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
