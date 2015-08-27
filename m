From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: errors following ext3 to ext4 conversion
Date: Wed, 26 Aug 2015 23:39:49 -0400
Message-ID: <20150827033949.GA12151@thunk.org>
References: <55DE5F79.4010004@yale.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chris Hunter <chris.hunter@yale.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49690 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbbH0Djw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 23:39:52 -0400
Content-Disposition: inline
In-Reply-To: <55DE5F79.4010004@yale.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 26, 2015 at 08:53:13PM -0400, Chris Hunter wrote:
> I attempted to convert ext3 to  ext4 filesystem. I am using e2fsprogs
> (1.42.12.wc1 (15-Sep-2014)). I ran command tune2fs tune2fs -O
> extents,uninit_bg,dir_index /dev/DEV -o acl,user_xattr /dev/DEV.
> I then encountered errors (below) when running read-only e2fsck. I have not
> mounted the filesystem.

I'd suggest using

debugfs -w -R "features ^extents,^uninit_bg" /dev/DEV

and then try re-running the read-only e2fsck.  Did you try running a
read-only e2fsck before you tried using the tune2fs command?

Merely turning on the extents feature doesn't actually convert any
files to use extents.  So if e2fsck is showing errors like this:

> e2fsck shows a variety of errors:
> Pass 1: Checking inodes, blocks, and sizes
> Inode 118843400, end of extent exceeds allowed value
>         (logical block 1409, physical block 3803034390, len 976)
> Inode 118843400, end of extent exceeds allowed value
>         (logical block 2385, physical block 3803056554, len 4294966945)

This suggests that the file system was likely corrupted before you
tried converting the file system, since there should not have been any
extent-mapped files in an ext3 file system.

Regards,

						- Ted
