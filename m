From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Fri, 30 Nov 2012 21:23:39 -0700
Message-ID: <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca>
References: <50B967E2.7090703@infradead.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:11559 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2LAEXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Nov 2012 23:23:40 -0500
In-Reply-To: <50B967E2.7090703@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-11-30, at 7:13 PM, Darren Hart wrote:
> I am working on creating some files after creating a filesystem in
> mke2fs. This is part of a larger project to add initial directory
> support to mke2fs.

Maybe some background on what you are trying to do would help us to
understand the problem?

Cheers, Andreas

> To make it easy for people to see what I'm working
> on, I've pushed my dev tree here:
> 
> http://git.infradead.org/users/dvhart/e2fsprogs/shortlog/refs/heads/initialdir
> 
> Note: the code is still just in the prototyping state. It is inelegant
> to say the least. The git tree will most definitely rebase. I'm trying
> to get it functional, once that is understand, I will refactor
> appropriately.
> 
> I can create a simple directory structure and link in files and fast
> symlinks. I'm currently working on copying content from files in the
> initial directory. The process I'm using is as follows:
> 
> 
> ext2fs_new_inode(&ino)
> ext2fs_link()
> 
> ext2fs_read_inode(ino, &inode)
> /* some initial inode setup */
> ext2fs_write_new_inode(ino, &inode)
> 
> ext2fs_file_open2(&inode)
> ext2fs_write_file()
> ext2fs_file_close()
> 
> inode.i_size = bytes_written
> ext2fs_write_inode()
> 
> ext2fs_inode_alloc_stats2(ino)
> 
> 
> When I mount the image, the size for the file is correct, by catting it
> returns nothing. If I instead hack in the known size during the initial
> inode setup and drop the last ext2fs_write_inode() call, then the size
> is right and catting the file works as expected.
> 
> Is it incorrect to write the inode more than once? If not, am I doing
> something that is somehow decoupling the block where the data was
> written from the inode associated with the file?
> 
> Thanks,
> 
> -- 
> Darren Hart
> Intel Open Source Technology Center
> Yocto Project - Technical Lead - Linux Kernel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





