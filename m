From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fsck.ext4 returning false positives
Date: Wed, 27 Feb 2013 16:47:35 -0500
Message-ID: <20130227214735.GH14253@thunk.org>
References: <20130227211622.GF31803@atlantis.cc.ndsu.nodak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50437 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab3B0Vri (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2013 16:47:38 -0500
Content-Disposition: inline
In-Reply-To: <20130227211622.GF31803@atlantis.cc.ndsu.nodak.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 27, 2013 at 03:16:22PM -0600, Bryan Mesich wrote:
> I migrated the file system to ext4 in December 2012 by copying the files
> from the old file system to the new one (I didn't go the "upgrade" route).
> I continued performing the weekly file system checks after migrating to
> ext4 and starting seeing strange behavior when running fsck on a snapshot
> volume.  Here is the output from this mornings fsck:
> 
> e2fsck 1.42.6 (21-Sep-2012)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong (133413770, counted=133413835).
> Fix? no
> 
> Free inodes count wrong (118244509, counted=118244510).
> Fix? no
> 
> /dev/sanvg2/bbcontent_snap: 2554723/120799232 files (0.5% non-contiguous),
> 349770870/483184640 blocks

Yes, these "errors" are not important.  We've changed e2fsprogs to
suppress these errors when in preen (-p) mode, but in -n or in -y the
messages are printed.  That's because it's "good" to update the global
free counts, since some people do assume that the values reported by
dumpe2fs are accurate, but it's not strictly necessary from the
kernel's point of view.

We should probably suppress these errors in -n mode as well.

Regards,

					- Ted
