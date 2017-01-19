From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext4/inline.c:1943!
Date: Thu, 19 Jan 2017 17:58:30 -0500
Message-ID: <20170119225830.ihoia75rhy2em27x@thunk.org>
References: <20170112144657.p33nf3u3ev27ixjq@thunk.org>
 <20170118082128.2402.qmail@ns.sciencehorizons.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@sciencehorizons.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35300 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751857AbdASW6n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 19 Jan 2017 17:58:43 -0500
Content-Disposition: inline
In-Reply-To: <20170118082128.2402.qmail@ns.sciencehorizons.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 18, 2017 at 03:21:28AM -0500, George Spelvin wrote:
> I was trying to rmdir an empty directory in lost+found that accumulated
> during my recent problems.
> 
> EXT4-fs (md3): mounted filesystem with writeback data mode. Opts: data=writeback,delalloc
> 
> $ cd /mountpoint/lost+found
> $ rmdir \#1625089/
> 
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/inline.c:1943!

> 
> debugfs:  stat <1625089>
> Inode: 1625089   Type: directory    Mode:  0775   Flags: 0x10000000
> Generation: 927350643    Version: 0x00000000:00000004
> User:  1000   Group:   161   Project:     0   Size: 132
> File ACL: 1664090185    Directory ACL: 0
> Links: 0   Blockcount: 8
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x587f2034:472c74ec -- Wed Jan 18 02:58:44 2017
>  atime: 0x56b9e2f8:b68a7658 -- Tue Feb  9 08:00:40 2016
>  mtime: 0x56c1bc4b:a7765de8 -- Mon Feb 15 06:53:47 2016
> crtime: 0x56ba9eb4:a51d90ac -- Tue Feb  9 21:21:40 2016
> Size of extra inode fields: 32
> Extended attributes:
>   system.data (72)
> Inode checksum: 0xe2f12fc5
> Size of inline data: 132

OK, so the problem seems the inode in question has the INLINE_DATA
flag set, but i_blocks is non-zero.  And it looks like the data was
actually stored in an exernal data block, and the in-line xattr wasn't
present.

e2fsck should be checking and complaining if this is the case.  If
not, it's a bug in e2fsck.

And the kernel certainy shouldn't be BUG'ing when it comes across
what is clearly a case of file system corruption.

Cheers,

					- Ted
