From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Thu, 24 Feb 2011 08:29:46 +0100
Message-ID: <20110224072945.GE16661@bitwizard.nl>
References: <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl> <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca> <20110222221304.GH2924@thunk.org> <20110223044427.GM21917@bitwizard.nl> <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu> <20110223205309.GA16661@bitwizard.nl> <F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:51838 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751639Ab1BXH3s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 02:29:48 -0500
Content-Disposition: inline
In-Reply-To: <F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 23, 2011 at 03:24:18PM -0700, Andreas Dilger wrote:

> The dircount can be extracted from the group descriptors, which
> count the number of allocated directories in each group.  Since the

OK. 

> superblock "free inodes" count is no longer updated except at
> unmount time, the code would need to walk all of the group
> descriptors to get this number anyway.

No worries. It matters a bit for performance, but if that free inode
count in the superblock is outdated, we'll just use that outdated
one. The one case that I'm afraid of is that someone creates a new
filesystem (superblock inodes-in-use =~= 0), then copies on millions
of files, and then crashes his system.... 

I'll add a minimum of 999931, causing an overhead of around 4Mb of
disk space usage if this was totally unneccesary.

> If you have the opportunity, I wonder whether the entire need for
> tdb can be avoided in your case by using swap and the icount
> optimization patches previously posted?  I'd really like to get that
> patch included upstream, but it needs testing in an environment like
> yours where icount is a significant factor.  This would avoid all of
> the tdb overhead.

First: I don't think it will work. The largest amount of memory that
e2fsck had allocated was 2.5Gb. At that point it also had around 1.5G
of disk space in use for tdb's for a total of 4G. On the other hand,
we've established that the overhead in tdb is about 24bytes per 8
bytes of real data.... So maybe we would only have needed 200M of
in-memory datastructures to handle this. Two of those 400M together
with the dircount (tdb =750M, assume same ratio) total 600M still
above 3G.

Second: e2fsck is too fragile as it is. It should be able to handle
big filesystems on little systems. I have a puny little 2GHz Athlon
system that currently has 3T of disk storage and 1G RAM. Embedded
Linux systems can be running those amounts of storage with only 64
or 128 Mb of RAM. 

Even if MY filesystem happens to pass, with a little less memory-use,
then there is a slightly larger system that won't.

I have a server that has 4x2T instead of the server that has 4*1T. It
uses the same backup strategy, so it too has lots and lots of files.
In fact it has 84M inodes in use. (I thought 96M inodes would be
plenty... wrong! I HAVE run out of inodes on that thing!)

That one too may need to fsck the filesystem... 

I remember hearing about a tool that would extract all the filesystem
meta-info, so that I can make an image that I can then test e.g. fsck
upon? Inodes, directory blocks, indirect blocks etc.?

Then I could make an image where I could test this. I don't really
want to put this offline again for multiple days.


	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
