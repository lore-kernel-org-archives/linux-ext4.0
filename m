From: tytso@thunk.org (Theodore Ts'o)
Subject: Re: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors:
 Checksum for group .. failed
Date: Tue, 13 Nov 2012 16:24:00 -0500
Message-ID: <20121113212400.GA13850@thunk.org>
References: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
 <20121109000156.GQ19977@thunk.org>
 <CACDumsTj9S2eLNG+zNFY_9ZCZdKGDVVz5SF2BqapS3JvvYP8AA@mail.gmail.com>
 <20121112161646.GF4895@thunk.org>
 <CACDumsT=cjmNFtAWKMXvkvujHgixEX44xEif+qo3Q04f1N=QsQ@mail.gmail.com>
 <7CDB2F8F-6316-424C-8F37-5E5CEEF8F29D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "kaefert@gmail.com" <kaefert@gmail.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60914 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab2KMVYF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2012 16:24:05 -0500
Content-Disposition: inline
In-Reply-To: <7CDB2F8F-6316-424C-8F37-5E5CEEF8F29D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To follow up on the list since Thomas and I have had a number of
e-mail exchanges that were off-list, and he has sent me an compressed,
raw e2image dump of his file system which I have investigated

The proximate cause of the fs corruption seems to be a few inode table
blocks written offset by a 1024 bytes --- there were 3 pairs of inodes
of the form (N, N+4) which had the exact same contents in the inode
structure (same generation number, same mtime/ctime/atimes, same
extents).  This pattern of corruption is quite odd given that the file
system has a 4k block size.  The best bet is that the corruption
happened at the USB device layer, since the mis-written inodes were
offset by a 2 512 byte sectors, as opposed to by an incorrect block
number.  Thomas tells me this particular device has had a flaky USB
controller and this is the not the first such failure.

There also seems to be a bug in e2fsck which caused it not to be able
to repair the corrupted file system.  I have not had a chance to track
down the bug yet.  It may have been caused by how we handle extent
tree blocks getting cached while trying to clone the data block.
Something which we should fix, but ultimately, the use of metadata
checksums is going to be the best way to deal with cases of the inode
table block getting written to the wrong place on disk, since we will
then know which inode not to trust, and just have e2fsck zap it.

Speaking of zapping, I've given Thomas instructions on how to clri
three of the duplicated inodes using debugfs, and that allowed e2fsck
to be able to repair his file system.  He will have suffered some data
loss due to the corrupted inode table, but at least this way he'll be
able to gain access to most of the files on the disk.

     	     	       	       	   - Ted
