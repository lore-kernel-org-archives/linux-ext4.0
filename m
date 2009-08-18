From: Andreas Dilger <adilger@sun.com>
Subject: Re: fsck infinite loop on corrupt ext4 file system
Date: Mon, 17 Aug 2009 20:47:41 -0600
Message-ID: <20090818024741.GF5931@webber.adilger.int>
References: <1250294105.6221.24.camel@bobble.smo.corp.google.com>
 <1250557822.23227.9.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:32842 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZHRCrl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Aug 2009 22:47:41 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7I2le8X003854
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2009 19:47:41 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KOJ00B00X16BL00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 17 Aug 2009 19:47:40 -0700 (PDT)
In-reply-to: <1250557822.23227.9.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 17, 2009  18:10 -0700, Frank Mayhar wrote:
> I've made a little more progress since Friday.  I had grabbed a dumpe2fs
> dump of the corrupted file system and one of the newly-created file
> system on the same device.  Adjusting for normal variation (numbers of
> free blocks, flags, etc.), there are no differences _except_ in the very
> block groups that fsck complained about having bad checksums.  For those
> (and only those), the locations of the block bitmap and inode table
> differ.  I've attached the diff output.

It doesn't appear that the two filesystems were created with the same
options, or one of the filesystems was resized or something.

> In particular, block group 276 claims to have its inode table at blocks
> 0-204, which is clearly wrong.  This is the block group for which the
> allocation failed, causing the original loop.
> 
> It's clear that fsck is neither correcting the block groups nor is it
> detecting the bad entries properly (a sanity check might be in order
> here).  It's not even noticing that it's looping, it just keeps failing
> the allocation and retrying.  While it may be that fsck can't recover
> the file system in this case, it should at least notice and abort.
> 
> My thinking is that the location of the inode tables should be invariant
> over the life of the file system.  Certainly there's no place in ext4
> itself that changes those fields (that I can see, anyway).  Why couldn't
> fsck compute the proper values and compare those against what's there?

With the addition of FLEX_BG there is no longer a hard & fast rule for
the location of the block groups' metadata.  In the past it was always
guaranteed to be within the group itself, now it can be anywhere.

>  Group 276: (Blocks 9043968-9076735)
> -  Block bitmap at 9043968 (+0), Inode bitmap at 9043969 (+1)
> -  Inode table at 0-204
> +  Block bitmap at 8912900, Inode bitmap at 8912916
> +  Inode table at 8913748-8913952

This is definitely bogus and should be detected/fixed by e2fsck.  I
suspect it used to be handled (pre-flexbg) by the check that the inode
table is within the group, but now there is no sanity check for the
placement at all (including overlapping with other groups, superblocks,
etc.

It makes sense to still validate the sanity of the group descriptor
data, and then check the backup group descriptors if the primaries
are suspicious.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

