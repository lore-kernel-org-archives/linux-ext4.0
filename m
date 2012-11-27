From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6 -v3] libext2fs: add ext2fs_bitcount() function
Date: Mon, 26 Nov 2012 20:45:05 -0500
Message-ID: <20121127014505.GB25222@thunk.org>
References: <1353947981-15219-1-git-send-email-tytso@mit.edu>
 <1353947981-15219-4-git-send-email-tytso@mit.edu>
 <20121126231745.GH23854@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Zach Brown <zab@zabbo.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34986 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805Ab2K0BpH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 20:45:07 -0500
Content-Disposition: inline
In-Reply-To: <20121126231745.GH23854@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 03:17:45PM -0800, Zach Brown wrote:
> > This function efficiently counts the number of bits in a block of
> > memory.
> 
> Would it be worth the annoying build- and run-time machinery to detect
> and use the -msse4.2 __builtin_popcount() gcc intrinsic?

I thought about doing it, but I was in a bit of a hurry implementing
this patch set, and I wasn't even sure how to correctly implement the
build- and run-time machinery (i.e., detecting whether the gcc you're
compiling with supports __builtin_popcount, and implementing a
run-time fallback is the CPU doesn't support popcount instruction ---
which by the way isn't properly part of SSE 4.2; it has its own
separate CPUID bit, IIRC).  Is there some userspace application
licensed under LGPLv2 which does this cleanly from which I could
borrow code?

I suppose I should first check and see how much difference it makes to
with a hard-coded use __builtin_popcnt().  If it makes a sufficiently
large improvement, it's probably worth the hair of implementing the
fallback machinery.

							- Ted
