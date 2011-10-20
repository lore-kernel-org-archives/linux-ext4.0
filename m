From: Johannes Segitz <johannes.segitz@gmail.com>
Subject: Re: fsck.ext4 taking a very long time because of "should not have
 EOFBLOCKS_FL set"
Date: Thu, 20 Oct 2011 09:48:51 +0200
Message-ID: <CAFj9jjwrEK-_ZOFDK6d5=kUFORjNqXZo=Gvg_s6zY1EWuYCfAA@mail.gmail.com>
References: <CAFj9jjyLbPjehM1QbVAK9qRQ3F45sRpp055cKGa6EijWi1CBUw@mail.gmail.com>
 <1DCB6B9B-6386-483E-B726-E2505690D224@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46523 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1JTHtI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 03:49:08 -0400
Received: by eye27 with SMTP id 27so2480563eye.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 00:49:06 -0700 (PDT)
In-Reply-To: <1DCB6B9B-6386-483E-B726-E2505690D224@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2011 at 18:22, Andreas Dilger <aedilger@gmail.com> wrote:
> You could always strace e2fsck to see what it is printing.

i tried that put i can't see which inode is currently processed

<snip fcntl lines>
fcntl(5, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=556, len=1}) = 0
fcntl(5, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=284, len=1}) = 0
fcntl(5, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=164, len=1}) = 0
fstat(5, {st_mode=S_IFREG|0600, st_size=376758272, ...}) = 0
munmap(0x7fe2aee4e000, 376758272)       = 0
ftruncate(5, 376762368)                 = 0
pwrite(5, "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"..., 1024, 376758272) = 1024
pwrite(5, "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"..., 1024, 376759296) = 1024
pwrite(5, "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"..., 1024, 376760320) = 1024
pwrite(5, "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"..., 1024, 376761344) = 1024
mmap(NULL, 376762368, PROT_READ|PROT_WRITE, MAP_SHARED, 5, 0) = 0x7fe2aee4d000

rinse repeat

Bye,
Johannes
