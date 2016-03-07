From: Stefan Assmann <sassmann@kpanic.de>
Subject: Re: RIP [<ffffffff812c3b77>] ext4_release_file+0x37/0xc0 with 4.5-rc6
 when resuming from suspend
Date: Mon, 7 Mar 2016 09:31:33 +0100
Message-ID: <56DD3C65.8010304@kpanic.de>
References: <56DAB3EE.5020203@kpanic.de> <20160306191010.GM10297@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-40-253.xlhost.de ([84.200.40.253]:47454 "EHLO
	app1a.xlhost.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055AbcCGIbs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Mar 2016 03:31:48 -0500
In-Reply-To: <20160306191010.GM10297@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06.03.2016 20:10, Theodore Ts'o wrote:
> On Sat, Mar 05, 2016 at 11:24:46AM +0100, Stefan Assmann wrote:
>> Occasionally when trying to resume from suspend to RAM I get the
>> following GPF.
>>
>>   Stefan
>>
>> [  882.344245] PM: resume of devices complete after 83682.775 msecs
>> [  882.420550] PM: Finishing wakeup.
>> [  882.420551] Restarting tasks ...=B7
>> [  882.420664] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] =
has bogus alignment
>> [  882.421141] done.
>> [  882.422027] usb 3-9.1.1: USB disconnect, device number 33
>=20
> Hmm.... did you have a ext4 file system mounted on some kind of USB
> attached storage device (USB thumb drive, USB HDD, etc.)?

Hi Ted,

No, this USB hub only has mouse and keyboard attached, but it
occasionally times out on power-on. Something's not right there so it
could be related.

>=20
>> [  882.461578] RIP: 0010:[<ffffffff812c3b77>]  [<ffffffff812c3b77>] =
ext4_release_file+0x37/0xc0
>=20
> Also, can you translate this address to a file and line number?  Use
> the command:
>=20
> addr2line -e /usr/src/linux/vmlinux -i -a ffffffff812c3b77

The kernel is from the Fedora Vanilla Repository [1] and IIRC they don'=
t
provide debuginfo packages. If this provides vital information I can
build the kernel from source and provide the info.

> Also, if you could give the lines around fs/ext4/file.c (unless it is
> exactly 4.5-rc6 without any other changes or commit) that would also
> be helpful.

It is 4.5-rc6 without any changes.

> I don't see anything in ext4_release_file() that would obviously be a
> potential problem after a suspend/reasume.  One possibly is that some
> other piece of code is corrupting memory.
>=20
>> [  882.459687] CPU: 7 PID: 5299 Comm: dhclient Tainted: G        W  =
     4.5.0-0.rc6.git1.1.vanilla.knurd.1.fc23.x86_64 #1
>=20
> Is it always dhclient which is trying to exit?

Most of the time the screen just stays black, so it's hard to tell. But
while trying to reproduce just now I hit a null pointer exception in
anon_vma_interval_tree_remove(), which happened right after initializin=
g
the exact same USB hub. Your corruption theory is getting more likely.

>=20
> If you can give a detailed description of your hardware configuration
> (what devices, what file systems / partitions you have mounted, etc.)
> that would be helpful.

Using a Lenovo w541 notebook with a Samsung 850 Evo SSD (500GB), no USB
storage devices attached.
=46ilesystem info
root@w541:~ > mount |grep ext
/dev/mapper/fedora_linux-root on / type ext4 (rw,relatime,data=3Dordere=
d)
/dev/sda2 on /boot type ext4 (rw,relatime,data=3Dordered)
/dev/mapper/fedora_linux-home on /home type ext4 (rw,relatime,data=3Dor=
dered)
/dev/mapper/fedora_linux-home on /var/lib/libvirt/images type ext4 (rw,=
relatime,data=3Dordered)
/dev/mapper/fedora_linux-home on /var/lib/docker type ext4 (rw,relatime=
,data=3Dordered)

  Stefan

[1] https://fedoraproject.org/wiki/Kernel_Vanilla_Repositories
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
