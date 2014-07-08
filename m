From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4: first write to large ext3 filesystem takes 96 seconds
Date: Mon, 7 Jul 2014 23:11:58 -0600
Message-ID: <E0178FE2-1C0C-4AF3-BA8C-3F32B4A4ACF7@dilger.ca>
References: <20140707211349.GA12478@kvack.org> <20140708001655.GI8254@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Benjamin LaHaise <bcrl@kvack.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54913 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaGHFMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2014 01:12:01 -0400
Received: by mail-pa0-f41.google.com with SMTP id fb1so6680310pad.14
        for <linux-ext4@vger.kernel.org>; Mon, 07 Jul 2014 22:12:01 -0700 (PDT)
In-Reply-To: <20140708001655.GI8254@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The main problem here is that reading all of the block bitmaps takes
a huge amount of time for a large filesystem.

7.8TB / 128MB/group ~= 8000 groups
8000 bitmaps / 100 seeks/sec = 80s

So that is what is making things slow. Once the allocator has all the
blocks in memory there are no problems. There are some heuristics
to skip bitmaps that are totally full, but they don't work in your case. 

This is why the flex_bg feature was created - to allow the bitmaps
to be read from disk without seeks.  This also speeds up e2fsck by
the same 96s that would otherwise be wasted waiting for the disk.

Backporting flex_bg to ext3 would be fairly trivial - just disable the checks
for the location of the bitmaps at mount time. However, using it
requires that you reformat your filesystem with "-O flex_bg" to
get the improved layout. 

The other option (if your runtime environment allows it) is to prefetch
the block bitmaps using "dumpe2fs /dev/XXX > /dev/null" before the
filesystem is in use. This still takes 90s, but can be started early in
the boot process on each disk in parallel.

Cheers, Andreas

> On Jul 7, 2014, at 18:16, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Mon, Jul 07, 2014 at 05:13:49PM -0400, Benjamin LaHaise wrote:s
>> Hi folks,
>> 
>> I've just ran into a bug with the ext4 codebase in 3.4.91 that doesn't seem 
>> to exist in ext3, and was wondering if anyone has encountered this before.  
>> I have a 7.4TB ext3 filesystem that has been filled with 1.8TB of data.  
>> When this filesystem is freshly mounted, the first write to the filesystem 
>> takes a whopping 96 seconds to complete, during which time the system is 
>> reading about 1000 blocks per second.  Subsequent writes are much quicker.  
>> The problem seems to be that ext4 is loading all of the bitmaps on the 
>> filesystem before the first write proceeds.  The backtrace looks roughly as 
>> follows:
> 
> So the issue is that ext3 will just allocate the first free block it
> can find, even if it is a single free block in block group #1001,
> followed by a single free block in block group #2002.  Ext4 tries a
> harder to find contiguous blocks.
> 
> If you are using an ext3 file system format, the block allocation
> bitmaps are scattered across the entire file system, so we end up
> doing a lot random 4k seeks.
> 
> We can try to be a bit smarter about how we try to search the file
> system for free blocks.
> 
> Out of curiosity, can you send me a copy of the contents of:
> 
> /proc/fs/ext4/dm-XX/mb_groups
> 
> Thanks!!
> 
>                    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
