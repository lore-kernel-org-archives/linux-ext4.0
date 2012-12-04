From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Tue, 4 Dec 2012 03:59:33 -0700
Message-ID: <E9A4182B-CEE4-419A-AE6B-F7133766ABC3@gmail.com>
References: <50B967E2.7090703@infradead.org> <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca> <50B990CB.3080607@infradead.org> <85A86E8F-EEB9-495C-AB10-EF3C871EE2B9@dilger.ca> <50BD017F.1070400@infradead.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45788 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2LDLEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 06:04:16 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so5893172ieb.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Dec 2012 03:04:15 -0800 (PST)
In-Reply-To: <50BD017F.1070400@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-12-03, at 12:46, Darren Hart <dvhart@infradead.org> wrote:
> 
> It needs symlink as you said, but I can relatively easily migrate my
> code for that in mke2fs to debugfs.
> 
> Still needs permissions and such. Is that done with "modify_inode" ? If
> so, how do I specify the new contents?

"modify_inode" is not a terribly easy use interface. Probably better to add something like "chmod" and "chown" for debugfs as well. 

> I need to look into how to detect and support hard links.

I was wondering about that, and hoped you wouldn't need them.  Maybe just keep a list if any files with nlink > 1 as { inode, pathname } as you go, and any inode with mlink > 1 are looked first in the duplicate list and the duplicate inode is hard linked to the original inode. 

Cheers, Andreas

