From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: fsck.ext4 returning false positives
Date: Thu, 28 Feb 2013 09:49:36 -0600
Message-ID: <20130228154936.GG31803@atlantis.cc.ndsu.nodak.edu>
References: <20130227211622.GF31803@atlantis.cc.ndsu.nodak.edu> <20130227214735.GH14253@thunk.org>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atlantis.cc.ndsu.NoDak.edu ([134.129.106.24]:47640 "EHLO
	atlantis.cc.ndsu.nodak.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab3B1Ptm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Feb 2013 10:49:42 -0500
Content-Disposition: inline
In-Reply-To: <20130227214735.GH14253@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 27, 2013 at 04:47:35PM -0500, Theodore Ts'o wrote:
> On Wed, Feb 27, 2013 at 03:16:22PM -0600, Bryan Mesich wrote:

[snip...]

> > e2fsck 1.42.6 (21-Sep-2012)
> > Pass 1: Checking inodes, blocks, and sizes
> > Pass 2: Checking directory structure
> > Pass 3: Checking directory connectivity
> > Pass 4: Checking reference counts
> > Pass 5: Checking group summary information
> > Free blocks count wrong (133413770, counted=133413835).
> > Fix? no
> > 
> > Free inodes count wrong (118244509, counted=118244510).
> > Fix? no
> > 
> > /dev/sanvg2/bbcontent_snap: 2554723/120799232 files (0.5% non-contiguous),
> > 349770870/483184640 blocks
> 
> Yes, these "errors" are not important.  We've changed e2fsprogs to
> suppress these errors when in preen (-p) mode, but in -n or in -y the
> messages are printed.  That's because it's "good" to update the global
> free counts, since some people do assume that the values reported by
> dumpe2fs are accurate, but it's not strictly necessary from the
> kernel's point of view.
> 
> We should probably suppress these errors in -n mode as well.

I think suppressing the "errors" in -n mode would desirable.  It was a
bit confusing having fsck.ext4 return 0 on exit, but indicate errors
were found in the output.  My instinct was to trust the return, but I
wanted to know for sure.  

So, by running fsck with no modes (i.e. fsck.ext4 -f /dev/vg/lv), does 
-p mode get "defaulted" to?  My thinking here is that if so, the errors
I was seeing when running in -n mode would not be present when forcing
fsck to check the origin volume.

If -p mode is not defaulted to, what is causing the free block and inode
counts to be incorrect when checking the snapshot?  My understanding was
that the VFS provides functionality to quiesce a file system, which LVM
takes advantage of when taking a snapshot.  This plus replaying the
journal should leave file system (located on the snap volume) in a
consistent state.

Bryan 

> Regards,
> 
> 					- Ted
