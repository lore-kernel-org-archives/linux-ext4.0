From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/24] debugfs: Only print the first 60 bytes from
 i_block on a fast symlink
Date: Tue, 22 Jul 2014 13:39:02 -0700
Message-ID: <20140722203902.GD8628@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225224.31374.15186.stgit@birch.djwong.org>
 <B72871BE-3D5E-4A07-8EDE-9B4032119174@dilger.ca>
 <20140722164356.GF25291@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35438 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaGVUjJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2014 16:39:09 -0400
Content-Disposition: inline
In-Reply-To: <20140722164356.GF25291@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 22, 2014 at 12:43:56PM -0400, Theodore Ts'o wrote:
> On Sat, Jul 19, 2014 at 10:49:35AM -0600, Andreas Dilger wrote:
> > Wouldn't it be better to decode and print the whole symlink from the
> > inline data?  Depending on the use of debugfs, printing only the
> > first 60 bytes may cause people/scripts to think the link is
> > corrupted.
> 
> I agree in principle, although for now, this fixes a bug, so I'll
> apply it.  Humans shouldn't get too confused, since we now do print
> the extended attributes:

Nah, ignore/revert it, I'll have a better patch out in a few minutes.

> debugfs:  stat symlinkfile
> Inode: 131075   Type: symlink    Mode:  0777   Flags: 0x10000000
> Generation: 3080286240    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 62
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x53ce9340:c78386a4 -- Tue Jul 22 16:37:20 2014
>  atime: 0x53ce9346:bd2d7348 -- Tue Jul 22 16:37:26 2014
>  mtime: 0x53ce9340:c78386a4 -- Tue Jul 22 16:37:20 2014
> crtime: 0x53ce9340:c78386a4 -- Tue Jul 22 16:37:20 2014
> Size of extra inode fields: 28
> Extended attributes:
>   system.data = "89" (2)
> Fast_link_dest: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567"
> 
> 
> But I would agree it owuld be better if we displayed the symlink
> target completely.

Yes, I'll do that.

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
