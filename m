From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Sign, more experimentation and broken features...
Date: Tue, 12 Mar 2013 00:06:49 -0400
Message-ID: <20130312040649.GD18595@thunk.org>
References: <20130312032843.29393.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52732 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab3CLEGx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 00:06:53 -0400
Content-Disposition: inline
In-Reply-To: <20130312032843.29393.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 11, 2013 at 11:28:43PM -0400, George Spelvin wrote:
> 	Okay, I'll do ask you ask.  First odd thing: errors!
> 	Minor ones, but all I've done is mke2fs and copy some files
> 	to it:
> # e2fsck -f -v -C0 -D /dev/md3

I'm going to guess there may be problems with using the e2fsck -D
option with bigalloc.  I could imagine potential problems with that,
and it's probably not something we've explicitly tested. 

Also, just to check.... all of this was done with the file system
unmounted, right?

> [514]# e2fsck -f -v -C0 /dev/md3
> e2fsck 1.43-WIP (22-Sep-2012)
> ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
> e2fsck: Group descriptors look bad... trying backup blocks...
> Pass 1: Checking inodes, blocks, and sizes
> Group 7461's block bitmap at 973079840 conflicts with some other fs block.
> Relocate<y>? 
> data: e2fsck canceled.

The good news is that this appears to be a newly added group, so
hopefully there was no data lost.

It may be worth mounting the file system read-only and copying all of
your data off before you do anything else....

Also, it looks like there may be some problems with the metadata_csum
option when resizing, either alone or in combination with bigalloc.
Please note that I have ___not___ really done a lot of exhaustive
testing with metadata_csum, since it's not in a released final state
in e2fsprogs, and I've had lots of other things I've been busy trying
to make sure is stablized.  For example, we are still working on
fixing various test failures with bigalloc.  It's probably good enough
for fairly simple workloads (mostly using fallocate and direct I/O),
but there are corner cases which we are still working on fixing.

	    	      	     	   	    - Ted
