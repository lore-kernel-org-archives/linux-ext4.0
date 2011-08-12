From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Fri, 12 Aug 2011 11:07:43 +0400
Message-ID: <4E44D13F.2010900@msgid.tls.msk.ru>
References: <4E4262A5.6030903@msgid.tls.msk.ru>	<20110811115943.GF4755@quack.suse.cz>	<4E43C956.3060507@msgid.tls.msk.ru>	<20110811140101.GA18802@quack.suse.cz>	<4E4435F4.6000406@msgid.tls.msk.ru> <CAFgt=MCgfN-6_uBm=pDaeLqJKJQkSHry91XbYwWq=iBXip3D-w@mail.gmail.com> <4E44C6ED.2030506@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:47096 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1HLHHq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 03:07:46 -0400
In-Reply-To: <4E44C6ED.2030506@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

12.08.2011 10:23, Michael Tokarev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> 12.08.2011 06:46, Jiaying Zhang wrote:
>> Hi Michael,
>>
>> Could you try your test with the patch I just posted:
>> http://marc.info/?l=3Dlinux-ext4&m=3D131311627101278&w=3D2
>> and see whether it fixes the problem?
>=20
> No it does not.  I'm now able to trigger it more or
> less reliable - I need to decompress a relatively
> small (about 70Gb) oracle database and try to start
> it (this requires a rebuild of initrd and reboot ofcourse --
> whole thing takes about 15 minutes) - and I see this:

And I forgot to note an important (in my opinion anyway)
detail: I can only trigger the issue after copying the
database files, ie, on a hot cache.  After reboot when
the files are not in cache, I can start this database
without any issues whatsoever, and it passes all our
stress tests just fine.  So it appears the problem only
happens when the cache is hot - maybe DIO is fighting
with in-memory cache of the file or somesuch, or maybe
with yet unwritten file (since the amount of memory on
this machine is large, whole database with all its files
fits in memory).  Next time I'll try to ensure only the
(problematic and small) logfiles are hot in the cache.

Thanks,

/mjt

> [  945.729965] EXT4-fs (sda11): Unaligned AIO/DIO on inode 5767175 by=
 oracle; performance will be poor.
> [  960.915602] SysRq : Show Blocked State
> [  960.915650]   task                        PC stack   pid father
> [  960.915852] oracle          D 0000000000000000     0  4985      1 =
0x00000000
> [  960.915909]  ffff88103e627040 0000000000000082 ffff881000000000 ff=
ff881078e3f7d0
> [  960.917855]  ffff88103f88ffd8 ffff88103f88ffd8 ffff88103f88ffd8 ff=
ff88103e627040
> [  960.917953]  0000000001c08400 ffff88203e98c948 ffff88207873e240 ff=
ffffff813527c6
> [  960.918045] Call Trace:
> [  960.918092]  [<ffffffff813527c6>] ? printk+0x43/0x48
> [  960.918153]  [<ffffffffa01432a8>] ? ext4_msg+0x58/0x60 [ext4]
> [  960.918201]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [e=
xt4]
> [  960.918252]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
> [  960.918301]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
> [  960.918348]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
> [  960.918392]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
> [  960.918436]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
> [  960.918483]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b
>=20
> (Inum 5767175 is one of oracle redologs).
>=20
> Jan, I lied to you initially - I didn't even test your first patch,
> because I loaded the wrong initrd.  With it applied, situation does
> not improve still, and it looks exactly the same as with this new
> patch by Jiaying Zhang:
>=20
> [  415.288104] EXT4-fs (sda11): Unaligned AIO/DIO on inode 5767177 by=
 oracle; performance will be poor.
> [  422.967323] SysRq : Show Blocked State
> [  422.967494]   task                        PC stack   pid father
> [  422.967872] oracle          D 0000000000000000     0  3743      1 =
0x00000000
> [  422.968112]  ffff88203e5a2810 0000000000000086 ffff882000000000 ff=
ff88103f403080
> [  422.968505]  ffff88203eeddfd8 ffff88203eeddfd8 ffff88203eeddfd8 ff=
ff88203e5a2810
> [  422.968895]  0000000001c08400 ffff88103f3db348 ffff88103f2fe800 ff=
ffffff813527c6
> [  422.969287] Call Trace:
> [  422.969397]  [<ffffffff813527c6>] ? printk+0x43/0x48
> [  422.969528]  [<ffffffffa0143288>] ? ext4_msg+0x58/0x60 [ext4]
> [  422.969643]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [e=
xt4]
> [  422.969758]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
> [  422.969873]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
> [  422.969985]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
> [  422.970093]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
> [  422.970200]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
> [  422.970312]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b
>=20
> Note in both this cases, I now see slightly different
> backtrace -- both mentions ext4_llseek and abort_exclusive_wait,
> but the rest is different:
>=20
>>> [   76.982985] EXT4-fs (dm-1): Unaligned AIO/DIO on inode 3407879 b=
y oracle; performance will be poor.
>>> [ 1469.734114] SysRq : Show Blocked State
>>> [ 1469.734157]   task                        PC stack   pid father
>>> [ 1469.734473] oracle          D 0000000000000000     0  6146      =
1 0x00000000
>>> [ 1469.734525]  ffff88103f604810 0000000000000082 ffff881000000000 =
ffff881079791040
>>> [ 1469.734603]  ffff880432c19fd8 ffff880432c19fd8 ffff880432c19fd8 =
ffff88103f604810
>>> [ 1469.734681]  ffffea000ec13590 ffffffff00000000 ffff881438c8dad8 =
ffffffff810eeda2
>>> [ 1469.734760] Call Trace:
>>> [ 1469.734800]  [<ffffffff810eeda2>] ? __do_fault+0x422/0x520
>>> [ 1469.734863]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 =
[ext4]
>>> [ 1469.734909]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0x=
b0
>>> [ 1469.734956]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext=
4]
>>> [ 1469.734999]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
>>> [ 1469.735039]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
>>> [ 1469.735078]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
>>> [ 1469.735122]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x=
1b
>=20
> As Jan already pointed out, this place looks bogus, and
> the same can be said about the new backtrace.  So I wonder
> if there's some stack corruption going on there as well.
>=20
> Btw, does ext4_llseek() look sane here?  Note it's called from
> aio_submit() -- does it _ever_ implement SEEKs?
>=20
> Maybe some debugging is neecessary here?
>=20
> Thank you!
>=20
> /mjt

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
