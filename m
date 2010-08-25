From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Wed, 25 Aug 2010 09:05:52 +0900
Message-ID: <20100825090551.DEB3.61FB500B@jp.fujitsu.com>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com> <20100824131735.GD3713@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39168 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab0HYAFr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Aug 2010 20:05:47 -0400
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o7P05jdX002671
	for <linux-ext4@vger.kernel.org> (envelope-from m.mizuma@jp.fujitsu.com);
	Wed, 25 Aug 2010 09:05:45 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 114B845DE51
	for <linux-ext4@vger.kernel.org>; Wed, 25 Aug 2010 09:05:45 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id D616045DE4D
	for <linux-ext4@vger.kernel.org>; Wed, 25 Aug 2010 09:05:44 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id A18451DB8040
	for <linux-ext4@vger.kernel.org>; Wed, 25 Aug 2010 09:05:44 +0900 (JST)
Received: from m108.s.css.fujitsu.com (m108.s.css.fujitsu.com [10.249.87.108])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5BC5D1DB803C
	for <linux-ext4@vger.kernel.org>; Wed, 25 Aug 2010 09:05:44 +0900 (JST)
In-Reply-To: <20100824131735.GD3713@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 24 Aug 2010 15:17:36 +0200
Jan Kara <jack@suse.cz> wrote:

> On Mon 23-08-10 09:50:56, Masayoshi MIZUMA wrote:
> > In ext3 filesystem, if following conditions 1., 2., 3. and 4. is satisfied,
> > getfattr can't search the extended attribute (EA) after remount.
> > 
> > Condition:
> >     1. the inode size is over 128 byte
> >     2. "lost+found" whose inode number is 11 was removed
> >     3. the 11th inode is used for a file.
> >     4. the EA locates in-inode
> > 
> > This happens because of following logic:
> >     i_extra_isize is set to over 0 by ext3_new_inode() when we create
> >     a file whose inode number is 11 after removing "lost+found".
> >     Therefore setfattr creates the EA in-inode.
> >     After remount, i_extra_isize of 11th inode is set to 0 by ext3_iget()
> >     when we lookup the file, so getfattr tries to search the EA out-inode.
> >     However, the EA locates in-inode, so getfattr can't search the EA.
> > 
> > How to reproduce:
> >     1. mkfs.ext3 -I 256 /dev/sdXX
> >     2. mount -o acl,user_xattr  /dev/sdXX /TEST
> >     3. rm -rf /TEST/*
> >     4. touch /TEST/file (whose inode number is 11)
> >     5. cd /TEST; setfattr -n user.foo0 -v bar0 file
> >     6. cd /TEST; getfattr -d file
> >        -> can see foo0/bar0
> >     7. umount  /dev/sdXX
> >     8. mount -o acl,user_xattr /dev/sdXX /TEST
> >     9. cd /TEST; getfattr -d file
> >        -> can't see foo0/bar0
> > 
> > Though the 11th inode is used for "lost+found" normally, the other
> > file can also use it. Therefore, i_extra_isize of 11th inode should be set
> > to the suitable value by ext3_iget().
>   Hmm, with which kernel have you tested that? Because my 2.6.32 kernel
> works just fine (and looking into the code, all should be handled well).
I tested at 2.6.35.

> Look:
> mount -o loop,user_xattr ~jack/fs-images/ext3-image /mnt/
> quack:/crypted/home/jack # cd /mnt/
> quack:/mnt # touch file
> quack:/mnt # ls -i file
> 11 file
> quack:/mnt # setfattr -n user.foo0 -v bar0 file
> quack:/mnt # getfattr -d file
> # file: file
> user.foo0="bar0"
> 
> quack:/mnt # cd
> quack:~ # umount /mnt
> quack:~ # mount -o loop,user_xattr ~jack/fs-images/ext3-image /mnt/
> quack:~ # getfattr -d /mnt/file
> getfattr: Removing leading '/' from absolute path names
> # file: mnt/file
> user.foo0="bar0"
What size is the inode ? This problem happens if the size is larger than 128 byte.
(I tested at 256 byte inode.)

Thanks,
Masayoshi

