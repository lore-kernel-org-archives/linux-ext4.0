From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Thu, 19 Dec 2013 12:18:48 -0500
Message-ID: <20131219171848.GC9130@thunk.org>
References: <20131217223050.GB20579@dastard>
 <20131218023143.GA24491@parisc-linux.org>
 <20131218050127.GA15289@thunk.org>
 <20131218142749.GA9207@parisc-linux.org>
 <20131219020759.GA27469@thunk.org>
 <20131219041240.GA19166@parisc-linux.org>
 <20131219054303.GA4391@thunk.org>
 <20131219152049.GB19166@parisc-linux.org>
 <20131219161728.GA9130@thunk.org>
 <20131219171201.GD19166@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41746 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab3LSRSy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Dec 2013 12:18:54 -0500
Content-Disposition: inline
In-Reply-To: <20131219171201.GD19166@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 10:12:02AM -0700, Matthew Wilcox wrote:
> 
> ... I think it'll actually be ext4_get_block_fault, not _write, and it
> will include code to zero the returned blocks if they're uninitialised.

I assume what you mean here is if we see that the blocks are
uninitialized, we don't need to read from the persistent memory at
all; we can just map in a zeroed page, hopefully one from our stock of
pre-zeroed pages.  Yes?

						- Ted
