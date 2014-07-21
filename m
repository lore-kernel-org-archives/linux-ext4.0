From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Question about EXT4_IOC_MOVE_EXT
Date: Mon, 21 Jul 2014 14:45:16 +0400
Message-ID: <87tx6bf0sj.fsf@openvz.org>
References: <CAGqmi74q4fu38gqCGuy3a1-YB5tjZywThXZCHj+3U0gSua9YhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:65436 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaGUKpU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2014 06:45:20 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so3801414lbi.29
        for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2014 03:45:19 -0700 (PDT)
In-Reply-To: <CAGqmi74q4fu38gqCGuy3a1-YB5tjZywThXZCHj+3U0gSua9YhQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 20 Jul 2014 13:16:45 +0300, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> Good time of day, i am working for optimization of readahead in
> systemd and now, i try to implement EXT4_IOC_MOVE_EXT ioctl. I have
> several questions:
> 
> 1. In fs every file has a file descriptor, file descriptor is a
> integer number. Can we say what, by file descriptor, we can determine
> order of files where he places on a disk?
> As example: a - 5; b - 54; c - 31; d - 20;
> This mean what files place order like:
> start of disk -> a -> d ->  c -> b -> end of disk
> and if i swap files by EXT4_IOC_MOVE_EXT, i can reorder it to:
> start of disk -> a -> b -> c -> d -> end of disk
> This is true?
No. filedescriptor num absolutely not related with disk layout.
inode number has some relationship with disk layout (allocator
try to allocate blocks from same group see fs/ext4/mballoc.c)

> 
> 2. Can i pack files in custom order on a disk? (i have order of
> accessing files on a disk, and i want place him in accessing order
> like e4rat project do)
> If yes, how? May be we have ioctl call or e2fsprogs has realisation of this?
> ( e4rat as i understand by looking source, patch kernel, to get
> features of files reorder)
At this moment no. But I'm working on that, it requires
Kernel part: remove artificial restriction where orig_start == donor_start
             this restriction do not allow to pack small files to one
             cluster.
  

userspace part: new version of e4defrag which allow to pack small files
                effectively.

At this moment size is looks like follows:
 fs/ext4/ext4.h        |    4 +
 fs/ext4/extents.c     |  204 +++++++++++-
 fs/ext4/move_extent.c |  901 ++++++-------------------------------------------
Userspace:
 Makefile.in               |   28 
 e4defrag2-assupmtions.org |   22 
 e4defrag2.8               |   80 +
 e4defrag2.8.in            |   80 +
 e4defrag2.c               | 2486 ++++++++++++++++++++++++++++++++++++++++++++++

So testing is moved slow. I hope I can send first version today.

> 3. In
> struct move_extent {
>     __s32 reserved;    /* original file descriptor */
>     __u32 donor_fd;    /* donor file descriptor */
>     __u64 orig_start;  /* logical start offset in block for orig */
>     __u64 donor_start; /* logical start offset in block for donor */
>     __u64 len;         /* block length to be moved */
>     __u64 moved_len;   /* moved block length */
> };
> Can i ignore (not set) orig_start, donor_start, len, moved_len?
> What happen if i set it by zeros?
same as youcall pwrite(fd,buf, 0,0), nothing. If you have asked
to exchange ZERO bytes it will be hapy to do nothing :).
> if i move original file descriptor to file descriptor with zero size
> of file, what happen? or in begger file donor then original?
If both files has zero size that again nothing will happen, but EINVAL
will be returned.
If donor is bigger than original it will swap extents untill
orig->i_size.

> 
> -----
> Best regards,
> Timofey.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
