From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]:resize2fs:adjust the inode before inode_tables were
	covered
Date: Sat, 18 Apr 2009 23:21:27 -0400
Message-ID: <20090419032127.GL19186@mit.edu>
References: <49B8C476.1010003@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gui Xiaohua <guixh@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40059 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbZDSDVa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 23:21:30 -0400
Content-Disposition: inline
In-Reply-To: <49B8C476.1010003@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 12, 2009 at 04:14:46PM +0800, Gui Xiaohua wrote:
> Hi Ted
> There is a problem in your patch for resize2fs -M.
> You unmark the inode_table block in new fs,the blocks 
> which needed to be moved will cover the the inode_table
> blocks with its content.In inode_scan_and_fix func, we will
> scan the inode which in the old fs, but the inode table block
> had been coverd,then error occurs.
> I had fixed the problem through adjust the inode before blocks
> be moved.

Hi Gui,

Thanks for pointing out this problem.  It turns out there is an easier
solution, which involves reserving the blocks in the reserved_blocks
bitmap.  This prevents them from being reused, thus avoiding the
problem of old inode table getting overwritten before the inodes have
a chance to be moved.

Your solution has the advantage of not needing to reserve as much
"slop space", but the down side is that if the resize2fs is
interrupted after the inode table is overwritten but before the
directory blocks are updated to point at the new locations of the
inodes on disk, it would be much harder to recover the filesystem
after being interupted at such a bad point.

This problem could be solved by relocating the inodes first, then
updating the directory references, and then doing the block
relocations afterwards, but that would be a much larger change to
resize2fs.  The changes I elected to make, which I have just posted to
linux-ext4, and which you can see here:

    http://article.gmane.org/gmane.comp.file-systems.ext4/12762

... solve the problem in a much smaller set of changes.

    	      	      	   		    - Ted
