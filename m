Return-Path: <SRS0=cNy7=PF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729323AbeL1P0P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 28 Dec 2018 10:26:15 -0500
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A56B218FD
        for <linux-ext4@vger.kernel.org>; Fri, 28 Dec 2018 15:26:14 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id r24so26094123wmh.0
        for <linux-ext4@vger.kernel.org>; Fri, 28 Dec 2018 07:26:14 -0800 (PST)
MIME-Version: 1.0
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
In-Reply-To: <87bm56vqg4.fsf@mid.deneb.enyo.de>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 28 Dec 2018 07:26:00 -0800
Message-ID: <CALCETrUBfVK1yUtuVn-pGzgrq8GQ7_E0sjPBXPaSiPU+Q-C_aA@mail.gmail.com>
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        libc-alpha <libc-alpha@sourceware.org>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[sending again, slightly edited, due to email client issues]

On Thu, Dec 27, 2018 at 9:25 AM Florian Weimer <fw@deneb.enyo.de> wrote:
>
> We have a bit of an interesting problem with respect to the d_off
> field in struct dirent.
>
> When running a 64-bit kernel on certain file systems, notably ext4,
> this field uses the full 63 bits even for small directories (strace -v
> output, wrapped here for readability):
>
> getdents(3, [
>   {d_ino=3D1494304, d_off=3D3901177228673045825, d_reclen=3D40, d_name=3D=
"authorized_keys", d_type=3DDT_REG},
>   {d_ino=3D1494277, d_off=3D7491915799041650922, d_reclen=3D24, d_name=3D=
".", d_type=3DDT_DIR},
>   {d_ino=3D1314655, d_off=3D9223372036854775807, d_reclen=3D24, d_name=3D=
"..", d_type=3DDT_DIR}
> ], 32768) =3D 88
>
> When running in 32-bit compat mode, this value is somehow truncated to
> 31 bits, for both the getdents and the getdents64 (!) system call (at
> least on i386).
>

...

>
> However, both qemu-user and the 9p file system can run in such a way
> that the kernel is entered from a 64-bit process, but the actual usage
> is from a 32-bit process:


I imagine that at least some of the problems you're seeing are due to this =
bug:

https://lkml.org/lkml/2018/10/18/859

Presumably the right fix involves modifying the relevant VFS file
operations to indicate the relevant ABI to the implementations.  I
would guess that 9p is triggering the =E2=80=9Cnot really in the syscall yo=
u
think you=E2=80=99re in=E2=80=9D issue.
