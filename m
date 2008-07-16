From: Theodore Tso <tytso@mit.edu>
Subject: Re: Add
	ext4__allow_read-only_mounts_with_corrupted_block_group_checksums
	patch
Date: Wed, 16 Jul 2008 09:34:07 -0400
Message-ID: <20080716133407.GT8185@mit.edu>
References: <3.0.6.32.20080715193126.0242c9a0@pop.west.cox.net> <20080716092914.GR6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gary Hawco <ghawco@cox.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35433 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755597AbYGPNeK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 09:34:10 -0400
Content-Disposition: inline
In-Reply-To: <20080716092914.GR6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2008 at 03:29:14AM -0600, Andreas Dilger wrote:
> > Rebooted and e2fsck saw errors and did a forced fsck without having to
> > reboot. All is well thus far.
> 
> You shouldn't really have rebooted at that point, just run e2fsck on
> the filesystem to clear the checksums.

This was the root filesystem so he couldn't have run e2fsck on the
mounted filesystem.

> > Then I did the reverse: tune2fs -O uninit_bg /dev/sda6 to renable uninit_bg
> > feature.  Again, I was prompted to run e2fsck on system.
> 
> Again, you should have just run e2fsck on the filesystem without rebooting,
> in order to update the checksums.

Ditto.

> > I was under the impression that the newest patch would handle this or am I
> > mistaken?
> 
> We probably need to allow the kernel to mount the filesystem read-only in
> this case in order to run e2fsck.

That's what the patch I added in the latest snapshot was supposed to
do.  I admit I haven't had a chance to test it yet, but the code looks
like it should do the right thing.  You are sure that you are mounting
the root filesystem read/only (there is "ro" on the boot command line)
and this is the kernel with this patch applied, right?

							- Ted
