From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 1/2] ext4: introduce new i_write_mutex to protect fallocate
Date: Sat, 31 May 2014 15:45:36 +0900
Message-ID: <000c01cf7c9b$edaf2f90$c90d8eb0$@samsung.com>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
 <alpine.LFD.2.00.1405291439340.18491@localhost.localdomain>
 <20140529162810.GG25041@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Theodore Ts'o' <tytso@mit.edu>,
	=?UTF-8?Q?'Luk=C3=A1=C5=A1_Czerner'?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:52950 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaEaGpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 May 2014 02:45:39 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N6F00536ES0WR70@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Sat, 31 May 2014 15:45:37 +0900 (KST)
In-reply-to: <20140529162810.GG25041@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>=20
> On Thu, May 29, 2014 at 02:42:04PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
> >
> > I wonder what is the performance impact of this change ? Especially
> > since we're not longer taking the lock only in unaligned aio/dio
> > case but in all cases ?
>=20
> Thinking about this some more, this is also going to break parallel
> writes, which would be unfortunate.  We might want to change this to
> using a rw mutex, where writes take a shared lock, and require
> fallocate to take an exclusive lock....
ext4 file write is already serialized with inode mutex.
So I think the impact of adding another lock will be very very less..
When I run parallel write test of fio to prove it, I can not see the di=
fference on w/wo i_write_mutex.

[job1]
ioengine=3Dsync
buffered=3D1
rw=3Dwrite
numjobs=3D100
filename=3Dfile1
rw_sequencer=3Dsequential
size=3D10485760000
filesize=3D104857600
nrfiles=3D1
openfiles=3D100

Without i_write_mutex =3D>
Run status group 0 (all jobs):
  WRITE: io=3D10000MB, aggrb=3D276869KB/s, minb=3D2768KB/s, maxb=3D3530=
KB/s, mint=3D29007msec, maxt=3D36985msec
Run status group 0 (all jobs):
  WRITE: io=3D10000MB, aggrb=3D273862KB/s, minb=3D2738KB/s, maxb=3D3584=
KB/s, mint=3D28566msec, maxt=3D37391msec
Run status group 0 (all jobs):
  WRITE: io=3D10000MB, aggrb=3D271373KB/s, minb=3D2713KB/s, maxb=3D3650=
KB/s, mint=3D28048msec, maxt=3D37734msec
Run status group 0 (all jobs):
  WRITE: io=3D10000MB, aggrb=3D274906KB/s, minb=3D2749KB/s, maxb=3D3554=
KB/s, mint=3D28808msec, maxt=3D37249msec

With i_write_mutex patch applied =3D>
Run status group 0 (all jobs):
  WRITE: io=3D10000MB, aggrb=3D273672KB/s, minb=3D2736KB/s, maxb=3D3498=
KB/s, mint=3D29269msec, maxt=3D37417msec
Run status group 0 (all jobs):
  WRITE: io=3D10000MB, aggrb=3D271877KB/s, minb=3D2718KB/s, maxb=3D3401=
KB/s, mint=3D30101msec, maxt=3D37664msec
Run status group 0 (all jobs):
  WRITE: io=3D10000MB, aggrb=3D272753KB/s, minb=3D2727KB/s, maxb=3D3412=
KB/s, mint=3D30008msec, maxt=3D37543msec
Run status group 0 (all jobs):
  WRITE: io=3D10000MB, aggrb=3D274508KB/s, minb=3D2745KB/s, maxb=3D3267=
KB/s, mint=3D31335msec, maxt=3D37303msec

Yes, Right. We can use shared lock to remove a little bit lock contenti=
on in ext4 file write.
I will share rwsem lock patch.. Could you please revert i_write_mutex p=
atch ?

Thanks!

>=20
> 				- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
