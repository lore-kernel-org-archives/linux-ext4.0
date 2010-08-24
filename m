From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Tue, 24 Aug 2010 15:17:36 +0200
Message-ID: <20100824131735.GD3713@quack.suse.cz>
References: <0347DFC8-03A9-45DF-9B9F-ED4005720C49@dilger.ca>
 <20100823091657.ACB6.61FB500B@jp.fujitsu.com>
 <20100823095056.ACBA.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49412 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab0HXNSX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Aug 2010 09:18:23 -0400
Content-Disposition: inline
In-Reply-To: <20100823095056.ACBA.61FB500B@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 23-08-10 09:50:56, Masayoshi MIZUMA wrote:
> In ext3 filesystem, if following conditions 1., 2., 3. and 4. is satisfied,
> getfattr can't search the extended attribute (EA) after remount.
> 
> Condition:
>     1. the inode size is over 128 byte
>     2. "lost+found" whose inode number is 11 was removed
>     3. the 11th inode is used for a file.
>     4. the EA locates in-inode
> 
> This happens because of following logic:
>     i_extra_isize is set to over 0 by ext3_new_inode() when we create
>     a file whose inode number is 11 after removing "lost+found".
>     Therefore setfattr creates the EA in-inode.
>     After remount, i_extra_isize of 11th inode is set to 0 by ext3_iget()
>     when we lookup the file, so getfattr tries to search the EA out-inode.
>     However, the EA locates in-inode, so getfattr can't search the EA.
> 
> How to reproduce:
>     1. mkfs.ext3 -I 256 /dev/sdXX
>     2. mount -o acl,user_xattr  /dev/sdXX /TEST
>     3. rm -rf /TEST/*
>     4. touch /TEST/file (whose inode number is 11)
>     5. cd /TEST; setfattr -n user.foo0 -v bar0 file
>     6. cd /TEST; getfattr -d file
>        -> can see foo0/bar0
>     7. umount  /dev/sdXX
>     8. mount -o acl,user_xattr /dev/sdXX /TEST
>     9. cd /TEST; getfattr -d file
>        -> can't see foo0/bar0
> 
> Though the 11th inode is used for "lost+found" normally, the other
> file can also use it. Therefore, i_extra_isize of 11th inode should be set
> to the suitable value by ext3_iget().
  Hmm, with which kernel have you tested that? Because my 2.6.32 kernel
works just fine (and looking into the code, all should be handled well).
Look:
mount -o loop,user_xattr ~jack/fs-images/ext3-image /mnt/
quack:/crypted/home/jack # cd /mnt/
quack:/mnt # touch file
quack:/mnt # ls -i file
11 file
quack:/mnt # setfattr -n user.foo0 -v bar0 file
quack:/mnt # getfattr -d file
# file: file
user.foo0="bar0"

quack:/mnt # cd
quack:~ # umount /mnt
quack:~ # mount -o loop,user_xattr ~jack/fs-images/ext3-image /mnt/
quack:~ # getfattr -d /mnt/file
getfattr: Removing leading '/' from absolute path names
# file: mnt/file
user.foo0="bar0"

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
