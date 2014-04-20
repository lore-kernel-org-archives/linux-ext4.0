From: Contact <neitsab@ovh.fr>
Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc, e4defrag...)
Date: Sun, 20 Apr 2014 16:37:54 +0200
Message-ID: <5353DBC2.5080708@ovh.fr>
References: <534F39F6.2000208@ovh.fr> <20140417152457.GE18591@thunk.org> <5350205E.3030403@ovh.fr> <alpine.LFD.2.00.1404181042200.2128@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo29.mail-out.ovh.net ([178.32.228.29]:58620 "EHLO
	mo29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaDTOh7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Apr 2014 10:37:59 -0400
In-Reply-To: <alpine.LFD.2.00.1404181042200.2128@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le ven. 18 avril 2014 10:45:03 CEST, Luk=C3=A1=C5=A1 Czerner a =C3=A9cr=
it :
>
> The way you're using dd for this purpose is wrong. I
> said that dd can write to the file without truncating it first, but
> it's not doing it by default. You have to use 'notrunc' see man
> page. But I think that it would not have made a difference anyway.
>
Thansk, I stand corrected. I'll try it to see whether I can get better=20
results with it.

> And even though you can turn off backup superblock you
> can not turn off writing group descriptors.
>
While we're at it, how can I do this? I searched the=20
mkfs.ext4/mke2fs.conf/ext4/tune2fs man pages for the option to turn off=
=20
writing backup superblock you mentioned, however the closest I found is=
=20
tune2fs -O ^sparse_super which is part of the defaults mke2fs.conf=20
options... Could you point me at it so that I can try to get this=20
source of non-contiguity away?

Thanks,
-Bastien


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
