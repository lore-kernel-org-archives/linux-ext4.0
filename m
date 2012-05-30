From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: e2fsck: fix checks done for mounted vs. read-only
Date: Wed, 30 May 2012 11:57:15 -0600
Message-ID: <7F0A3486-878A-4E71-8C14-EAFDAD2FA8E4@whamcloud.com>
References: <1337895296-16629-1-git-send-email-adilger@whamcloud.com> <20120528145100.GA21422@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:15816 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab2E3R5M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 May 2012 13:57:12 -0400
In-Reply-To: <20120528145100.GA21422@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-28, at 8:51 AM, Ted Ts'o wrote:
> On Thu, May 24, 2012 at 11:34:56AM -0000, Andreas Dilger wrote:
>> Currently, if e2fsck is run without the "-n" flag (i.e. it
>> might modify the filesystem), there is no guarantee that it will
>> open the filesystem with the EXCLUSIVE flag (i.e. O_EXCL) to
>> prevent the block device from being checked (in most cases this
>> means mounted, but it could also be an MD/LVM member device).
>> 
>> Conversely, if e2fsck is run with "-n" (i.e. read-only), and
>> /etc/mtab or /proc/mounts does not report the block device as
>> mounted then e2fsck thinks the filesystem is unmounted.  In this
>> case, e2fsck incorrectly sets the EXCLUSIVE flag, which causes
>> the check to fail, even though e2fsck is running read-only.
>> 
>> To fix this, do not open with EXCLUSIVE if it is a read-only check,
>> and always open with EXCLUSIVE if the filesystem might be changed.
>> This also prevents filesystem mounts while e2fsck is running.
>> 
>> Also refuse allow e2fsck to run at all if the filesystem is BUSY.
>> The e2fsck check_mount() was checking for MOUNTED, but not BUSY,
>> and it should refuse to run outright if the block device is BUSY.
>> The previous MOUNTED heuristics pre-date the O_EXCL reservation
>> by the kernel, so there could be uncertainty due to stale /etc/mtab
>> data, but with newer kernels a busy device should never be modified.
>> 
>> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> 
> Thanks, applied.

In late-breaking news, this change prevents checking the root
filesystem at mount time, because the device is BUSY, and all
filesystem-modifying checks use O_EXCL...

This was not a problem with our original patch, but I had changed
it in discussion with Eric to prevent people from shooting
themselves in the foot when bypassing "The filesystem is mounted.
Do you really want to continue (y/n)?" questions and corrupting
their filesystem.  The revised patch tested correctly on mounted
and unmounted regular filesystems, but breaks for the root fs.

Please revert this patch, and I'll come up with a better one.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




