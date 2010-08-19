From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Thu, 19 Aug 2010 13:16:20 -0400
Message-ID: <20100819171620.GB3468@thunk.org>
References: <20100818140422.GL27457@skl-net.de>
 <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca>
 <20100819005404.GO21182@thunk.org>
 <20100819131017.GV16603@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38220 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab0HSRQX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Aug 2010 13:16:23 -0400
Content-Disposition: inline
In-Reply-To: <20100819131017.GV16603@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 19, 2010 at 03:10:17PM +0200, Andre Noll wrote:
> Silly question: Would it be possible to simply mmap a large enough
> file for the data and and use e.g. rbtrees for the lookups? If yes,
> osl [1] could probably be an option. It's very simple but likely too
> slow on inserts to be useful for e2fsprogs.

As I recall, you're on a 32-bit machine, right?  If so, a limitation
you may run into is simply running out of address space.  If it's not
an address space issue, we don't need to mmap anything; you could just
try enabling swap, and use the existing e2fsck code.

(I had assumed you had tried that before suggesting you use the
scratch_files tdb approach....)

					- Ted
