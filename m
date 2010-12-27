From: Filipe David Manana <fdmanana@apache.org>
Subject: Re: question about file space preallocation with fallocate
Date: Mon, 27 Dec 2010 17:57:21 +0000
Message-ID: <AANLkTinEnRaOEqZM9inVyVYW=hh68BC05f6d4Z6Cp7JF@mail.gmail.com>
References: <AANLkTinRcYrMrOUYqqCM3Lkpnhinm4NXqzDg1p2p0+68@mail.gmail.com>
	<4D18CA33.6050800@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55067 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab0L0R5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 12:57:23 -0500
Received: by fxm20 with SMTP id 20so9265847fxm.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Dec 2010 09:57:21 -0800 (PST)
In-Reply-To: <4D18CA33.6050800@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 27, 2010 at 5:17 PM, Sunil Mushran <sunil.mushran@oracle.co=
m> wrote:
>
> fallocate() gives users the ability to allocate space instantly. One =
way
> to compare would be to time just fallocate() with another program
> writing zeros for that length.
>
> But that's not the aim of the syscall. The aim is to allow the fs to
> allocate
> the space in as large chunks as possible to allow for better read
> performance.
>
> If you don't do fallocate() and allow writes to allocate in small chu=
nks,
> as you are doing, the allocations on disks could be interleaved in fa=
ce of
> multiple processes doing the same. Fragmented allocations can only hu=
rt
> read performance.
>

Thanks for the clarification Sunil. But preallocation of blocks
shouldn't also improve write operations? Since each write operation
will no longer cause the OS/filesystem to allocate blocks for the
file, therefore should be faster.

Also, any particular advice for improving write performance when all
the writes are done in append-only fashion?

--=20
=46ilipe David Manana,
fdmanana@gmail.com, fdmanana@apache.org

"Reasonable men adapt themselves to the world.
=C2=A0Unreasonable men adapt the world to themselves.
=C2=A0That's why all progress depends on unreasonable men."
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
