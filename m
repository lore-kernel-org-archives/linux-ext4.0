From: Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH 3/6 -v3] libext2fs: add ext2fs_bitcount() function
Date: Tue, 27 Nov 2012 09:54:23 -0800
Message-ID: <20121127175423.GJ23854@lenny.home.zabbo.net>
References: <1353947981-15219-1-git-send-email-tytso@mit.edu>
 <1353947981-15219-4-git-send-email-tytso@mit.edu>
 <20121126231745.GH23854@lenny.home.zabbo.net>
 <20121127014505.GB25222@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:59419 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868Ab2K0RyX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Nov 2012 12:54:23 -0500
Content-Disposition: inline
In-Reply-To: <20121127014505.GB25222@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 08:45:05PM -0500, Theodore Ts'o wrote:
> build- and run-time machinery (i.e., detecting whether the gcc you're
> compiling with supports __builtin_popcount, and implementing a
> run-time fallback is the CPU doesn't support popcount instruction ---
> which by the way isn't properly part of SSE 4.2; it has its own
> separate CPUID bit, IIRC).

*nod*

> Is there some userspace application licensed under LGPLv2 which does
> this cleanly from which I could borrow code?

Not that I know of, off the top of my head.  I think I'd first check the
usual crypto suspects :).

- z
