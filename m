From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: 16 TB filesystem limit on 32bit machine
Date: Mon, 20 Feb 2012 16:17:31 -0500
Message-ID: <4F42B86B.60706@ubuntu.com>
References: <CAJZuRVZ5BC+oJA_4HqdwnJvME8XuDeCWWt_6pugOuBFjp8v_SQ@mail.gmail.com> <4F4279F1.8060805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Rabeeh Khoury <rabeeh3000@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:27311 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab2BTVRd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2012 16:17:33 -0500
In-Reply-To: <4F4279F1.8060805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/20/2012 11:50 AM, Eric Sandeen wrote:
> fs metadata is mapped into an address space, IIRC, so can't be
> addressed past 2^32 pages.  Also, mkfs can't do buffered IO to the
> device past 16T (it is writing to a device _file_) and ditto for
> e2fsck.

But the file is only used for open(), after that the IO is handled by
the correct device driver, which handles 64 bit offsets ( when you
have CONFIG_LBDAF on ).  So if you can change the page cache index
size ( and it doesn't blow up ) this should work fine.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPQrhrAAoJEJrBOlT6nu75yX8IAKNmJv0tH2CMWefUFV/4un0g
NKU5L2uwuMmyAzVRUOv165d1KAJkNc0z3OLUyh3425yku6wQ4dDqqnWSHCIZHJs7
/d1ltEP1g/vhpM5keAwwWHfC7N2KL+FRyqze8YAe6Qx5GGEWlUOqK2ALSxtuL2Il
TQ+lfLI9kAA5Ggtwf6mjjD/fKFTdJILQuZikxpJRfKasLg/4Y25LWdaPG8BOm78l
qPxkazpmIG8HVFczHwVWpuu+xY8nAmgDdZCTJBFoK9xmBUO0kjzl8JlAl4ScaXdi
v1793CSzev/2aIhEwXSK0HdI7e6KI4iT292/k4ryjfwJ+QX5L6eyfd4HlSVMM88=
=IOG0
-----END PGP SIGNATURE-----
