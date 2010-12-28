From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Mon, 27 Dec 2010 21:53:43 -0500
Message-ID: <20101228025343.GD10149@thunk.org>
References: <201012280953.46149.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-usb@vger.kernel.org
To: Con Kolivas <kernel@kolivas.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39518 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab0L1CyH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Dec 2010 21:54:07 -0500
Content-Disposition: inline
In-Reply-To: <201012280953.46149.kernel@kolivas.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 28, 2010 at 09:53:45AM +1100, Con Kolivas wrote:
> 
> Since I moved my internal HD into a USB dock externally and mount the ext4 
> filesystem on it, I regularly get the following errors after it has been 
> mounted for a while (see timecode). It doesn't seem to matter which recent 
> kernel I use. 
> 
> [1048401.773270] EXT4-fs (sde8): mounted filesystem with writeback data mode. 
> Opts: (null)
> [1048702.736011] EXT4-fs (sde8): error count: 3
> [1048702.736016] EXT4-fs (sde8): initial error at 1289053677: 
> ext4_journal_start_sb:251
> [1048702.736018] EXT4-fs (sde8): last error at 1289080948: ext4_put_super:719

That's actually not an error.  It's a report which is generated every
24 hours, indicating that there has been 3 errors since the last time
the error count has been cleared, with the first error taking place at
Sat Nov 6 10:27:57 2010 (US/Eastern) in the function
ext4_journal_start_sb(), at line 251, and the most recent error taking
place at Sat Nov 6 18:02:28 2010 (US/Eastern), in the function
ext4_put_super() at line 719.  This is a new feature which was added
in 2.6.36.

This information (which is stored in the ext4 superblock) gets cleared
by e2fsck version 1.41.13 or newer (1.41.14 is the most recently
released version).  If you are using an older version of e2fsck, this
information won't get cleared, which is not a disaster, although it
could potentially get annoying.  The solution is to simply to upgrade
to the newest version of e2fsprogs if you are using the 2.6.36 or
newer kernel.

The idea behind this feature is to make sure that if there was a file
system corruption detected, it wouldn't be lost due to log files
getting overflowed.  It's also helpful when users report problems to
distribution support lines, since it makes it more likely support
personnel will be able to determine that there has been some file
system corrutpion issues, perhaps caused by hardware problems, or some
other cause, including kernel bugs.

Hope this helps explain what you're seeing!

						- Ted
