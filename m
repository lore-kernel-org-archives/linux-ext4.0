From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/34] dumpe2fs: output cleanup
Date: Fri, 19 Sep 2014 13:00:05 -0700
Message-ID: <20140919200005.GI10150@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221226.13646.37351.stgit@birch.djwong.org>
 <20140919162200.GO26995@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37096 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaISUAO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Sep 2014 16:00:14 -0400
Content-Disposition: inline
In-Reply-To: <20140919162200.GO26995@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 19, 2014 at 12:22:00PM -0400, Theodore Ts'o wrote:
> On Sat, Sep 13, 2014 at 03:12:26PM -0700, Darrick J. Wong wrote:
> > Don't display unused inodes twice, and make it clear that we're
> > printing a descriptor checksum.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Cc: TR Reardon <thomas_reardon@hotmail.com>
> 
> One problem with the current output format is that exceeds the 80
> character line limit pretty blatently:
> 
> Group 3: (Blocks 24577-32768) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
>   Checksum 0x5bd9, unused inodes 2048
>   Backup superblock at 24577, Group descriptors at 24578-24578
>   Reserved GDT blocks at 24579-24833
>   Block bitmap at 261 (bg #0 + 260), csum 0x00000000, Inode bitmap at 269 (bg #0 + 268), csum 0x00000000
>   Inode table at 1042-1297 (bg #0 + 1041)
>   7935 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
>   Free blocks: 24834-32768
>   Free inodes: 6145-8192
> 
> If we are printing the checksum, we probably need to insert a line
> break and indent before printing the Inode bitmap.  Does that seem
> reasonable?

Seems fine to me, since other BG fields get their own line anyway.  Do you want
me to make a(nother) patch, or have you already fixed this up in git?

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
