From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors:
 Checksum for group .. failed
Date: Fri, 16 Nov 2012 13:14:29 -0500
Message-ID: <20121116181429.GB16410@thunk.org>
References: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
 <20121109000156.GQ19977@thunk.org>
 <CACDumsTj9S2eLNG+zNFY_9ZCZdKGDVVz5SF2BqapS3JvvYP8AA@mail.gmail.com>
 <20121112161646.GF4895@thunk.org>
 <CACDumsT=cjmNFtAWKMXvkvujHgixEX44xEif+qo3Q04f1N=QsQ@mail.gmail.com>
 <7CDB2F8F-6316-424C-8F37-5E5CEEF8F29D@dilger.ca>
 <20121113212400.GA13850@thunk.org>
 <CACDumsTV9vfs5-dJt0qzfdCTcUm0H-M7tEUVxEKm9DVsAqR22w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "kaefert@gmail.com" <kaefert@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33224 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab2KPSOc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Nov 2012 13:14:32 -0500
Content-Disposition: inline
In-Reply-To: <CACDumsTV9vfs5-dJt0qzfdCTcUm0H-M7tEUVxEKm9DVsAqR22w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 15, 2012 at 12:51:04PM +0100, kaefert@gmail.com wrote:
> 
> I've found that on that filesystem, in many folders I now have found
> every 8th file has as contents instead of what it should have a copy
> of every other 4th file - with some aditional zeros after it.
> 
> Maybe its more clear I give an example:
> A folder with 25 files:
> file 5 is a copy of 1
> file 13 is a copy of 9
> file 21 is a copy of 17
> 
> The original contents of file 5, 13 and 21 seem to have been lost,
> maybe they are in the lost+found folder. The problem doesn't always
> start with the first file in a folder, and doesn't always continue to
> the end of the folder.

Alas, that's symptomatic of an inode table block getting written to
the wrong location on disk.  Each inode structure in the inode table
is 256 bytes (by default for ext4).  So if you write a block which is
supposed to contain the inode information for inodes #100, #101, #102,
#104, #105, #106, #107, #108, ... #115 off by 1 kilobyte, the the
inode structure for #100 will get written on top of the location where
the inode information for inode #104 should be, etc.

This sounds very much like hardware failure to me, since this is not
the sort of mistake that is likely to be caused by a kernel bug ---
especially since 1k is not a multiple of the file system block size.

So I would cast a very skeptical eye on the hardware that this file
system was stored on....

						- Ted
