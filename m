From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Thu, 19 Dec 2013 11:17:28 -0500
Message-ID: <20131219161728.GA9130@thunk.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
 <20131217223050.GB20579@dastard>
 <20131218023143.GA24491@parisc-linux.org>
 <20131218050127.GA15289@thunk.org>
 <20131218142749.GA9207@parisc-linux.org>
 <20131219020759.GA27469@thunk.org>
 <20131219041240.GA19166@parisc-linux.org>
 <20131219054303.GA4391@thunk.org>
 <20131219152049.GB19166@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41729 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab3LSQRi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Dec 2013 11:17:38 -0500
Content-Disposition: inline
In-Reply-To: <20131219152049.GB19166@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 08:20:49AM -0700, Matthew Wilcox wrote:
> We could have ext4_get_xip_mem() check buffer_unwritten(); if it's set,
> zero the blocks and call ext4_convert_unwritten_extents().  Would that
> work?

That would work, but we'd be doing a double write to each data block
--- first writing all zero's, and then later, writing the actual data.
So this would halve our write bandwidth, and double the write wear on
the device.

And of course, if we did this on the read path, we'd be unnecessarily
doing an extent conversion.

Regards,

						- Ted
