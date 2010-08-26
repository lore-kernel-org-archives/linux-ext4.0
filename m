From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: defragmentation of boot related files
Date: Thu, 26 Aug 2010 14:10:08 -0400
Message-ID: <AANLkTi=zdx6QjsB+EJrOtmpr9BY-j24TGTJaeisAcqu7@mail.gmail.com>
References: <4C7505C3.1070509@rid-net.de>
	<4C762AF3.8020303@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: andreas@rid-net.de, linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64622 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0HZSKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 14:10:09 -0400
Received: by iwn5 with SMTP id 5so1761826iwn.19
        for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 11:10:08 -0700 (PDT)
In-Reply-To: <4C762AF3.8020303@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/8/26 Kazuya Mio <k-mio@sx.jp.nec.com>:
> Hi Andreas,
> Thanks for the comments.
>
> 2010/08/25 21:00, andreas@rid-net.de wrote:
>> Is there a reason why the offset of the original file and the donor =
file
>> must be the same?
>
> e4defrag creates a donor file whose size is the same of the original =
file by
> fallocate. There is a possibility that the original file will be corr=
upted
> after moving an extent if the offset of the original file and the don=
or file
> are different. So they are checked in the kernel space, but it may be
> unnecessary from the point of view of the ioctl.
>
>> As i can see the patch for relevant file defragmentation in e4defrag
>> supports only directories. May it be possible to select any desired =
file?
>
> That's interesting. I came up with the new interface of e4defrag -r.
> What do you think the following implementation idea?
>
> Usage: e4defrag -r directory...| device...
> =A0 =A0 =A0 e4defrag -r base_file move_file... =A0 =A0 <--- new
>
> 1. Defrag base_file to reduce fragmentation of extents (call EXT4_IOC=
_MOVE_EXT)
> 2. Preallocate physical blocks near the data blocks of base_file
> 3. Move move_file's extents to the blocks that are allocated by (2).
> 4. Repeat (2) and (3) for all files specified as move_file
>
> Regards,
> Kazuya Mio

I suspect the original idea would work better because it is more
likely to pack the libs / files into perfectly contiguous block
ranges.

I too have never understood why the donor offsets have to match the
original offsets, although I had previously assumed the issue could be
worked around via making the donor file sparse and only have the block
range of interest allocated.

This use case is a specific example of where it would be beneficial to
eliminate that artificial limitation.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
