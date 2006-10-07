From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Sat, 7 Oct 2006 12:57:44 -0700
Message-ID: <20061007125744.fd5eb3b4.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
	<20061006122105.GA21816@thunk.org>
	<1160169015.8658.50.camel@kleikamp.austin.ibm.com>
	<1160169700.8658.56.camel@kleikamp.austin.ibm.com>
	<20061006153219.d5b62ee8.akpm@osdl.org>
	<1160176800.8658.70.camel@kleikamp.austin.ibm.com>
	<20061007041439.GA5478@thunk.org>
	<1160236427.14217.14.camel@kleikamp.austin.ibm.com>
	<20061007172027.GB5478@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60349 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932795AbWJGT6L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Oct 2006 15:58:11 -0400
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061007172027.GB5478@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 7 Oct 2006 13:20:27 -0400
Theodore Tso <tytso@mit.edu> wrote:

> > Also, do we update the superblock in every transaction that creates or
> > deletes a file?  Otherwise, how do we guarantee the count is accurate
> > after replaying the journal?
> 
> Yes, we do.  The number of free inodes has to be kept up-to-date,
> after all, so the superblock is marked dirty and as being part of the
> transaction.

Actually we cheat, and we don't keep the superblock free inodes counter up
to date in real time.  Done for CPU consumptions reasons, but it was
perhaps a false optimisation, given that we still have a system-wide
inode_lock.

The free inode count is already triply redundant: inode table scan, inode
bitmap scan, ext4_group_desc.bg_free_inodes_count.  Making it quadruply
redundant seemed a bit over the top.

At runtime the definitive free-inodes count is the sum of the
per-blockgroup free-inode counts.  On clean shutdown we regenerate that and
write it into the superblock.
