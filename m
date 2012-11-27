From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6 -v3] libext2fs: add ext2fs_bitcount() function
Date: Tue, 27 Nov 2012 00:16:17 -0500
Message-ID: <20121127051617.GA7080@thunk.org>
References: <1353947981-15219-1-git-send-email-tytso@mit.edu>
 <1353947981-15219-4-git-send-email-tytso@mit.edu>
 <20121126231745.GH23854@lenny.home.zabbo.net>
 <20121127014505.GB25222@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Zach Brown <zab@zabbo.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35005 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2K0FQU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Nov 2012 00:16:20 -0500
Content-Disposition: inline
In-Reply-To: <20121127014505.GB25222@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 08:45:05PM -0500, Theodore Ts'o wrote:
> I suppose I should first check and see how much difference it makes to
> with a hard-coded use __builtin_popcnt().  If it makes a sufficiently
> large improvement, it's probably worth the hair of implementing the
> fallback machinery.

I did some quick benchmarking, and the difference it makes when
checking 4TB's worth of bitmaps is negligble:

slow popcount: 0.2623
fast popcount: 0.0700

For a 128TB's worth of bitmaps, the time difference is:

slow popcount: 8.0185
fast popcount: 2.2066

I measured running e2fsck on an empty 128TB file system, and that took
202 CPU seconds (assuming all of the fs metadata blocks are in cache),
so with this optimization we would save at most 3%.  (For comparison,
using an unmodified 1.42.6 e2fsck, it burned 392.7 CPU seconds.)

My conclusion is that using __builtin_popcnt() is a nice-to-have, and
if someone sends me patches I'll probably take them as a optimization,
but it's not super high priority for me.

							- Ted
