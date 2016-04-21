From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.5.1: UBSAN: Undefined behaviour in
 ./arch/x86/include/asm/atomic.h:156:9
Date: Thu, 21 Apr 2016 09:42:29 +0900
Message-ID: <20160421004229.GB10917@kroah.com>
References: <7d648a97-38f5-3d04-9ead-0b6e87088beb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7d648a97-38f5-3d04-9ead-0b6e87088beb-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 21, 2016 at 12:22:49AM +0200, Martin MOKREJ=C5=A0 wrote:
> Hi,
>   I am not certain to to forward this to, so I am trying linux-usb an=
d ext4. Please add relevant people/lists, thank you.
>=20
> # dmesg | grep "UBSAN: Undefined behaviour"
> [    2.638843] UBSAN: Undefined behaviour in drivers/usb/host/ehci-hu=
b.c:873:47
> [    8.553620] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:2612:1=
5
> [   25.341048] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:1274:1=
1
> [   41.460542] UBSAN: Undefined behaviour in ./arch/x86/include/asm/a=
tomic.h:156:9
> #
>=20
> Full dmesg is attached.
>=20
> Hope this helps,
> Martin

> [    0.000000] Linux version 4.5.1-default-pciehp (root@vostro) (gcc =
version 5.3.0 (Gentoo 5.3.0 p1.0, pie-0.6.5) ) #1 SMP Thu Apr 14 14:17:=
48 CEST 2016

Please try 4.6-rc4, a number of UBSAN issues have been fixed there.

thansk,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
