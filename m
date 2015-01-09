From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 wrote extents on ext2 fs?
Date: Fri, 9 Jan 2015 18:30:09 -0500
Message-ID: <20150109233009.GB31554@thunk.org>
References: <1420841908.7511.1.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Johannes Berg <johannes@sipsolutions.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33288 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbbAIXaO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jan 2015 18:30:14 -0500
Content-Disposition: inline
In-Reply-To: <1420841908.7511.1.camel@sipsolutions.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 09, 2015 at 11:18:28PM +0100, Johannes Berg wrote:
> Hi,
> 
> I'm running - on an oldish kernel 3.14.26 - an ext2 filesystem with the
> ext4 module, on a 1GB USB pendrive. Today the system failed to come up
> properly (it's a small router providing my internet connectivity) and
> this is what e2fsck had to say about the filesystem:
> 
> # e2fsck /dev/sdb1 
> e2fsck 1.42.12 (29-Aug-2014)
> extroot contains a file system with errors, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Inode 15817 has EXTENTS_FL flag set on filesystem without extents support.
> Clear<y>? yes
> Inode 15818 has EXTENTS_FL flag set on filesystem without extents support.
> Clear<y>? yes
> Inode 15819 has EXTENTS_FL flag set on filesystem without extents support.
> Clear<y>? yes
> Inode 15820 has EXTENTS_FL flag set on filesystem without extents support.
> Clear<y>? yes
> Inode 15821 has EXTENTS_FL flag set on filesystem without extents support.
> Clear<y>? yes
> Inode 15822 has EXTENTS_FL flag set on filesystem without extents support.
> Clear<y>? yes
> Inode 15823 has EXTENTS_FL flag set on filesystem without extents support.
> Clear<y>? yes
> Inode 15824 has EXTENTS_FL flag set on filesystem without extents support.
> Clear<y>? yes
> 
> As you can see, the inodes that somehow ended up with extents were
> deleted in the process of this - perhaps this shouldn't actually have
> been a problem for ext4 reading the filesystem? However, based on the
> symptoms of the device failure I reckon that the contents of those files
> was corrupted.

What I suspect happened is that some kind of garbage --- perhaps
simply a single 4k block of 0xFF's --- got written into the inode
table.  This would trigger this sort of complaint from e2fsck.

> Perhaps this is just a consequence of check ordering though - maybe if
> the inode flags get corrupted then the EXTENTS flag is just the first
> one that will be tested in the e2fsck code?

Yes, this is one of the first things that e2fsck 1.42.x would test
for.

						- Ted
