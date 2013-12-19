From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Thu, 19 Dec 2013 10:12:02 -0700
Message-ID: <20131219171201.GD19166@parisc-linux.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com> <20131217223050.GB20579@dastard> <20131218023143.GA24491@parisc-linux.org> <20131218050127.GA15289@thunk.org> <20131218142749.GA9207@parisc-linux.org> <20131219020759.GA27469@thunk.org> <20131219041240.GA19166@parisc-linux.org> <20131219054303.GA4391@thunk.org> <20131219152049.GB19166@parisc-linux.org> <20131219161728.GA9130@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37170 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3LSRMF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Dec 2013 12:12:05 -0500
Content-Disposition: inline
In-Reply-To: <20131219161728.GA9130@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 11:17:28AM -0500, Theodore Ts'o wrote:
> On Thu, Dec 19, 2013 at 08:20:49AM -0700, Matthew Wilcox wrote:
> > We could have ext4_get_xip_mem() check buffer_unwritten(); if it's set,
> > zero the blocks and call ext4_convert_unwritten_extents().  Would that
> > work?
> 
> That would work, but we'd be doing a double write to each data block
> --- first writing all zero's, and then later, writing the actual data.
> So this would halve our write bandwidth, and double the write wear on
> the device.

Once this patch is done that I'm working on in the other thread, the
only place we'll be calling get_xip_mem() is in the page fault path,
which always has to zero no matter whether it's a load or a store.

As I said in my last reply to Dave:

  At this point, I'm thinking a
  custom ->fault handler that looks something like this:

  static int ext4_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
  {
          return xip_fault(vma, vmf, ext4_get_block_write, ext4_end_io_dio);
  }

... I think it'll actually be ext4_get_block_fault, not _write, and it
will include code to zero the returned blocks if they're uninitialised.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
