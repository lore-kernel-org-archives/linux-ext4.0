From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: e2fsck aborts when invalid indirect block is encountered
Date: Thu, 1 Sep 2011 02:17:14 -0600
Message-ID: <6826A7C1-1DE4-4F0B-8654-201A3F6D1BF2@dilger.ca>
References: <20110901063410.GA8313@notebook.chenhuan>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Chen Huan <chenhuan@nrchpc.ac.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:27557 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab1IAIRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Sep 2011 04:17:23 -0400
In-Reply-To: <20110901063410.GA8313@notebook.chenhuan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-01, at 12:34 AM, Chen Huan wrote:
> During a recent read-only checking of an corrupted ext3 file system,
> I found a strange behaviour of e2fsck: when an inode has an invalid
> indirect block number, e2fsck aborts with the following message:
> 
>    e2fsck 1.39 (29-May-2006)

Please retest with a new version of e2fsprogs.  The current release
version is 1.41.14, and the work-in-progress for version 1.42 is
available via Git.

>    Pass 1: Checking inodes, blocks, and sizes
>    Inode 12 has illegal block(s).  Clear? no
> 
>    Illegal block #-1 (4294967295) in inode 12.  IGNORED.
>    Error while iterating over blocks in inode 12: Illegal indirect block found
>    e2fsck: aborted
> 
> You can reproduce it with this code snippet:
> 
>    #!/bin/sh
> 
>    dev=/dev/sde
>    mnt=/mnt
> 
>    mkfs.ext3 -F $dev
>    mount $dev $mnt
>    dd if=/dev/zero of=$mnt/file bs=1M count=1
>    umount $dev
>    debugfs -w -R 'sif file block[IND] 0xFFFFFFFF' $dev
>    e2fsck -f -n $dev
> 
> Doing a fixing without -n option can safely delete this bad blocknum.
> 
> My question is: Is this behaviour a bug or intended?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





