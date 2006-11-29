From: Girish Shilamkar <girish@clusterfs.com>
Subject: Re: [RFC][PATCH 0/3] Extent base online defrag
Date: Wed, 29 Nov 2006 15:57:46 +0530
Message-ID: <1164796066.3251.8.camel@alpha.linsyssoft.com>
References: <20061109200950sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43191 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S966874AbWK2KWb
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 05:22:31 -0500
To: sho@tnes.nec.co.jp
In-Reply-To: <20061109200950sho@rifu.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
I tried to use defrag utility. But these are the results that, I got:

[root@metis e4defrag]# ./defrag /dev/hda8
Start defragment for device(/dev/hda8)
        Total:                   393
        Success:                   0 
        Failure:                 393
[root@metis e4defrag]# ./defrag /mnt/test1/root
Start defragment for directory(/mnt/test1/root)
        Total:                   392
        Success:                   0
        Failure:                 392
I tried same thing with different directories and files, but the result
was the same.
By doing strace on defrag utility I found that ioctl always returned
ENOSPC. So I decreased the no. files, but still that didn't help, I came
down till filesystem was only 9% full.

[root@metis test2]# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda3             15116868   9762924   4586040  69% /
tmpfs                   224880         0    224880   0% /dev/shm
/dev/hda1              2016016     17940   1895664   1% /boot
/dev/hda2             20161204   1364752  17772312   8% /mnt/store
/dev/hda9             15116868   9762924   4586040  69% /mnt/test1
/dev/hda10              972532     78136    844196   9% /mnt/test2
[root@metis ~]# ./e4defrag/defrag /dev/hda10
Start defragment for device(/dev/hda10)
        Total:                  4426
        Success:                   0
        Failure:                4426
[root@metis ~]# ./e4defrag/defrag  /mnt/test2/
dir/          linux-2.6.12/ 
[root@metis ~]# ./e4defrag/defrag  /mnt/test2/linux-2.6.12/
arch/          crypto/        Documentation/ drivers/       MAINTAINERS
Makefile       
[root@metis ~]# ./e4defrag/defrag  /mnt/test2/linux-2.6.12/Makefile 
Start defragment for /mnt/test2/linux-2.6.12/Makefile
        e4defrag  : defrag fail.: No space left on device
                    "/mnt/test2/linux-2.6.12/Makefile"


I was using linux kernel 2.6.16.8. I applied Alex's mballoc patches and
then your defrag patches.. 
Another thing, I changed one line in the defrag utility code.
-#define FS_EXT3                 "ext4dev"
+#define FS_EXT3                 "ext3"

I did mount the filesystem with mballoc and extents options.

Any ideas ?

Thanks & Regards,
Girish.



On Thu, 2006-11-09 at 20:09 +0900, sho@tnes.nec.co.jp wrote: 
> Hi,
> 
> >I am considering the online defrag function for ext4 and thinking
> >that your following patch set for multi-block allocation is useful
> >to search contiguous free blocks for the defragmentation.
> >
> >"[RFC] extents,mballoc,delalloc for 2.6.16.8"
> >http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2
> >
> >I will send the patch of simple defrag implementation for ext4 later.
> 
> I have written the patches of ioctl for extent base online defragment
> and the command which call it.
> These patches are at the experimental stage so they need many
> improvements.  But they work well so far as basic defragmenter,
> which means they are worth enough to examine my trial.
> 
> - Specify the target area in a file using the following structure:
>   struct ext3_ext_defrag_data {
> 	  loff_t start_offset; /* start offset to defrag in bytes */
> 	  loff_t defrag_size;  /* size of defrag in bytes */
>   }
>   It uses loff_t so that the size of the structure is identical on
>   both 32 bits and 64 bits architecture.
>   Block allocation, including searching for the free contiguous
>   blocks, is implemented in kernel.
>   
> - The procedures for the defragment in kernel are as follows:
>   Blocks are allocated for the temporary inode by 16384 pages
>   and the block on the temporary inode is moved to the original inode
>   by a page.  I think I need to tune the above pages unit
>   for the performance.  It's in my TODO list.
>   1. Allocate blocks for the temporary inode.
>   2. Move the blocks on the temporary inode to the original inode
>      by a page.
>      2.1 Read the file data from the old blocks to the page
>      2.2 Move the block on the temporary inode to the original inode
>      2.3 Write the file data on the page into the new blocks
> 
> - Currently, this patch works only for ext3 because it needs
>   Alex Tomas's ext3 multi-block allocation patch which is for 2.6.16.8.
>   "[RFC] extents,mballoc,delalloc for 2.6.16.8"
>   http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2
>   But, my target is the defragment for ext4.  So I hope to start
>   the work for ext4 soon.
> 
> - On block allocation for the temporary inode(ext3_ext_new_extent_tree()),
>   the number of the modified blocks for metadata(extent block) is
>   calculated in ext3_ext_writepage_trans_blocks().  As the resulting
>   value can exceed the max blocks for the transaction(2048), passing
>   2048 directly to ext3_journal_start() for the provisional solution.
>   It's in my TODO list.
> 
> - They don't support the following:
>   - Not support the indirect block file(only for the extent file).
>   - Not optimize the depth of extent tree and the number of
>     extent blocks after defragmentation.
>   - Not support quota.
>   - Not support a hole file.
>   These are also in my TODO list.
> 
> Summary Of Patches:
> *These patches apply on top of above Alex's patches.
> 
> [PATCH 1/3] Allocate new contiguous blocks with Alex's mballoc
> - Search contiguous free blocks and allocate them for the temporary
>   inode with Alex's multi-block allocation.
> 
> [PATCH 2/3] Move the file data to the new blocks
> - Move the blocks on the temporary inode to the original inode
>   by a page.
> 
> [PATCH 3/3] Online defrag command
> - The defrag command.  Usage is as follows:
>   o Defrag for a file.
>     # e4defrag file-name
>   o Defrag for all files on ext3.
>     # e4defrag device-name
> 
> I created 50 fragmented files of 1GB and ran e4defrag for each of them.
> As a result, I got the following improvement.
> "Fragments" is the total number of fragments on 50 files.
> "I/O performance" is the elapsed time for reading 50 files
> with "cat" command(cat file* > /dev/null). 
> 
>                    Before defrag    After defrag 
> ---------------------------------------------------------------------
> Fragments                  12175             800
> I/O performance(Second)    618.3           460.6(25% improvement!!)
> 
> Any comments are welcome.
> Cheers, Takashi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
