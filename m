From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Tue, 4 Dec 2012 14:24:07 -0500
Message-ID: <20121204192407.GB7790@thunk.org>
References: <50B967E2.7090703@infradead.org>
 <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca>
 <50B990CB.3080607@infradead.org>
 <85A86E8F-EEB9-495C-AB10-EF3C871EE2B9@dilger.ca>
 <50BD017F.1070400@infradead.org>
 <20121204152231.GG29083@thunk.org>
 <50BE36DE.6030300@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36755 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab2LDTYL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 14:24:11 -0500
Content-Disposition: inline
In-Reply-To: <50BE36DE.6030300@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2012 at 09:46:06AM -0800, Darren Hart wrote:
> 
> I think what I'm reading here is that if you care about having a
> filesystem that makes hardware specific optimizations, you're better off
> mounting the device and copying the filesystem over. In that case, plan
> on needing root access.

Well, ext4 currently doesn't optimize for erase block alignment
either.

If I had the free time, and it was something that I could work on on
$DAYJOB time, here are some projects that I've been thinking about:

1) Add support for erase block alignment using the same mechanism
we've been planning for RAID 5 stripe alignment.

2) Add either a superblock flag or a mount option which adds an eMMC
block allocation algorithm which would add support for more aggressive
optimizations.

3) Allow a zero length file to have its extent flag switch to be
turned off (so it would be using the old indirect block scheme).

4) If a file has the extent flag turned off, and the eMMC block
allocation algorithm is enabled, and the workload appears to be doing
random overwrites, implement data block copy-on-write.  (That is,
allocate a new block and then update the indirect block to point to
the new block.)

5) If the eMMC block allocation algorithm is enabled, teach the block
allocator to aggressively allocate contiguous physical blocks
(initially aligned on an erase block) regardless of whether of what
the logical block number is, since with flash seeks are essentially
free, and with indirect blocks we don't care about extent
fragmentation.

The last two are a little bit complicated, but I'm certain we could
implement and stablize it faster than f2fs can be stablized.  (See
previous discussions regarding how confident btrfs people were that
they could stablize it more quickly than all previous experience with
gpfs, jfs, advfs, zfs, etc., because, well, Open Source Is Different.
If anyone at Linaro is interested in trying their hand on some kernel
file system work, they should contact me.  :-)

						- Ted

P.S.  I still think part of the right answer is to investigate replace
sqlite with something like OpenLDAP's mdb --- which has a drop-in
replacement sqlite API shim layer BTW --- and which beats the pants
off of sqlite's performance without requiring kernel-level changes,
but given that people seem wedded to sqlite....
