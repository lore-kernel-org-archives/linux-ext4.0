From: Darren Hart <dvhart@infradead.org>
Subject: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Fri, 30 Nov 2012 18:13:54 -0800
Message-ID: <50B967E2.7090703@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52742
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021Ab2LACN5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2012 21:13:57 -0500
Received: from static-50-53-98-238.bvtn.or.frontiernet.net ([50.53.98.238] helo=envy.home)
	by bombadil.infradead.org with esmtpsa (Exim 4.76 #1 (Red Hat Linux))
	id 1Tecaa-00064d-M2
	for linux-ext4@vger.kernel.org; Sat, 01 Dec 2012 02:13:56 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am working on creating some files after creating a filesystem in
mke2fs. This is part of a larger project to add initial directory
support to mke2fs. To make it easy for people to see what I'm working
on, I've pushed my dev tree here:

http://git.infradead.org/users/dvhart/e2fsprogs/shortlog/refs/heads/initialdir

Note: the code is still just in the prototyping state. It is inelegant
to say the least. The git tree will most definitely rebase. I'm trying
to get it functional, once that is understand, I will refactor
appropriately.

I can create a simple directory structure and link in files and fast
symlinks. I'm currently working on copying content from files in the
initial directory. The process I'm using is as follows:


ext2fs_new_inode(&ino)
ext2fs_link()

ext2fs_read_inode(ino, &inode)
/* some initial inode setup */
ext2fs_write_new_inode(ino, &inode)

ext2fs_file_open2(&inode)
ext2fs_write_file()
ext2fs_file_close()

inode.i_size = bytes_written
ext2fs_write_inode()

ext2fs_inode_alloc_stats2(ino)


When I mount the image, the size for the file is correct, by catting it
returns nothing. If I instead hack in the known size during the initial
inode setup and drop the last ext2fs_write_inode() call, then the size
is right and catting the file works as expected.

Is it incorrect to write the inode more than once? If not, am I doing
something that is somehow decoupling the block where the data was
written from the inode associated with the file?

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
