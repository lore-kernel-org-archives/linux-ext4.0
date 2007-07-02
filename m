From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: fallocate support for bitmap-based files
Date: Mon, 02 Jul 2007 10:44:54 -0400
Message-ID: <1183387495.3864.24.camel@localhost.localdomain>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org>
	 <1183212800.9505.12.camel@localhost.localdomain>
	 <20070630172921.GB5159@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Mike Waychison <mikew@google.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35588 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbXGBRoy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2007 13:44:54 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l62GfRLm006705
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jul 2007 12:41:27 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l62HisVs556726
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jul 2007 13:44:54 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l62Hiru0009184
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jul 2007 13:44:53 -0400
In-Reply-To: <20070630172921.GB5159@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-06-30 at 13:29 -0400, Andreas Dilger wrote:
> On Jun 30, 2007  10:13 -0400, Mingming Cao wrote:
> > Another approach we have been thinking  is using a backing
> > inode(per-inode-with-preallocation) to store the preallocated blocks.
> > When user asked for preallocation on the base inode, ext2/3 create a
> > temporary backing inode, and it's (pre)allocate the corresponding
> > blocks in the backing inode. 
> > 
> > When writes to the base inode, and realize we need to block allocation
> > on, before doing the fs real block allocation, it will check if the file
> > has a backing inode stores some preallocated blocks for the same logical
> > blocks.  If so, it will transfer the preallocated blocks from backing
> > inode to the base inode.
> > 
> > We need to link the two inodes in some way, maybe store the backing
> > inode number via EA in the base inode, and flag the base inode that it
> > has a backing inode to get preallocated blocks.
> > 
> > Since it doesn't change the block mapping on the original file until
> > writeout, so it doesn't require a incompat feature to protect the
> > preallocated contents to be read in "old" kernel. There some work need
> > to be done in e2fsck to understand the backing inode.
> 
> I don't know if you realize, but this is half-way to supporting
> snapshots within the filesystem.  

>From your description it seems similar, but not sure if it's half-way
yet. Just to clarify: What's stored in the backing inode(in the
preallocation case) is just metablocks, not data blocks. The transfer
(from backing inode to the base inode) do not involve any data blocks
migration.

Another comment, if we seriously looking for supporting preallocation in
ext2 in upstreeam, I'd like to choose a solution suitable for ext3 as
well. Taking a bit from block number to flag preallocated blocks means
reduce ext2/3 fs limit to 8TB, which probably not a big deal for ext2,
but not so good for ext3.

Mingming
