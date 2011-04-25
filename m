From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_put_super is not called during system shutdown or restart
Date: Mon, 25 Apr 2011 09:26:56 -0500
Message-ID: <4DB584B0.3000101@redhat.com>
References: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Zhao Cai <zhaocai@me.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137Ab1DYO06 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2011 10:26:58 -0400
In-Reply-To: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/24/11 11:12 PM, Zhao Cai wrote:
> I would appreciate if anyone can give me an answer. Is it designed to
> be like this?
>=20
> Detailed situation: The system is ubuntu 11.04 installed in VMware. I
> notice that ext4_put_super() is called when I unmount a non-root ext4
> partition. But it is not when I restart or shutdown the system.

Even for a non-root filesystem?

I don't know if ubuntu does anything special, but I would expect that d=
uring a system shutdown, non-root filesystems would be unmounted, and y=
ou'd get put_super called.  Unless the fs is busy and it can't be unmou=
nted for some reason...

-Eric

> Thanks=E3=80=82
>=20
> -- All the best,
>=20
> Zhao Cai
>=20
>=20
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-ext4" in the body of a message to majordomo@vger.kernel.org=20
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
