From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Wed, 18 Dec 2013 21:12:41 -0700
Message-ID: <20131219041240.GA19166@parisc-linux.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com> <20131217223050.GB20579@dastard> <20131218023143.GA24491@parisc-linux.org> <20131218050127.GA15289@thunk.org> <20131218142749.GA9207@parisc-linux.org> <20131219020759.GA27469@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52019 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3LSEMn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Dec 2013 23:12:43 -0500
Content-Disposition: inline
In-Reply-To: <20131219020759.GA27469@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 18, 2013 at 09:07:59PM -0500, Theodore Ts'o wrote:
> On Wed, Dec 18, 2013 at 07:27:49AM -0700, Matthew Wilcox wrote:
> > 
> > I think there is a callback in xip_file_write(), and it's get_xip_mem().
> > From what you're saying, it sounds like it's just not doing enough.
> 
> The problem is that git_xip_mem() is called before we write to the
> memory, right?
> 
> We need to convert the uninit extents to be marked as initialized in
> *after* the write has been sent to the storage medium.

Now that I've spent the best part of a day looking at the ext4 code, I
still don't think there's a problem here.  With the way the XIP code is
currently written (calling ext4_get_block with create=1), we won't get an
uninitialised extent in the caller.  Instead, we'll get one that's been
zeroed (the zeroing is part of patch 3/3 and done only for xip files).

As I understand it, when ext4 uses direct I/O, it can pass
ext4_get_block_write() as the get_block method, which uses the
magic EXT4_GET_BLOCKS_IO_CREATE_EXT flag to permit the allocation of
uninitialised extents.  But the regular ext4_get_block cannot create
uninitialised extents (it can return them in the case of create=0,
and we handle that correctly as a hole).

Moreover, I don't see, eg, block_read_full_page() handling uninitialised
extents specially, so I'm pretty sure the regular ext4_get_block()
can't create uninitialised extents.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
