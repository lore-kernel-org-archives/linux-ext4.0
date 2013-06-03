From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filesystem state: clean with errors - what errors?
Date: Mon, 03 Jun 2013 14:13:51 -0500
Message-ID: <51ACEAEF.6040109@redhat.com>
References: <CADzUK1K08XjYuz_Mrv6sF8e7-M9ToStfjN7e7s3v+2q9wX+-xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Autif Khan <autif.mlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab3FCTNy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jun 2013 15:13:54 -0400
In-Reply-To: <CADzUK1K08XjYuz_Mrv6sF8e7-M9ToStfjN7e7s3v+2q9wX+-xQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/3/13 1:45 PM, Autif Khan wrote:
> Executing dumpe2fs -h on one of the partitions says
> 
> ...
> Filesystem features:      has_journal ext_attr resize_inode dir_index
> filetype extent flex_bg sparse_super large_file huge_file uninit_bg
> dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash
> Default mount options:    user_xattr acl
> Filesystem state:         clean with errors
> ...
> 
> How can I find out what the errors are - the details of the errors.

"clean" means the log has been replayed (log is not dirty)
"with errors" means that it encountered concistency errors at runtime

run e2fsck -f on it to see what it finds (or e2fsck -fn if you want a no-op
dry run)

-Eric

> Thanks
> 
> Autif
> 
> Some more logs (I am not sure I see an error here):
> 
> Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
>   Checksum 0xc4c7, unused inodes 0
>   Primary superblock at 0, Group descriptors at 1-1
>   Reserved GDT blocks at 2-256
>   Block bitmap at 257 (+257), Inode bitmap at 273 (+273)
>   Inode table at 289-800 (+289)
>   21467 free blocks, 0 free inodes, 1834 directories
>   Free blocks: 11301-32767
>   Free inodes:
> Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
>   Checksum 0xc9c2, unused inodes 623
>   Backup superblock at 32768, Group descriptors at 32769-32769
>   Reserved GDT blocks at 32770-33024
>   Block bitmap at 258 (bg #0 + 258), Inode bitmap at 274 (bg #0 + 274)
>   Inode table at 801-1312 (bg #0 + 801)
>   0 free blocks, 623 free inodes, 974 directories, 623 unused inodes
>   Free blocks:
>   Free inodes: 15762-16384
> Group 2: (Blocks 65536-98303) [INODE_UNINIT, ITABLE_ZEROED]
> ...
> Group 16: (Blocks 524288-557055) [ITABLE_ZEROED]
>   Checksum 0xcee5, unused inodes 0
>   Block bitmap at 524288 (+0), Inode bitmap at 524304 (+16)
>   Inode table at 524320-524831 (+32)
>   22714 free blocks, 0 free inodes, 1672 directories
>   Free blocks: 534342-557055
>   Free inodes:
> Group 17: (Blocks 557056-589823) [ITABLE_ZEROED]
>   Checksum 0x9983, unused inodes 7375
>   Block bitmap at 524289 (bg #16 + 1), Inode bitmap at 524305 (bg #16 + 17)
>   Inode table at 524832-525343 (bg #16 + 544)
>   16730 free blocks, 7375 free inodes, 140 directories, 7375 unused inodes
>   Free blocks: 557571-558079, 565411-573439, 581632-589823
>   Free inodes: 140082-147456
> Group 18: (Blocks 589824-622591) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
> ...
> 
> Everything else is INODE_UNINIT
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

