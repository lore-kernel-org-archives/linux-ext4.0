From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC][PATCH 0/3] ext4: online defrag (ver 1.0)
Date: Fri, 30 Jan 2009 15:15:18 -0500
Message-ID: <1233346518.9253.44.camel@think.oraclecorp.com>
References: <49829A1D.5090002@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:60634 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZA3UPt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jan 2009 15:15:49 -0500
In-Reply-To: <49829A1D.5090002@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2009-01-30 at 15:11 +0900, Akira Fujita wrote:
> Hi,
> 
> I have rewritten ext4 online defrag patches based on the comments from Ted.
> In the new defrag, create donor inode in the user space instead of kernel space,
> and then allocate contiguous blocks to it with fallocate().
> In kernel space, exchange the blocks between target inode and donor inode,
> and then copy the file data of target inode to donor inode every 64MB.
> The EXT4_IOC_DEFRAG ioctl becomes simpler than the old one,
> so it may be useful for other purposes.
> 

One thing you'll want to handle is swap files.  The swap code uses the
bmap ioctl to make a mapping of extents in the files, and expects that
mapping not to change.  So, defragging a swap file will lead to some
serious problems.

Btrfs is currently getting around this by dropping bmap support, so
swapfiles on btrfs won't work at all.  A real long term solution is
required ;)

For ext4 you should be able to just detect swapfile and disallow the
defrag on it.

-chris


