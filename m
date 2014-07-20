From: Timofey Titovets <nefelim4ag@gmail.com>
Subject: Question about EXT4_IOC_MOVE_EXT
Date: Sun, 20 Jul 2014 13:16:45 +0300
Message-ID: <CAGqmi74q4fu38gqCGuy3a1-YB5tjZywThXZCHj+3U0gSua9YhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49930 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaGTKRH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Jul 2014 06:17:07 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so5200462wgh.2
        for <linux-ext4@vger.kernel.org>; Sun, 20 Jul 2014 03:17:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Good time of day, i am working for optimization of readahead in
systemd and now, i try to implement EXT4_IOC_MOVE_EXT ioctl. I have
several questions:

1. In fs every file has a file descriptor, file descriptor is a
integer number. Can we say what, by file descriptor, we can determine
order of files where he places on a disk?
As example: a - 5; b - 54; c - 31; d - 20;
This mean what files place order like:
start of disk -> a -> d ->  c -> b -> end of disk
and if i swap files by EXT4_IOC_MOVE_EXT, i can reorder it to:
start of disk -> a -> b -> c -> d -> end of disk
This is true?

2. Can i pack files in custom order on a disk? (i have order of
accessing files on a disk, and i want place him in accessing order
like e4rat project do)
If yes, how? May be we have ioctl call or e2fsprogs has realisation of this?
( e4rat as i understand by looking source, patch kernel, to get
features of files reorder)

3. In
struct move_extent {
    __s32 reserved;    /* original file descriptor */
    __u32 donor_fd;    /* donor file descriptor */
    __u64 orig_start;  /* logical start offset in block for orig */
    __u64 donor_start; /* logical start offset in block for donor */
    __u64 len;         /* block length to be moved */
    __u64 moved_len;   /* moved block length */
};
Can i ignore (not set) orig_start, donor_start, len, moved_len?
What happen if i set it by zeros?
if i move original file descriptor to file descriptor with zero size
of file, what happen? or in begger file donor then original?

-----
Best regards,
Timofey.
