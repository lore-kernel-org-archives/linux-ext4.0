From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsck shouln't consider superblock summaries as fatal
Date: Tue, 26 Aug 2008 15:27:43 -0600
Message-ID: <20080826212743.GP3392@webber.adilger.int>
References: <20080826104502.GH3392@webber.adilger.int>
 <20080826170420.GE8720@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46899 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYHZV16 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 17:27:58 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7QLRuee013391
	for <linux-ext4@vger.kernel.org>; Tue, 26 Aug 2008 14:27:57 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K680000188PEZ00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 26 Aug 2008 14:27:56 -0700 (PDT)
In-reply-to: <20080826170420.GE8720@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 26, 2008  13:04 -0400, Theodore Ts'o wrote:
> On Tue, Aug 26, 2008 at 04:45:02AM -0600, Andreas Dilger wrote:
> > Running e2fsck on a quiescent (but mounted) filesystem fails in the
> > common case where the superblock inode and block count summaries are
> > wrong.  The kernel doesn't update these values except at unmount time.
> > If there are other errors in the filesystem then they will already
> > cause e2fsck to consider the filesystem invalid, so these minor errors
> > should not.
> 
> Sure, but *when* would it ever be safe to run e2fsck without -n on a
> mounted filesystem?  What's the scenario where this would matter?  And
> on an unmounted filesystem, if the block counts are wrong, and the
> user refuses to fix them the filesystem technically really isn't 100%
> valid.

I mean that this is for "e2fsck -fn".  In that case the filesystem isn't
changed, and is often completely clean except the superblock counters.
Until we have block-device freeze ioctl widely available (or convince
users to use LVM), the best we can do is quiesce Lustre IO without
unmounting the filesystem.


Without patch:

# e2fsck -fn /dev/hda3
e2fsck 1.40.7.sun1 (28-Feb-2008)
Warning!  /dev/hda3 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (213908, counted=213298).
Fix? no

Free inodes count wrong (249992, counted=249282).
Fix? no

lustre-MDT0000: ********** WARNING: Filesystem still has errors **********

lustre-MDT0000: 56/250048 files (17.9% non-contiguous), 36092/250000 blocks

# echo $?
4

With patch:

# e2fsck -fn /dev/hda3
e2fsck 1.40.11.sun1 (17-June-2008)
Warning!  /dev/hda3 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (213908, counted=213298).
Fix? no

Free inodes count wrong (249992, counted=249282).
Fix? no

lustre-MDT0000: 56/250048 files (17.9% non-contiguous), 36092/250000 blocks
# echo $?
0

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

