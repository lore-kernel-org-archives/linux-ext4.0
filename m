From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Fri, 25 Jun 2010 12:23:48 -0600
Message-ID: <B76CA57A-4379-494C-8DC6-DE041F2A4555@dilger.ca>
References: <AANLkTilD3D2QOXi1b7oXT2uFBx_vuO803HOX4JJXfWG0@mail.gmail.com> <20100621170556.GB6843@thunk.org> <AANLkTimN1pMUlpoVbQe1ueL_LiorWqPNgpEfRBNrbEp0@mail.gmail.com> <AANLkTimJVDB4hqCeD2dPBAD8krJScgiBP8-3sBmRaFB1@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Hsuan-Ting <acht93@cs.ccu.edu.tw>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:36184 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0FYSXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jun 2010 14:23:49 -0400
In-Reply-To: <AANLkTimJVDB4hqCeD2dPBAD8krJScgiBP8-3sBmRaFB1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-06-25, at 04:33, Hsuan-Ting wrote:
> My test case:
> 1. build a linear raid (1 x 2TB disk)
> 2. mkfs.ext4, mount it and"echo 123 > test" to
> touch a test file.
> 3.  grown the linear raid to >16TB (9 x 2TB + 1 x 1.5TB)
> 4. do resize ( resize -fpF /dev/md2 )
> After resizing, the content of the test file is correct.

This is mostly unsurprising, since there is very little chance that the single file is corrupted by a resize.  Better would be to fill nearly the whole filesystem (e.g. llverfs, previously posted to this list) and verify the file contents after the resize.

> But "fsck -nyv" will get the following error:
> I think maybe I should modify "ext2_ino_t" type from
> "__u32" to "__u64".
> Maybe this modification will fix many overflow issue.

No, this will completely break the ext2/3/4 on-disk format.  What you need to make sure is that when resize2fs is resizing the filesystem that it limits the total number of inodes in the filesystem to 2^32-1.  I guess that means the groups beyond the 2^32nd inode will have no inode table at all, which is a bit strange, but something that we need to expect in e2fsck.

I guess the alternative would be to allocate the inode table, but we couldn't (yet?) use those inodes without significant work to support 64-bit inode numbers.  Probably the first step in that direction would be the "dirdata" patch that we have to allow storing extra data in directory entries.

Cheers, Andreas





