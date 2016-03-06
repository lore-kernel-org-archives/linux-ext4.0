From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: RIP [<ffffffff812c3b77>] ext4_release_file+0x37/0xc0 with
 4.5-rc6 when resuming from suspend
Date: Sun, 6 Mar 2016 14:10:10 -0500
Message-ID: <20160306191010.GM10297@thunk.org>
References: <56DAB3EE.5020203@kpanic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Stefan Assmann <sassmann@kpanic.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37884 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbcCFTKQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 14:10:16 -0500
Content-Disposition: inline
In-Reply-To: <56DAB3EE.5020203@kpanic.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 05, 2016 at 11:24:46AM +0100, Stefan Assmann wrote:
> Occasionally when trying to resume from suspend to RAM I get the
> following GPF.
>=20
>   Stefan
>=20
> [  882.344245] PM: resume of devices complete after 83682.775 msecs
> [  882.420550] PM: Finishing wakeup.
> [  882.420551] Restarting tasks ...=B7
> [  882.420664] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] h=
as bogus alignment
> [  882.421141] done.
> [  882.422027] usb 3-9.1.1: USB disconnect, device number 33

Hmm.... did you have a ext4 file system mounted on some kind of USB
attached storage device (USB thumb drive, USB HDD, etc.)?

> [  882.461578] RIP: 0010:[<ffffffff812c3b77>]  [<ffffffff812c3b77>] e=
xt4_release_file+0x37/0xc0

Also, can you translate this address to a file and line number?  Use
the command:

addr2line -e /usr/src/linux/vmlinux -i -a ffffffff812c3b77

Also, if you could give the lines around fs/ext4/file.c (unless it is
exactly 4.5-rc6 without any other changes or commit) that would also
be helpful.

I don't see anything in ext4_release_file() that would obviously be a
potential problem after a suspend/reasume.  One possibly is that some
other piece of code is corrupting memory.

> [  882.459687] CPU: 7 PID: 5299 Comm: dhclient Tainted: G        W   =
    4.5.0-0.rc6.git1.1.vanilla.knurd.1.fc23.x86_64 #1

Is it always dhclient which is trying to exit?

If you can give a detailed description of your hardware configuration
(what devices, what file systems / partitions you have mounted, etc.)
that would be helpful.

Thanks,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
