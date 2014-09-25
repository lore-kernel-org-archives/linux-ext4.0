From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: birth time of a file
Date: Thu, 25 Sep 2014 09:08:09 +0200
Message-ID: <3C36B392-FF09-46D1-B7DA-ADF893A56C42@dilger.ca>
References: <alpine.DEB.2.19.4.1409242257430.9897@trent.utfs.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44632 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaIYHIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Sep 2014 03:08:13 -0400
Received: by mail-wi0-f174.google.com with SMTP id fb4so8287048wid.1
        for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2014 00:08:12 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.19.4.1409242257430.9897@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It looks like your filesystem is formatted with 128-byte inodes
(i.e. ext3) instead of 256-byte inodes (i.e. ext4). The i_crtime is stored
in this extended space of the inode.  You could verify this with

   dumpe2fs -h /dev/loop0

and look for the "Inode size" field. 

This is a format time option. What is strange is that you have specified mkfs.ext4, so this should be selected automatically. It may be that with very small devices (e.g. floppy size) it defaults to 128-byte inodes. 

Cheers, Andreas

> On Sep 25, 2014, at 8:23, Christian Kujau <lists@nerdbynature.de> wrote:
> 
> Hi,
> 
> I want to find out the "creation time" or "birth time" of a file. I know, 
> this comes up every now and then but I could not find any recent or 
> reliable information, just random posting on the interwebs. Here[0] it is 
> suggested that coreutils stat(1) cannot display "birth time", although a 
> commit[1] from 2010 states that birthtime is now supported. But even if 
> stat(1) cannot display it, debugfs should be able to, but not here:
> 
> # mkfs.ext4 /dev/loop0
> # mount -t ext4 /dev/loop0 /mnt/disk/
> # mount | tail -1
> /dev/loop0 on /mnt/disk1 type ext4 (rw,relatime,data=ordered)
> # touch /mnt/disk/foo
> # debugfs -R 'stat foo' /dev/loop0
> debugfs 1.42.12 (29-Aug-2014)
> Inode: 12   Type: regular    Mode:  0600   Flags: 0x80000
> Generation: 3547819027    Version: 0x00000001
> User:     0   Group:     0   Size: 0
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x5423a873 -- Wed Sep 24 22:30:27 2014
> atime: 0x5423a873 -- Wed Sep 24 22:30:27 2014
> mtime: 0x5423a873 -- Wed Sep 24 22:30:27 2014
> EXTENTS:
> 
> 
> Now, fs/ext4/ext4.h defines i_crtime and it's referenced in ialloc.c and 
> inode.c, so it seems to be used - but why can't debugfs display it? I 
> tested this with 3.14, 3.17-rc6 and 3.16 kernels, debugfs just would 
> not display "crtime".
> 
> Thanks,
> Christian.
> 
> [0] https://unix.stackexchange.com/questions/50177/birth-is-empty-on-ext4 
> [1] http://git.savannah.gnu.org/cgit/coreutils.git/commit/?id=abe5c1f9
> -- 
> BOFH excuse #408:
> 
> Computers under water due to SYN flooding.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
