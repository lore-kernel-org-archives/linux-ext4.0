From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] e2fsprogs: Add rbtree backend for bitmaps, use it instead of bitarrays
Date: Mon, 10 Jan 2011 09:43:10 -0700
Message-ID: <40C8AC78-8196-41BE-B1BB-B1FB96D209C7@dilger.ca>
References: <1294672737-10850-1-git-send-email-lczerner@redhat.com> <1294672737-10850-3-git-send-email-lczerner@redhat.com> <9268E343-A1FD-410D-8C4F-40976B233634@dilger.ca>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"sandeen@redhat.com" <sandeen@redhat.com>,
	"kalpak@clogeny.com" <kalpak@clogeny.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63980 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1AJQmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jan 2011 11:42:40 -0500
In-Reply-To: <9268E343-A1FD-410D-8C4F-40976B233634@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, hit send by accident. 

On 2011-01-10, at 8:18, Lukas Czerner <lczerner@redhat.com> wrote:
>> This commit adds another backend to store bitmaps. It is based on
>> rbtrees and it stores just used extents of bitmaps. It means that it can
>> be more memory efficient in most cases and also with a careful use it
>> might be much faster than simple bitarrays.
>> 
>> 
>> @@ -66,7 +66,7 @@ errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
>>   if (fs->flags & EXT2_FLAG_64BITS)
>>       return (ext2fs_alloc_generic_bmap(fs,
>>                 EXT2_ET_MAGIC_INODE_BITMAP64,
>> -                  EXT2FS_BMAP64_BITARRAY,
>> +                  EXT2FS_BMAP64_RBTREE,
>>                 start, end, real_end, descr, ret));
> 

It would be really useful to allow runtime selection of bitmap type, ideally separately for block and inode bitmaps. This will allow easier testing of this patch on different filesystems, as well as allow users to select the bitmap the type for performance over space, if they have plenty of memory. 

Perhaps in the future by default e2fsck can select one type based on system memory vs. filesystem size?  That will be important if there continues to be a performance gap between the two types. 

>> +/*
>> 
>> +/*#define DEBUG*/
>> +
>> +#ifdef DEBUG
>> +static void print_tree(struct rb_root *root)

Probably should be DEBUG_RB or similar to allow separate enabling from other debug. 

Cheers, Andreas