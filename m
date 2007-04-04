From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][take 2] e2fsprogs: Add ext4migrate
Date: Wed, 04 Apr 2007 13:30:13 +0530
Message-ID: <46135B0D.7060301@linux.vnet.ibm.com>
References: <11755948452525-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20070403203252.GZ5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:38607 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992716AbXDDIAn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2007 04:00:43 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l348IVXu153270
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 18:18:31 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3483uvP122450
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 18:04:01 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3480OTI004720
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 18:00:24 +1000
In-Reply-To: <20070403203252.GZ5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Apr 03, 2007  15:37 +0530, Aneesh Kumar K.V wrote:
>> The extent insert code is derived out of the latest ext4 kernel
>> source. I have tried to keep the code as close as possible to the
>> kernel sources. This makes sure that any fixes for the tree building
>> code in kernel should be easily applied to ext4migrate.  The ext3_ext
>> naming convention instead of ext4_ext found in kernel is to make sure
>> we are in sync with rest of e2fsprogs source.
> 
> Of course, the other way to do this would be to temporarily mount the
> filesystem as ext4, copy non-extent files via "cp" (can use lsattr to
> check for extent flag) and then rename new file over old one.  Care
> must be taken to not mount filesystem on "visible" mountpoint, so that
> users cannot be changing the filesystem while copy is being done.
> 
> This can be done to convert an ext4 filesystem back to ext3 also, if
> the ext4 filesystem is mounted with "noextents" (to disable creation
> of new files with extent mapping).
> 
> The only minor issue is that the inode numbers of the files will change.
> 

One also need to make sure that the hard links are not broken by such
copy. Also when using copy we are touching the data blocks. And for
large files the copy operations could take quiet a lot of time. With the
patches I sent we are not touching/relocating the data blocks. We are
only converting the meta data. This results in a faster migration.




>> The inode modification is done only at the last stage. This is to make
>> sure that if we fail at any intermediate stage, we exit without touching
>> the disk.
>>
>> The inode update is done as below
>> a) Walk the extent index blocks and write them to the disk. If failed exit
>> b) Write the inode. if failed exit.
>> c) Write the updated block bitmap. if failed exit ( This could be a problem
>>    because we have already updated the inode i_block filed to point to new
>>    blocks.). But such inconsistancy between inode i_block and block bitmap
>>    can be fixed by fsck IIUC.
> 
> Why not mark all the relevant blocks in use (for both exent- and block-mapped
> copies) until the copy is done, then write everything out, and only mark the
> block-mapped file blocks free after the inode is written to disk?  This avoids
> the danger that the new extent-mapped file's blocks are marked free and get
> double-allocated (corrupting the file data, possibly the whole filesystem).
> 

Will do this .



> I don't think there is a guarantee that an impatient user will run a lengthy
> e2fsck after interrupting the migrate.  Also, you should mark the filesystem
> unclean at first change unless everything completes successfully.  That way
> e2fsck will at least run automatically on the next boot.
> 
> 


Will do this


> Other general notes:
> - wrap lines at 80 columns
> - would be good to have a "-R" mode that walked the whole filesystem,
>   since startup time is very long for large filesystems
> - also allow specifying multiple files on the command-line
> - changing the operation to be multi-file allows avoiding sync of bitmaps
>   two times (once after extents are allocated and inode written, once after
>   indirect blocks are freed).  There only needs to be one sync per file.
> 


Will do this in the next patch




-aneesh
