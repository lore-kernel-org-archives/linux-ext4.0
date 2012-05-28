From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2fsck: fix checks done for mounted vs. read-only
Date: Mon, 28 May 2012 10:51:00 -0400
Message-ID: <20120528145100.GA21422@thunk.org>
References: <1337895296-16629-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45972 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2E1OvC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 10:51:02 -0400
Content-Disposition: inline
In-Reply-To: <1337895296-16629-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 24, 2012 at 11:34:56AM -0000, Andreas Dilger wrote:
> Currently, if e2fsck is run without the "-n" flag (i.e. it
> might modify the filesystem), there is no guarantee that it will
> open the filesystem with the EXCLUSIVE flag (i.e. O_EXCL) to
> prevent the block device from being checked (in most cases this
> means mounted, but it could also be an MD/LVM member device).
> 
> Conversely, if e2fsck is run with "-n" (i.e. read-only), and
> /etc/mtab or /proc/mounts does not report the block device as
> mounted then e2fsck thinks the filesystem is unmounted.  In this
> case, e2fsck incorrectly sets the EXCLUSIVE flag, which causes
> the check to fail, even though e2fsck is running read-only.
> 
> To fix this, do not open with EXCLUSIVE if it is a read-only check,
> and always open with EXCLUSIVE if the filesystem might be changed.
> This also prevents filesystem mounts while e2fsck is running.
> 
> Also refuse allow e2fsck to run at all if the filesystem is BUSY.
> The e2fsck check_mount() was checking for MOUNTED, but not BUSY,
> and it should refuse to run outright if the block device is BUSY.
> The previous MOUNTED heuristics pre-date the O_EXCL reservation
> by the kernel, so there could be uncertainty due to stale /etc/mtab
> data, but with newer kernels a busy device should never be modified.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Thanks, applied.

						- Ted
