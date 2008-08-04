From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problem with delayed allocation
Date: Mon, 4 Aug 2008 08:46:52 +0530
Message-ID: <20080804031652.GA11278@skywalker>
References: <E1KPNNn-0003IN-0B@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:39385 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbYHDDRE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Aug 2008 23:17:04 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m743GbUe014913
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 13:16:37 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m743GxJW4751610
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 13:17:00 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m743Gxi0014318
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 13:16:59 +1000
Content-Disposition: inline
In-Reply-To: <E1KPNNn-0003IN-0B@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 02, 2008 at 04:07:19PM -0400, Theodore Ts'o wrote:
> 
> Apparently __fsync_super(), which is called right before remounting a
> filesystem read-only, isn't working correctly.  To reproduce, create a
> script which does this:
> 
> #!/bin/sh
> DEVICE=/dev/closure/test
> mke2fs -t ext4dev /dev/closure/test
> mount $DEVICE /mnt
> cd /mnt
> tar xfj /var/tmp/linux-2.6.26.tar.gz  <----- or some really big file
> du -s
> cd ..
> mount -o remount,ro /mnt
> sync
> dmesg > /tmp/dmesg.out  <----- note all of the ext4_da_writepages error messages
> umount /mnt
> du -s /mnt
> sync
> mount $DEVICE /mnt
> du -s /mnt    <---  note that size of the unpacked hierarcy is much smaller
> 
> This doesn't happen if the ext4 filesystem is mounted with nodelalloc,
> so I assume the problem is in ext4_da_writepages().
> 
> Aneesh, can you look at this?  I've tried going through the code paths
> starting with __fsync_super(), going down through __sync_single_inode(),
> and I can't see anything obvious.
> 
> I've checked and we've had this problem for a while.  I don't think this
> is a recent regression.  The "sync" command does seem to force file data
> out, but it looks like we're not properly waiting for writes to complete
> before __fsync_super() returns.  There is a call filemap_fdatawait() in
> __sync_single_inode(), but it's apparently not doing the right thing.
> Aneesh, can you try to find whatever it is that I missed?  Thanks!!
> 

__fsync_super use filemap_fdatawait(mapping) for waiting on writeback
pages. But all the dirty pages of the inode are not in writeback because
we might have had block allocation failures. Also with the current code
base I am seeing buffer_heads which are unmapped, non delay and dirty
That means writepages won't allocate block for them and writepage cannot
write them.

-aneesh

