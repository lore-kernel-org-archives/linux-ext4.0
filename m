From: Srivatsan Canchivaram <crsrivatstechnical@gmail.com>
Subject: Re: Segmentation fault in mke2fs
Date: Fri, 13 Dec 2013 18:33:22 -0500
Message-ID: <CAO_L5k_cLUdXNOhsAP6TkxtTHWv5hafx1dTmruaZnVmyGG0oKg@mail.gmail.com>
References: <CAO_L5k9iSm88wrs9W_yNCD1i8sy0SXfXJdbCwL840Hnn6Ef-0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f193.google.com ([209.85.192.193]:52197 "EHLO
	mail-pd0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3LMXdX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Dec 2013 18:33:23 -0500
Received: by mail-pd0-f193.google.com with SMTP id r10so1401426pdi.0
        for <linux-ext4@vger.kernel.org>; Fri, 13 Dec 2013 15:33:22 -0800 (PST)
In-Reply-To: <CAO_L5k9iSm88wrs9W_yNCD1i8sy0SXfXJdbCwL840Hnn6Ef-0g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I found that the segmentation fault occurs in optimized code (-O2). It
does not happen when optimization is turned off. I am not sure what
exactly happened but mke2fs is now able to get past that point.

The command now fails at a different point:

ext2fs_mkdir: EXT2 directory corrupted while creating /lost+found

Tracing from the ext2fs_mkdir() function, I found that the code
returns an error here:
ext2fs_read_dir_block3(): returns EXT2_ET_DIR_CORRUPTED

Any thoughts or ideas on this issue will be very helpful.

Thanks,
Sri

On Tue, Dec 10, 2013 at 5:21 PM, Srivatsan Canchivaram
<crsrivatstechnical@gmail.com> wrote:
> Hi,
> I have built e2fsprogs-1.42.8 for a MIPS64-based board. The tools were
> generated on an Intel machine with a MIPS64 cross compiler.
>
> MIPS64 board info:
> Linux kernel: 3.4.27
> Cavium Octeon Plus MIPS64 dual core processor
> 256 MB RAM
>
> The MIPS-based board will have a 2 TB NTFS (or VFAT) formatted
> external USB hard drive connected to it. The goal is to format the 2
> TB drive from NTFS/ VFAT to EXT4 using the 'mke2fs' program.
>
> 'Mke2fs' results in a segmentation fault when formatting to ext4:
>
> mke2fs -t ext4 /dev/sda1
> mke2fs 1.42.8 (20-Jun-2013)
> Segmentation fault
>
> As a parallel test, I tried formatting to EXT3 and this worked
> correctly. The issue only seems to occur for EXT4.
>
> Upon further debug, I found the segmentation fault to occur in
> mke2fs.c: end of the should_do_undo() function in the following call:
> io_channel_close(channel);
>
> I tried tracing through the code in the should_do_undo() function.
> The manager->open() call succeeds.
> An issue of note occurs in the following line:
>     retval = io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, &super);
>
> The following shows the contents of the 'channel' data structure
> before and after the above function call:
>
> Before call to io_channel_read_blk64()
> -----------------------------------------------------
> should_do_undo: Channel structure address = 0x1005fd70
> should_do_undo: magic = 2133571333, name: /dev/sda1, block_size = 1024
> should_do_undo: refcount = 1, flags = 4, align = 0
>
> After call to io_channel_read_blk64()
> ---------------------------------------------------
> After Read blk64: Channel structure address = 0x668b1e1a
> Segmentation fault
>
> So, the io_channel_read_blk64() function somehow modifies the
> "channel" structure pointer. Trying to read the structure after the
> call results in a seg fault.
>
> In the io_channel_read_blk64() function, the code takes the following route:
>    if (channel->manager->read_blk64)
>         return (channel->manager->read_blk64)(channel, block,
>                               count, data);
>
> If you have any thoughts on this issue or need additional details,
> please let me know.
>
> Thanks,
>
> Sri