>> This might be turned inside-out and just run a "find $SRCDIR" and
>> have the inner loop check the file type and call the appropriate
>> operation for it (mkdir, write/cp, mknod, symlink).  Note that
>> "find" will return the directories first, so this should be OK to
>> just consume the lines as they are output by find.
> 
> 
> Yes, this seems to work just fine.
> 
> 
>>> I don't have much filesystem experience - most of my experience is
>>> with core kernel mechanisms, ipc, locking, etc. - so I'm mostly
>>> hacking my way to some basic functionality before refactoring. The
>>> libext2fs library documentation gave me a good start, but I
>>> occasionally trip over things like the problem described below as
>>> there is no documentation for what I'm trying to do specifically
>>> (of course) and many of the required functions are only minimally
>>> documented, and sometimes only listed in the index.
>> 
>> Definitely, if the documentation is lacking and you've spent cycles
>> figuring something out, then a patch to improve the documentation is
>> most welcome.
> 
> 
> I plan to update this as I go... although I'm going to have much less to
> do if I use the debugfs approach. ;-)
> 
> I wonder if it would make sense to integrate the debugfs functionality
> into libext2fs and enable both debugfs and mke2fs to use the same common
> code. I think the "-r initialdir" option would still be nice to have for
> mke2fs, and does make it more consistent with other FSs in this feature.
> 
> 
>> 
>>> The specific instance below is the result of me trying to format and
>>> populate a filesystem image (in a file) from a root directory that looks like this:
>>> 
>>> $ tree rootdir/
>>> rootdir/
>>> |-- dir1
>>> |   |-- hello.lnk -> /hello.txt
>>> |   `-- world.txt
>>> |-- hello.lnk -> /hello.txt
>>> |-- hello.txt
>>> |-- sda
>>> `-- ttyS0
>>> 
>>> $ cat rootdir/hello.txt
>>> hello
>>> 
>>> In mke2fs.c I setup the new getopt argument and call nftw() with a
>>> callback called init_dir_cb() which checks the file type and takes
>>> the appropriate action to duplicate each entry. The exact code is at:
>> 
>> To be honest, ntfw() will drag a bunch of bloat into e2fsprogs that
>> doesn't exist today, and isn't really portable.
> 
> 
> OK, well it could also be done with ftw to be more portable, but I guess
> it's still marked obsolete in POSIX.1-2008 :/
> 
> Similar functionality could be implemented relatively easily.
> 
> 
>> 
>>> http://git.infradead.org/users/dvhart/e2fsprogs/blob/refs/heads/initialdir:/misc/mke2fs.c#l2319
>>> 
>>> As described below, when I update the inode.i_size after the initial
>>> write and copying of the file content, the above cat command fails to
>>> output anything when run on the loop mounted filesystem. If I just
>>> hack in the i_size prior to writing the inode for the first time and
>>> don't update it after copying the file content, then the cat command
>>> succeeds as above on the loop mounted image.
>> 
>> It probably makes sense to understand what is broken here, whether
>> it is the library or the program.  We definitely want to make sure
>> the API is usable and working correctly in any case.
> 
> 
> I should be able to compare with debugfs "write" and see what the
> difference is.
> 
> 
>> 
>>> The commented out inode write is noted here:
>>> 
>>> http://git.infradead.org/users/dvhart/e2fsprogs/blob/refs/heads/initialdir:/misc/mke2fs.c#l2462
>>> 
>>> Does that help clarify the situation?
>>> 
>>> What I'm looking for is some insight into what it is I am not
>>> understanding about the filesystem structures that causes this behavior.
>> 
>> I hate to put a downer on your current work, but I think that you
>> are adding something overly complex that only has a very limited
>> usefulness, and your time could be better spent elsewhere.
> 
> Not at all! I appreciate the tip. And it hasn't been wasted time, I've
> learned quite a bit, and as I said above, perhaps the debugfs copies and
> such can be pushed into libext2fs and used in both. ext2fs_mkdir()
> exists after all, why not ext2fs_mksymlink(), ext2fs_mknod() and
> ext2fs_writefile() ?
> 
> Thanks a lot for the insight, exactly what I needed!
> 
> --
> Darren
> 
>> 
>> [*] add debugfs "cp" command as an alias to "write":
>> 
>> diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
>> index a799dd7..3789dcd 100644
>> --- a/debugfs/debug_cmds.ct
>> +++ b/debugfs/debug_cmds.ct
>> @@ -119,7 +119,7 @@ request do_undel, "Undelete file",
>>        undelete, undel;
>> 
>> request do_write, "Copy a file from your native filesystem",
>> -       write;
>> +       write, cp;
>> 
>> request do_dump, "Dump an inode out to a file",
>>        dump_inode, dump;
>> 
>>> Thanks,
>>> 
>>> Darren
>>> 
>>>> 
>>>> Cheers, Andreas
>>>> 
>>>>> To make it easy for people to see what I'm working
>>>>> on, I've pushed my dev tree here:
>>>>> 
>>>>> http://git.infradead.org/users/dvhart/e2fsprogs/shortlog/refs/heads/initialdir
>>>>> 
>>>>> Note: the code is still just in the prototyping state. It is inelegant
>>>>> to say the least. The git tree will most definitely rebase. I'm trying
>>>>> to get it functional, once that is understand, I will refactor
>>>>> appropriately.
>>>>> 
>>>>> I can create a simple directory structure and link in files and fast
>>>>> symlinks. I'm currently working on copying content from files in the
>>>>> initial directory. The process I'm using is as follows:
>>>>> 
>>>>> 
>>>>> ext2fs_new_inode(&ino)
>>>>> ext2fs_link()
>>>>> 
>>>>> ext2fs_read_inode(ino, &inode)
>>>>> /* some initial inode setup */
>>>>> ext2fs_write_new_inode(ino, &inode)
>>>>> 
>>>>> ext2fs_file_open2(&inode)
>>>>> ext2fs_write_file()
>>>>> ext2fs_file_close()
>>>>> 
>>>>> inode.i_size = bytes_written
>>>>> ext2fs_write_inode()
>>>>> 
>>>>> ext2fs_inode_alloc_stats2(ino)
>>>>> 
>>>>> 
>>>>> When I mount the image, the size for the file is correct, by catting it
>>>>> returns nothing. If I instead hack in the known size during the initial
>>>>> inode setup and drop the last ext2fs_write_inode() call, then the size
>>>>> is right and catting the file works as expected.
>>>>> 
>>>>> Is it incorrect to write the inode more than once? If not, am I doing
>>>>> something that is somehow decoupling the block where the data was
>>>>> written from the inode associated with the file?
>>>>> 
>>>>> Thanks,
>>>>> 
>>>>> --
>>>>> Darren Hart
>>>>> Intel Open Source Technology Center
>>>>> Yocto Project - Technical Lead - Linux Kernel
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> 
>>>> 
>>>> Cheers, Andreas
>>>> 
>>>> 
>>>> 
>>>> 
>>>> 
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> 
>> Cheers, Andreas
>> 
>> 
>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
