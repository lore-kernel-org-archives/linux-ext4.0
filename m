From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recover files from a broken ext3 partition
Date: Mon, 16 Dec 2013 09:59:20 -0500
Message-ID: <20131216145920.GA6991@thunk.org>
References: <52AF1253.1000608@public.noschinski.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lars Noschinski <lars@public.noschinski.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40631 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab3LPO7Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Dec 2013 09:59:24 -0500
Content-Disposition: inline
In-Reply-To: <52AF1253.1000608@public.noschinski.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 16, 2013 at 03:46:43PM +0100, Lars Noschinski wrote:
> I have got a hard disk which was damaged by a fall and would like to
> recover a few files from that. (There is a backup for most of the
> data, but a handful of recent files are missing. These are important
> enough to spend some time on them, but not for paying a professional
> data recovery service).
> 
> Using GNU ddrescue I was able to read 99.8% of an ext3(or 4?)
> partition, so there's hope the data is still there. Unfortunately,
> some key parts of the file system seem to be damaged, so e2fsck fails:
> 
> - ------------------------------
> % ddrescuelog -l- -b4096 sdd5.ddrescue.log > badblocks.sdd5.4096
> % e2fsck -b 20480000 -v -f -L badblocks.sdd5.4096 sdd5
> [...]
> Pass 1: Checking inodes, blocks, and sizes
> Block 1 in the primary group descriptors is on the bad block list
> 
> If the block is really bad, the filesystem can not be fixed.
> You can remove this block from the bad block list and hope
> that the block is really OK.  But there are no guarantees.
> - ------------------------------
> [at 20480000 there seems to be an intact superblock; got the number
> (and the block size) from 'mke2fs -n']

What I'd suggest doing is making a complete copy of the disk using
ddrescue to a known good disk, and then run e2fsck on that.  It's
going to be simplest, most foolproof way to recover the data.  Yes it
will take a while, but you can let it run overnight...

     	    	       	       	   - Ted
