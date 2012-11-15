From: "kaefert@gmail.com" <kaefert@gmail.com>
Subject: Re: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors:
 Checksum for group .. failed
Date: Thu, 15 Nov 2012 12:51:04 +0100
Message-ID: <CACDumsTV9vfs5-dJt0qzfdCTcUm0H-M7tEUVxEKm9DVsAqR22w@mail.gmail.com>
References: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
 <20121109000156.GQ19977@thunk.org> <CACDumsTj9S2eLNG+zNFY_9ZCZdKGDVVz5SF2BqapS3JvvYP8AA@mail.gmail.com>
 <20121112161646.GF4895@thunk.org> <CACDumsT=cjmNFtAWKMXvkvujHgixEX44xEif+qo3Q04f1N=QsQ@mail.gmail.com>
 <7CDB2F8F-6316-424C-8F37-5E5CEEF8F29D@dilger.ca> <20121113212400.GA13850@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62610 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423250Ab2KOLvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 06:51:25 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so903615eek.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 03:51:24 -0800 (PST)
In-Reply-To: <20121113212400.GA13850@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there!

I've found that on that filesystem, in many folders I now have found
every 8th file has as contents instead of what it should have a copy
of every other 4th file - with some aditional zeros after it.

Maybe its more clear I give an example:
A folder with 25 files:
file 5 is a copy of 1
file 13 is a copy of 9
file 21 is a copy of 17

The original contents of file 5, 13 and 21 seem to have been lost,
maybe they are in the lost+found folder. The problem doesn't always
start with the first file in a folder, and doesn't always continue to
the end of the folder.


2012/11/13 Theodore Ts'o <tytso@thunk.org>
>
> To follow up on the list since Thomas and I have had a number of
> e-mail exchanges that were off-list, and he has sent me an compressed,
> raw e2image dump of his file system which I have investigated
>
> The proximate cause of the fs corruption seems to be a few inode table
> blocks written offset by a 1024 bytes --- there were 3 pairs of inodes
> of the form (N, N+4) which had the exact same contents in the inode
> structure (same generation number, same mtime/ctime/atimes, same
> extents).  This pattern of corruption is quite odd given that the file
> system has a 4k block size.  The best bet is that the corruption
> happened at the USB device layer, since the mis-written inodes were
> offset by a 2 512 byte sectors, as opposed to by an incorrect block
> number.  Thomas tells me this particular device has had a flaky USB
> controller and this is the not the first such failure.
>
> There also seems to be a bug in e2fsck which caused it not to be able
> to repair the corrupted file system.  I have not had a chance to track
> down the bug yet.  It may have been caused by how we handle extent
> tree blocks getting cached while trying to clone the data block.
> Something which we should fix, but ultimately, the use of metadata
> checksums is going to be the best way to deal with cases of the inode
> table block getting written to the wrong place on disk, since we will
> then know which inode not to trust, and just have e2fsck zap it.
>
> Speaking of zapping, I've given Thomas instructions on how to clri
> three of the duplicated inodes using debugfs, and that allowed e2fsck
> to be able to repair his file system.  He will have suffered some data
> loss due to the corrupted inode table, but at least this way he'll be
> able to gain access to most of the files on the disk.
>
>                                    - Ted
