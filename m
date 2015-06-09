From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Re-2: Strange problems with lseek in qemu-img map
Date: Tue, 9 Jun 2015 12:35:15 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1506091234240.26548@localhost.localdomain>
References: <00056481.556F34D3@pegasus.munzinger.de>
	<20150605140515.GB30104@stefanha-thinkpad.redhat.com>
	<alpine.LFD.2.00.1506051711390.13926@localhost.localdomain>
	<55726ECE.70101@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1659545805-1433846122=:26548"
Cc: David Weber <wb@munzinger.de>, Stefan Hajnoczi <stefanha@gmail.com>,
	linux-ext4@vger.kernel.org, qemu-devel@nongnu.org, wenqing.lz@taobao.com
To: Wen Congyang <ghostwcy@gmail.com>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <55726ECE.70101@gmail.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1659545805-1433846122=:26548
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On Sat, 6 Jun 2015, Wen Congyang wrote:

> Date: Sat, 06 Jun 2015 11:53:50 +0800
> From: Wen Congyang <ghostwcy@gmail.com>
> To: Luk=E1=9A Czerner <lczerner@redhat.com>, Stefan Hajnoczi <stefanha@=
gmail.com>
> Cc: David Weber <wb@munzinger.de>, linux-ext4@vger.kernel.org,
>     qemu-devel@nongnu.org, wenqing.lz@taobao.com
> Subject: Re: [Qemu-devel] Re-2: Strange problems with lseek in qemu-img=
 map
>=20
> At 2015/6/5 23:14, Luk=E1=9A Czerner Wrote:
> > On Fri, 5 Jun 2015, Stefan Hajnoczi wrote:
> >=20
> > > Date: Fri, 5 Jun 2015 15:05:15 +0100
> > > From: Stefan Hajnoczi <stefanha@gmail.com>
> > > To: David Weber <wb@munzinger.de>
> > > Cc: qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
> > >      Lukas Czerner <lczerner@redhat.com>, wency@cn.fujitsu.com
> > > Subject: Re: [Qemu-devel] Re-2:  Strange problems with lseek in qem=
u-img
> > > map
> > >=20
> > > On Wed, Jun 03, 2015 at 03:09:40PM +0000, David Weber wrote:
> > > > > > I then startet a fedora 22 live system and I saw the same pro=
blem.
> > > > > > It
> > > > > > happens
> > > > > > on both the ramdisk and a ext4 filesystem.
> > > > >=20
> > > > > "it" =3D=3D qemu-img map hangs or takes a very long time?
> > > > I never waited for it to complete but I guess it just takes very =
long.
> > > >=20
> > > > >=20
> > > > > Can you post a shell script that reproduces this with a ramdisk=
?  That
> > > > > seems like the easiest way to get people debugging it.
> > > >=20
> > > > You can use the following commands.
> > > >=20
> > > > mkfs.ext4 /dev/ram0
> > > > mkdir -p /mnt/tmp
> > > > mount /dev/ram0 /mnt/tmp
> > > > cd /mnt/tmp
> > > > qemu-img create test 500G
> > > > time qemu-img map test
> > > >=20
> > > > This takes foreover on all my systems.
> > >=20
> > > I experience the same thing on Linux 4.1.0-rc5 with ext4 (4 KB file
> > > system block size, 512B device sector size).
> > >=20
> > > The lseek() calls take *seconds* to complete on a completely empty
> > > (sparse) 500G file.
> > >=20
> > > Here is the perf-top(1) output:
> > >=20
> > >    34.08%  [kernel]                         [k] _raw_read_lock
> > >    21.11%  [kernel]                         [k] ext4_es_lookup_exte=
nt
> > >    20.67%  [kernel]                         [k]
> > > ext4_es_find_delayed_extent_range
> > >     8.68%  [kernel]                         [k] ext4_map_blocks
> > >     4.99%  [kernel]                         [k] ext4_llseek
> > >     1.90%  [kernel]                         [k] rb_next
> > >     0.14%  [kernel]                         [k] __fget
> > >=20
> > > Yikes!
> > >=20
> > > The syscall causing this is just:
> > >=20
> > > lseek(7, 0, SEEK_DATA)
> > >=20
> > > Lukas: I've CCed you because you have helped with ext4 issues in th=
e
> > > past.  Not sure if you have time or if this is your area.
> > >=20
> > > Stefan
> >=20
> > Hi,
> >=20
> > this is definitely an issue with extent status tree and I have not se=
en
> > it before. I'll look at it first thing next week, but meanwhile I'll
> > add Zheng Liu who is the author of the extent status tree so he
> > might be able to help you.
>=20
> It is an known bug, and Dmitry Monakhov tried to fix it:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D14516bb7bb6ffbd49f35389f9ece3b2045ba5815
>=20
> But this patch introduced another problem, and have been reverted.
>=20
> Thanks
> Wen Congyang

Wow, the code is so broken :) Luckily the fix should be fairly easy,
I am testing it now.

Thanks everyone for pointing this out.

-Lukas

>=20
> >=20
> > Regards,
> > -Lukas
> >=20
> >=20
--8323328-1659545805-1433846122=:26548--
