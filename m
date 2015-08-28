From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: errors following ext3 to ext4 conversion
Date: Fri, 28 Aug 2015 10:09:46 -0600
Message-ID: <A66286AB-1DB5-4747-A1EB-0CE8C5CE0C1A@dilger.ca>
References: <55DE5F79.4010004@yale.edu>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Chris Hunter <chris.hunter@yale.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35869 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbbH1QJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2015 12:09:43 -0400
Received: by padhm10 with SMTP id hm10so11323073pad.3
        for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2015 09:09:43 -0700 (PDT)
In-Reply-To: <55DE5F79.4010004@yale.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 26, 2015, at 6:53 PM, Chris Hunter <chris.hunter@yale.edu> wrote:
> 
> I attempted to convert ext3 to  ext4 filesystem. I am using e2fsprogs (1.42.12.wc1 (15-Sep-2014)).

This is the Lustre-patched e2fsprogs.

When was this filesystem formatted, since Lustre itself has been using
an ext4 format for a long time already (extents, uninit_bg, dir_index)
so unless it was something really ancient, these features should have
been on already.  Was there some prior corruption that started you
down this road?

> I ran command tune2fs tune2fs -O extents,uninit_bg,dir_index /dev/DEV -o acl,user_xattr /dev/DEV.
> I then encountered errors (below) when running read-only e2fsck. I have not mounted the filesystem.
> Is it possible to backout the ext3/ext4 changes ?
> Do tune2fs changes take effect immediately or next time filesystem is mounted?
> 
> 
> e2fsck shows a variety of errors:
> Pass 1: Checking inodes, blocks, and sizes
> Inode 118843400, end of extent exceeds allowed value
>        (logical block 1409, physical block 3803034390, len 976)
> Inode 118843400, end of extent exceeds allowed value
>        (logical block 2385, physical block 3803056554, len 4294966945)

This is a bit strange, because the end of the first extent (1409 + 976)
matches the start of the next one (2385) so that should be correct?
Definitely the "4294966945" (= 0xfffffea1 = -351) length is incorrect
and the victim of some corruption.  It isn't even some random bit flip
so I have no idea how "-351" got in there.

> Inode 118843400, i_size is 8331264, should be 5771264.  Fix? no
> Inode 118843400, i_blocks is 16328, should be 11312.  Fix? no

It looks like you've lost an even 2500KB = 625 blocks, or 5016 blocks off the end of this directory, depending whether i_size or i_blocks
should be trusted.

> (...)
> 
> Pass 2: Checking directory structure
> Problem in HTREE directory inode 118843400 (/O/0/d0): bad block number 2030.
> Problem in HTREE directory inode 118843400 (/O/0/d0): bad block number 2031.
> Problem in HTREE directory inode 118843400 (/O/0/d0): bad block number 2032.
> Problem in HTREE directory inode 118843400 (/O/0/d0): bad block number 2033.

This looks like a Lustre OST filesystem layout.  Are the other d*
directories also corrupted?

> Pass 4: Checking reference counts
> Unattached inode 26
> Unattached inode 27
> Unattached inode 28
> 
> regards,
> chris hunter
> chris.hunter@yale.edu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





