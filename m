From: Darren Hart <dvhart@infradead.org>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Tue, 04 Dec 2012 09:42:10 -0800
Message-ID: <50BE35F2.9050309@infradead.org>
References: <50B967E2.7090703@infradead.org> <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca> <50B990CB.3080607@infradead.org> <85A86E8F-EEB9-495C-AB10-EF3C871EE2B9@dilger.ca> <50BD017F.1070400@infradead.org> <CAGBYx2bizxVsWx=rAARef=+cR2oq2+f0dG33Y2KYqCVajmvnBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:23664 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab2LDRmP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 12:42:15 -0500
In-Reply-To: <CAGBYx2bizxVsWx=rAARef=+cR2oq2+f0dG33Y2KYqCVajmvnBQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 12/04/2012 02:45 AM, Yongqiang Yang wrote:
> Hi,
> 
> If original images are ext4 format, this can be done by writing the
> image to a new device and resizing the new device via resizefs.

I don't follow... what can be done using resizefs?

--
Darren

> 
> Yongqiang,
> Thanks,
> 
> On Tue, Dec 4, 2012 at 3:46 AM, Darren Hart <dvhart@infradead.org> wrote:
>> On 12/01/2012 11:31 AM, Andreas Dilger wrote:
>>> On 2012-11-30, at 10:08 PM, Darren Hart wrote:
>>>> On 11/30/2012 08:23 PM, Andreas Dilger wrote:
>>>>> On 2012-11-30, at 7:13 PM, Darren Hart wrote:
>>>>>> I am working on creating some files after creating a filesystem in
>>>>>> mke2fs. This is part of a larger project to add initial directory
>>>>>> support to mke2fs.
>>>>>
>>>>> Maybe some background on what you are trying to do would help us to
>>>>> understand the problem?
>>>>
>>>> Sure, a few are already aware, but I suppose some extra detail for
>>>> the first post to this list is in order.
>>>>
>>>> I work on the Yocto Project, and this particular effort is part of
>>>> improving our deployment tooling. Specifically, the part of the build
>>>> process that creates the root filesystem.
>>>>
>>>> Most all filesystems have some mechanism to create prepopulated
>>>> images without the need for root permissions. Many do this through
>>>> a -r parameter to their corresponding mkfs.* tool. The exceptions to
>>>> this are ext3 and ext4. Our current tooling relies on genext2fs and
>>>> flipping some bits to "convert" the ext2 filesystem to ext3 and 4.
>>>> Not ideal.
>>>>
>>>> After exploring options like libguestfs and finding them to be
>>>> considerably heavy weight for what we are trying to accomplish, I
>>>> discussed the possibility of adding an argument to mke2fs which would
>>>> populate a newly formatted filesystem from a specified directory. Ted
>>>> suggested a clean set of patches implementing this were likely to be
>>>> accepted.
>>>
>>> Hmm, I wonder if libext2fs can itself create extent-mapped files,
>>> or if these files will be block-mapped?  If they are small (< 1MB),
>>> it is probably not a huge problem, but if your files are large it
>>> may be that libext2fs also creates "ext2" files internally?
>>>
>>> Maybe Ted can confirm whether that is true or not.  At least I recall
>>> that the block allocator inside libext2fs was horrible, and creating
>>> large files was problematic.
>>
>>
>> Ted, can you confirm?
>>
>>
>>> I guess the other question is why you don't use debugfs to create
>>> the directory tree and copy the files into your new filesystem?
>>> It already has "mkdir", "mknod" and "write" commands for use, and
>>> it is a one-line patch to alias "write" to "cp" for easier use[*].
>>
>>
>> I just didn't know about it and it didn't come up in my polling :-)
>> (which would have been more fruitful had I done some of that here).
>>
>>
>>> Then, it just needs a debugfs script to build your directory tree
>>> and copy files over.  Possibly enhancing "cp" to call do_mknod() for
>>> pipe/block/char devices would make this easier to use.
>>>
>>> Something like the following, though it seems there isn't an "ln -s"
>>> or "symlink" command for debugfs yet, that would need to be written.
>>>
>>> #!/bin/bash
>>> SRCDIR=$1
>>> DEVICE=$2
>>>
>>> {
>>>       find $SRCDIR | while read FILE; do
>>>               TGT=${FILE#$SRCDIR}
>>>               case $(stat -c "%F" $FILE) in
>>>               "directory")
>>>                       echo "mkdir $TGT"
>>>                       ;;
>>>               "regular file")
>>>                       echo "write $FILE $TGT"
>>>                       ;;
>>>               "symbolic link")
>>>                       LINK_TGT=$(ls -l $FILE | sed -e 's/.*-> //')
>>>                       echo "symlink $TGT $LINK_TGT"
>>>                       ;;
>>>               "block special file")
>>>                       DEVNO=$(stat -c "%t %T" $FILE)
>>>                       echo "mknod $F $DEVNO $TGT
>>>                       ;;
>>>               "character special file")
>>>                       DEVNO=$(stat -c "%t %T" $FILE)
>>>                       echo "mknod $TYPE $DEVNO $TGT
>>>                       ;;
>>>               *)
>>>                       echo "Unknown file $FILE" 1>&2
>>>                       ;;
>>>               done
>>>       done
>>> } | debugfs -w -f /dev/stdin $device
>>
>>
>> This is really promising. I've tweaked it a bit to use the basename and
>> cd into the directories as they are traversed by find so it doesn't try
>> and create filenames like "/dir1/hello.txt" in the root directory.
>>
>>         #!/bin/sh
>>         SRCDIR=$1
>>         DEVICE=$2
>>
>>         {
>>                 find $SRCDIR | while read FILE; do
>>                         #TGT=${FILE#$SRCDIR}
>>                         TGT=$(basename ${FILE#$SRCDIR})
>>
>>                         # Skip the root dir
>>                         if [ -z "$TGT" ]; then
>>                                 continue
>>                         fi
>>
>>                         case $(stat -c "%F" $FILE) in
>>                         "directory")
>>                                 echo "mkdir $TGT"
>>                                 echo "cd $TGT"
>>                                 ;;
>>                         "regular file")
>>                                 echo "write $FILE $TGT"
>>                                 ;;
>>                         "symbolic link")
>>                                 LINK_TGT=$(ls -l $FILE | sed -e 's/.*-> //')
>>                                 echo "symlink $TGT $LINK_TGT"
>>                                 ;;
>>                         "block special file")
>>                                 DEVNO=$(stat -c "%t %T" $FILE)
>>                                 echo "mknod $TGT b $DEVNO"
>>                                 ;;
>>                         "character special file")
>>                                 DEVNO=$(stat -c "%t %T" $FILE)
>>                                 echo "mknod $TGT c $DEVNO"
>>                                 ;;
>>                         *)
>>                                 echo "Unknown file $FILE" 1>&2
>>                                 ;;
>>                         esac
>>                 done
>>         } | debugfs -w -f /dev/stdin $DEVICE
>>
>>
>>> I would guess that implementing "symlink" support in debugfs will
>>> be orders of magnitude less work, maintenance, and bugs than your
>>> current patch.
>>
>>
>> It needs symlink as you said, but I can relatively easily migrate my
>> code for that in mke2fs to debugfs.
>>
>> Still needs permissions and such. Is that done with "modify_inode" ? If
>> so, how do I specify the new contents?
>>
>> I need to look into how to detect and support hard links.
>>
>>
>>> This might be turned inside-out and just run a "find $SRCDIR" and
>>> have the inner loop check the file type and call the appropriate
>>> operation for it (mkdir, write/cp, mknod, symlink).  Note that
>>> "find" will return the directories first, so this should be OK to
>>> just consume the lines as they are output by find.
>>
>>
>> Yes, this seems to work just fine.
>>
>>
>>>> I don't have much filesystem experience - most of my experience is
>>>> with core kernel mechanisms, ipc, locking, etc. - so I'm mostly
>>>> hacking my way to some basic functionality before refactoring. The
>>>> libext2fs library documentation gave me a good start, but I
>>>> occasionally trip over things like the problem described below as
>>>> there is no documentation for what I'm trying to do specifically
>>>> (of course) and many of the required functions are only minimally
>>>> documented, and sometimes only listed in the index.
>>>
>>> Definitely, if the documentation is lacking and you've spent cycles
>>> figuring something out, then a patch to improve the documentation is
>>> most welcome.
>>
>>
>> I plan to update this as I go... although I'm going to have much less to
>> do if I use the debugfs approach. ;-)
>>
>> I wonder if it would make sense to integrate the debugfs functionality
>> into libext2fs and enable both debugfs and mke2fs to use the same common
>> code. I think the "-r initialdir" option would still be nice to have for
>> mke2fs, and does make it more consistent with other FSs in this feature.
>>
>>
>>>
>>>> The specific instance below is the result of me trying to format and
>>>> populate a filesystem image (in a file) from a root directory that looks like this:
>>>>
>>>> $ tree rootdir/
>>>> rootdir/
>>>> |-- dir1
>>>> |   |-- hello.lnk -> /hello.txt
>>>> |   `-- world.txt
>>>> |-- hello.lnk -> /hello.txt
>>>> |-- hello.txt
>>>> |-- sda
>>>> `-- ttyS0
>>>>
>>>> $ cat rootdir/hello.txt
>>>> hello
>>>>
>>>> In mke2fs.c I setup the new getopt argument and call nftw() with a
>>>> callback called init_dir_cb() which checks the file type and takes
>>>> the appropriate action to duplicate each entry. The exact code is at:
>>>
>>> To be honest, ntfw() will drag a bunch of bloat into e2fsprogs that
>>> doesn't exist today, and isn't really portable.
>>
>>
>> OK, well it could also be done with ftw to be more portable, but I guess
>> it's still marked obsolete in POSIX.1-2008 :/
>>
>> Similar functionality could be implemented relatively easily.
>>
>>
>>>
>>>> http://git.infradead.org/users/dvhart/e2fsprogs/blob/refs/heads/initialdir:/misc/mke2fs.c#l2319
>>>>
>>>> As described below, when I update the inode.i_size after the initial
>>>> write and copying of the file content, the above cat command fails to
>>>> output anything when run on the loop mounted filesystem. If I just
>>>> hack in the i_size prior to writing the inode for the first time and
>>>> don't update it after copying the file content, then the cat command
>>>> succeeds as above on the loop mounted image.
>>>
>>> It probably makes sense to understand what is broken here, whether
>>> it is the library or the program.  We definitely want to make sure
>>> the API is usable and working correctly in any case.
>>
>>
>> I should be able to compare with debugfs "write" and see what the
>> difference is.
>>
>>
>>>
>>>> The commented out inode write is noted here:
>>>>
>>>> http://git.infradead.org/users/dvhart/e2fsprogs/blob/refs/heads/initialdir:/misc/mke2fs.c#l2462
>>>>
>>>> Does that help clarify the situation?
>>>>
>>>> What I'm looking for is some insight into what it is I am not
>>>> understanding about the filesystem structures that causes this behavior.
>>>
>>> I hate to put a downer on your current work, but I think that you
>>> are adding something overly complex that only has a very limited
>>> usefulness, and your time could be better spent elsewhere.
>>
>> Not at all! I appreciate the tip. And it hasn't been wasted time, I've
>> learned quite a bit, and as I said above, perhaps the debugfs copies and
>> such can be pushed into libext2fs and used in both. ext2fs_mkdir()
>> exists after all, why not ext2fs_mksymlink(), ext2fs_mknod() and
>> ext2fs_writefile() ?
>>
>> Thanks a lot for the insight, exactly what I needed!
>>
>> --
>> Darren
>>
>>>
>>> [*] add debugfs "cp" command as an alias to "write":
>>>
>>> diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
>>> index a799dd7..3789dcd 100644
>>> --- a/debugfs/debug_cmds.ct
>>> +++ b/debugfs/debug_cmds.ct
>>> @@ -119,7 +119,7 @@ request do_undel, "Undelete file",
>>>         undelete, undel;
>>>
>>>  request do_write, "Copy a file from your native filesystem",
>>> -       write;
>>> +       write, cp;
>>>
>>>  request do_dump, "Dump an inode out to a file",
>>>         dump_inode, dump;
>>>
>>>> Thanks,
>>>>
>>>> Darren
>>>>
>>>>>
>>>>> Cheers, Andreas
>>>>>
>>>>>> To make it easy for people to see what I'm working
>>>>>> on, I've pushed my dev tree here:
>>>>>>
>>>>>> http://git.infradead.org/users/dvhart/e2fsprogs/shortlog/refs/heads/initialdir
>>>>>>
>>>>>> Note: the code is still just in the prototyping state. It is inelegant
>>>>>> to say the least. The git tree will most definitely rebase. I'm trying
>>>>>> to get it functional, once that is understand, I will refactor
>>>>>> appropriately.
>>>>>>
>>>>>> I can create a simple directory structure and link in files and fast
>>>>>> symlinks. I'm currently working on copying content from files in the
>>>>>> initial directory. The process I'm using is as follows:
>>>>>>
>>>>>>
>>>>>> ext2fs_new_inode(&ino)
>>>>>> ext2fs_link()
>>>>>>
>>>>>> ext2fs_read_inode(ino, &inode)
>>>>>> /* some initial inode setup */
>>>>>> ext2fs_write_new_inode(ino, &inode)
>>>>>>
>>>>>> ext2fs_file_open2(&inode)
>>>>>> ext2fs_write_file()
>>>>>> ext2fs_file_close()
>>>>>>
>>>>>> inode.i_size = bytes_written
>>>>>> ext2fs_write_inode()
>>>>>>
>>>>>> ext2fs_inode_alloc_stats2(ino)
>>>>>>
>>>>>>
>>>>>> When I mount the image, the size for the file is correct, by catting it
>>>>>> returns nothing. If I instead hack in the known size during the initial
>>>>>> inode setup and drop the last ext2fs_write_inode() call, then the size
>>>>>> is right and catting the file works as expected.
>>>>>>
>>>>>> Is it incorrect to write the inode more than once? If not, am I doing
>>>>>> something that is somehow decoupling the block where the data was
>>>>>> written from the inode associated with the file?
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> --
>>>>>> Darren Hart
>>>>>> Intel Open Source Technology Center
>>>>>> Yocto Project - Technical Lead - Linux Kernel
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>> Cheers, Andreas
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>> Cheers, Andreas
>>>
>>>
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> Best Wishes
> Yongqiang Yang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
