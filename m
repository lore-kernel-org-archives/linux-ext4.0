From: Timofey Titovets <nefelim4ag@gmail.com>
Subject: Re: Question about EXT4_IOC_MOVE_EXT
Date: Mon, 21 Jul 2014 18:24:07 +0300
Message-ID: <CAGqmi754na+yDkOhvkV9n+tQfiwhF6q2vBwWQMPy8Xv+UuggQw@mail.gmail.com>
References: <CAGqmi74q4fu38gqCGuy3a1-YB5tjZywThXZCHj+3U0gSua9YhQ@mail.gmail.com>
 <87tx6bf0sj.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42993 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbaGUPYa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2014 11:24:30 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so4287205wib.10
        for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2014 08:24:27 -0700 (PDT)
In-Reply-To: <87tx6bf0sj.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sounds great! I wait while you complete your work (I'll be watching
mailing list), after you send a patch where be example (i think in
e4defrag2.c), i will port your functions in readahead.
Thanks for efforts.

2014-07-21 13:45 GMT+03:00 Dmitry Monakhov <dmonakhov@openvz.org>:
> On Sun, 20 Jul 2014 13:16:45 +0300, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>> Good time of day, i am working for optimization of readahead in
>> systemd and now, i try to implement EXT4_IOC_MOVE_EXT ioctl. I have
>> several questions:
>>
>> 1. In fs every file has a file descriptor, file descriptor is a
>> integer number. Can we say what, by file descriptor, we can determine
>> order of files where he places on a disk?
>> As example: a - 5; b - 54; c - 31; d - 20;
>> This mean what files place order like:
>> start of disk -> a -> d ->  c -> b -> end of disk
>> and if i swap files by EXT4_IOC_MOVE_EXT, i can reorder it to:
>> start of disk -> a -> b -> c -> d -> end of disk
>> This is true?
> No. filedescriptor num absolutely not related with disk layout.
> inode number has some relationship with disk layout (allocator
> try to allocate blocks from same group see fs/ext4/mballoc.c)
>
>>
>> 2. Can i pack files in custom order on a disk? (i have order of
>> accessing files on a disk, and i want place him in accessing order
>> like e4rat project do)
>> If yes, how? May be we have ioctl call or e2fsprogs has realisation of this?
>> ( e4rat as i understand by looking source, patch kernel, to get
>> features of files reorder)
> At this moment no. But I'm working on that, it requires
> Kernel part: remove artificial restriction where orig_start == donor_start
>              this restriction do not allow to pack small files to one
>              cluster.
>
>
> userspace part: new version of e4defrag which allow to pack small files
>                 effectively.
>
> At this moment size is looks like follows:
>  fs/ext4/ext4.h        |    4 +
>  fs/ext4/extents.c     |  204 +++++++++++-
>  fs/ext4/move_extent.c |  901 ++++++-------------------------------------------
> Userspace:
>  Makefile.in               |   28
>  e4defrag2-assupmtions.org |   22
>  e4defrag2.8               |   80 +
>  e4defrag2.8.in            |   80 +
>  e4defrag2.c               | 2486 ++++++++++++++++++++++++++++++++++++++++++++++
>
> So testing is moved slow. I hope I can send first version today.
>
>> 3. In
>> struct move_extent {
>>     __s32 reserved;    /* original file descriptor */
>>     __u32 donor_fd;    /* donor file descriptor */
>>     __u64 orig_start;  /* logical start offset in block for orig */
>>     __u64 donor_start; /* logical start offset in block for donor */
>>     __u64 len;         /* block length to be moved */
>>     __u64 moved_len;   /* moved block length */
>> };
>> Can i ignore (not set) orig_start, donor_start, len, moved_len?
>> What happen if i set it by zeros?
> same as youcall pwrite(fd,buf, 0,0), nothing. If you have asked
> to exchange ZERO bytes it will be hapy to do nothing :).
>> if i move original file descriptor to file descriptor with zero size
>> of file, what happen? or in begger file donor then original?
> If both files has zero size that again nothing will happen, but EINVAL
> will be returned.
> If donor is bigger than original it will swap extents untill
> orig->i_size.
>
>>
>> -----
>> Best regards,
>> Timofey.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
Timofey.
