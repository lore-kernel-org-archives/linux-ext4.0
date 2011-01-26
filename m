From: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 38-rc1: umount+rmmod cause ext4 error.
Date: Wed, 26 Jan 2011 21:28:25 +0100
Message-ID: <201101262128.25528.maciej.rutecki@gmail.com>
References: <4D368A70.5030103@tao.ma>
Reply-To: maciej.rutecki@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: npiggin@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52246 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AZUby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jan 2011 15:31:54 -0500
In-Reply-To: <4D368A70.5030103@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I created a Bugzilla entry at=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D27652
for your bug report, please add your address to the CC list in there, t=
hanks!

On =C5=9Broda, 19 stycznia 2011 o 07:53:36 Tao Ma wrote:
> Hi Nick and Ted,
> 	I ran some very basic test with 38-rc1 and my box run into error wit=
h
> the message like:
>=20
> slab error in kmem_cache_destroy(): cache `ext4_inode_cache': Can't f=
ree
> all objects
> Pid: 4395, comm: rmmod Not tainted 2.6.38-rc1 #1
> Call Trace:
>   [<ffffffff820d61dc>] ? kmem_cache_destroy+0x83/0xc7
>   [<ffffffffa0574025>] ? destroy_inodecache+0x15/0x17 [ext4]
>   [<ffffffffa05923d1>] ? ext4_exit_fs+0x109/0x143 [ext4]
>   [<ffffffff8203d194>] ? put_online_cpus+0x56/0x58
>   [<ffffffff8206735a>] ? module_refcount+0x85/0x9d
>   [<ffffffff82067b22>] ? sys_delete_module+0x1b5/0x218
>   [<ffffffff82074fc3>] ? audit_syscall_entry+0x187/0x1ba
>   [<ffffffff82002a6b>] ? system_call_fastpath+0x16/0x1b
> SLAB: cache with size 888 has lost its name
> SLAB: cache with size 888 has lost its name
> SLAB: cache with size 888 has lost its name
> SLAB: cache with size 888 has lost its name
>=20
> The reproduce process is simple:just rmmod ext4 immediately after umo=
unt
> an ext4 volume.
>=20
> I have done some very simple investigation and it seems that with Nic=
k's
> new ext4_i_callback, even after we do ext4_destroy_inode, it isn't
> freed. So after we destroy the ext_inode_cache, and when freeing the
> inode, it errors. Hope it helps. If you have any fixes, I can test it=
=2E
>=20
> Regards,
> Tao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Maciej Rutecki
http://www.maciek.unixy.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
