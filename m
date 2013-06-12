From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Too large value in =?utf-8?b?aW5vZGUuaV9ibG9ja3NbMV0=?=
Date: Wed, 12 Jun 2013 13:34:37 +0000 (UTC)
Message-ID: <loom.20130612T152507-9@post.gmane.org>
References: <loom.20130612T065900-326@post.gmane.org> <20130612125954.GB26388@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46028 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab3FLNey (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 09:34:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1UmlCP-0000Eg-6C
	for linux-ext4@vger.kernel.org; Wed, 12 Jun 2013 15:34:53 +0200
Received: from 91.241.2.251 ([91.241.2.251])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jun 2013 15:34:53 +0200
Received: from felipemonteiro.carvalho by 91.241.2.251 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jun 2013 15:34:53 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Theodore Ts'o <tytso <at> mit.edu> writes:
> The inode in question has the EXTENTS_FL flag set, which means the
> i_blocks[] array needs to get interpreted as the root node of the
> extent tree. 127754 is 0x0001F30A, where F30A is the magic number for
> the extents header, and 0x0001 means there is a single entry in the
> extent node.

Thanks, great =) So reading 
https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#The_Contents_of_inod
e.i_block

I see that i_block has 15*4=60 bytes, and with EXTENTS_FL the first 12 bytes 
of i_block are filled with a ext4_extent_header

What about the rest of it? I couldn't understand from the wiki page what
the rest holds exactly, it is not 100% clear ...

My first guess would be that it has in this order:

ext4_extent_header, 12 bytes long
ext4_extent_idx, 12 bytes long:
ext4_extent, 12 bytes long
ext4_extent_tail 4 bytes long

Which would sum 40 bytes ... still unsure about the other 20 however.

Any help here is greatly appreciated =)

> I **strongly** discourage people from trying to access the file system
> directly.  It's much better to use the libext2fs library, since it
> will deal with these sorts of issues for you automatically.  A

Please don't worry that I am not frivolously attempting to access the
file system directly. My project explictly requires this, it is a
recovery tool to repair damaged file systems, and it must work in
Windows and Mac OS X. Maybe libext2fs works outside Linux, not sure, 
but anyway we already have source code for reading/recovering ext2/3, 
I am just expanding it to ext4. External dependencies are always
not ideal.

I am new in the project, that's why I have so many beginner questions,
I appologise for it, but I'm thankful that I experienced developers 
like you answer them so that I can learn about the Linux Ext4
file system.

thanks =)

Felipe Monteiro de Carvalho


