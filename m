From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC][PATCH 4/12] convert some block types in e2fsprogs
Date: Tue, 12 Jun 2007 09:57:57 -0500
Message-ID: <20070612095757.2f1fe23d@gara>
References: <466D7B74.5000207@bull.net>
	<20070611155930.0bbcccbf@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39620 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXFLO61 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jun 2007 10:58:27 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5CEwQo9032522
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 10:58:26 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5CEwQoU546796
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 10:58:26 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5CEwP3d011266
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 10:58:25 -0400
In-Reply-To: <20070611155930.0bbcccbf@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 11 Jun 2007 15:59:30 -0500
"Jose R. Santos" <jrs@us.ibm.com> wrote:

> On Mon, 11 Jun 2007 18:42:28 +0200
> Valerie Clement <valerie.clement@bull.net> wrote:
> 
> > This patch converts some int or unsigned int block number definitions
> > to blk_t type.  Most conversions are necessary for 64-bit porting.
> 
> What about unsigned long?  There are various places where block is
> represented by using unsigned long which is 32-bit when running 32 bit
> binaries. Most PPC64 distributions compile their user-space tools in
> 32-bit binaries.
> 
> I wonder how badly it will break.

I found a PPC64 box to test this out and it seems to break pretty badly
when compiled in the default 32bit mode.  Should ext2_get_device_size()
fail if the number of block is greater than 2**32 and the size of
unsigned long is 4?  At least until it can be verified that this will
work under 32bit binaries since it could corrupt a filesystem to do
an fsck.

mke2fs 1.39-tyt3 (29-Apr-2007)

Warning:Filesystem greater than 2**32 blocks, 64-bit incompatible feature forced.

Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
4194304 inodes, 5 blocks
0 blocks (0.00%) reserved for the super user
First data block=1
524288 block groups
8192 blocks per group, 8192 fragments per group
8 inodes per group
Superblock backups stored on blocks: 
        267387660, 267387660, 267387660, 267387660, 267387660, 267387660, 267387660, 267387660, 267387660, 
        267387660, 267387660, 267387660, 267387660, 267387660, 267387660, 267387660, 
        267387660, 267387660, 267387660, 267387660, 267387660, 267387660, 
        267387660, 267387660, 267387660, 267387660

mke2fs: Could not allocate block in ext2 filesystem while trying to allocate filesystem tables


-JRS
