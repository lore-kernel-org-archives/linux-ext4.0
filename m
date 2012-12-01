From: Darren Hart <dvhart@infradead.org>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Fri, 30 Nov 2012 21:08:27 -0800
Message-ID: <50B990CB.3080607@infradead.org>
References: <50B967E2.7090703@infradead.org> <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46934 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2LAFI3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2012 00:08:29 -0500
In-Reply-To: <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/30/2012 08:23 PM, Andreas Dilger wrote:
> On 2012-11-30, at 7:13 PM, Darren Hart wrote:
>> I am working on creating some files after creating a filesystem in
>> mke2fs. This is part of a larger project to add initial directory
>> support to mke2fs.
> 
> Maybe some background on what you are trying to do would help us to
> understand the problem?

Sure, a few are already aware, but I suppose some extra detail for the
first post to this list is in order.

I work on the Yocto Project, and this particular effort is part of
improving our deployment tooling. Specifically, the part of the build
process that creates the root filesystem.

Most all filesystems have some mechanism to create prepopulated images
without the need for root permissions. Many do this through a -r
parameter to their corresponding mkfs.* tool. The exceptions to this are
ext3 and ext4. Our current tooling relies on genext2fs and flipping some
bits to "convert" the ext2 filesystem to ext3 and 4. Not ideal.

After exploring options like libguestfs and finding them to be
considerably heavy weight for what we are trying to accomplish, I
discussed the possibility of adding an argument to mke2fs which would
populate a newly formatted filesystem from a specified directory. Ted
suggested a clean set of patches implementing this were likely to be
accepted.

I don't have much filesystem experience - most of my experience is with
core kernel mechanisms, ipc, locking, etc. - so I'm mostly hacking my
way to some basic functionality before refactoring. The libext2fs
library documentation gave me a good start, but I occasionally trip over
things like the problem described below as there is no documentation for
what I'm trying to do specifically (of course) and many of the required
functions are only minimally documented, and sometimes only listed in
the index.

The specific instance below is the result of me trying to format and
populate a filesystem image (in a file) from a root directory that looks
like this:

$ tree rootdir/
rootdir/
|-- dir1
|   |-- hello.lnk -> /hello.txt
|   `-- world.txt
|-- hello.lnk -> /hello.txt
|-- hello.txt
|-- sda
`-- ttyS0

$ cat rootdir/hello.txt
hello

In mke2fs.c I setup the new getopt argument and call nftw() with a
callback called init_dir_cb() which checks the file type and takes the
appropriate action to duplicate each entry. The exact code is here:

http://git.infradead.org/users/dvhart/e2fsprogs/blob/refs/heads/initialdir:/misc/mke2fs.c#l2319

As described below, when I update the inode.i_size after the initial
write and copying of the file content, the above cat command fails to
output anything when run on the loop mounted filesystem. If I just hack
in the i_size prior to writing the inode for the first time and don't
update it after copying the file content, then the cat command succeeds
as above on the loop mounted image.

The commented out inode write is noted here:

http://git.infradead.org/users/dvhart/e2fsprogs/blob/refs/heads/initialdir:/misc/mke2fs.c#l2462

Does that help clarify the situation?

What I'm looking for is some insight into what it is I am not
understanding about the filesystem structures that causes this behavior.

Thanks,

Darren

> 
> Cheers, Andreas
> 
>> To make it easy for people to see what I'm working
>> on, I've pushed my dev tree here:
>>
>> http://git.infradead.org/users/dvhart/e2fsprogs/shortlog/refs/heads/initialdir
>>
>> Note: the code is still just in the prototyping state. It is inelegant
>> to say the least. The git tree will most definitely rebase. I'm trying
>> to get it functional, once that is understand, I will refactor
>> appropriately.
>>
>> I can create a simple directory structure and link in files and fast
>> symlinks. I'm currently working on copying content from files in the
>> initial directory. The process I'm using is as follows:
>>
>>
>> ext2fs_new_inode(&ino)
>> ext2fs_link()
>>
>> ext2fs_read_inode(ino, &inode)
>> /* some initial inode setup */
>> ext2fs_write_new_inode(ino, &inode)
>>
>> ext2fs_file_open2(&inode)
>> ext2fs_write_file()
>> ext2fs_file_close()
>>
>> inode.i_size = bytes_written
>> ext2fs_write_inode()
>>
>> ext2fs_inode_alloc_stats2(ino)
>>
>>
>> When I mount the image, the size for the file is correct, by catting it
>> returns nothing. If I instead hack in the known size during the initial
>> inode setup and drop the last ext2fs_write_inode() call, then the size
>> is right and catting the file works as expected.
>>
>> Is it incorrect to write the inode more than once? If not, am I doing
>> something that is somehow decoupling the block where the data was
>> written from the inode associated with the file?
>>
>> Thanks,
>>
>> -- 
>> Darren Hart
>> Intel Open Source Technology Center
>> Yocto Project - Technical Lead - Linux Kernel
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
