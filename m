From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: Re: Using parts of ext2_fs.h in BSD licensed code
Date: Mon, 15 Mar 2010 20:26:16 +0300
Message-ID: <e1e08eb01003151026q1352c02btf12d7cd6d84c3f21@mail.gmail.com>
References: <e1e08eb01003150942s6350c04fn6b3d696fed8b7fc1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:59816 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965510Ab0COR0T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Mar 2010 13:26:19 -0400
Received: by ewy8 with SMTP id 8so1195062ewy.28
        for <linux-ext4@vger.kernel.org>; Mon, 15 Mar 2010 10:26:17 -0700 (PDT)
In-Reply-To: <e1e08eb01003150942s6350c04fn6b3d696fed8b7fc1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just found, that recently FreeBSD got this:
http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/fs/ext2fs/ext2fs.h
It looks like I can easily include it to the BSD-licensed project and
no GPL violation. But I dunno how did they wrote ext2fs.h, since it
still must be based on ext2_fs.h

On Mon, Mar 15, 2010 at 7:42 PM, Evgeniy Ivanov <lolkaantimat@gmail.com> wrote:
> Hello,
>
> I'm working on ext2 implementation for Minix3, where BSD license is
> desirable (AFAIK folks from *BSD are interested too). Most things are
> already implemented, while working I looked through linux and hurd
> implementations, but didn't use anything from there (I just learned
> some internals of ext2) and read http://nongnu.org/ext2-doc/ (thus my
> implementation mostly based on ext2-doc).
> Flags, constants, data structures are available in ext2-doc and
> ext2_fs.h. As I understand GPL license I can't just take it from
> ext2_fs.h and use in BSD licensed code, since it violates GPL (it was
> confirmed on #gnu). Is it correct? From another hand code based on
> ext2-doc can't be called derivative work. Is there any other header
> similar to ext2_fs.h (or any documentation except
> nongnu.org/ext2-doc/)?
>
> Do you think I can ask copyright owners for permission to use
> constants(data structures) from ext2_fs.h? Can somebody please send me
> Remy Card's email (in sources it's incorrect)?
>
> --
> Evgeniy Ivanov
>



-- 
Evgeniy Ivanov
