From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: xfstest ext4 'utility required' run stop
Date: Thu, 13 Jun 2013 15:02:12 +0800
Message-ID: <20130613070211.GA26762@gmail.com>
References: <20130613051731.207470@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmx.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43807 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3FMGn5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jun 2013 02:43:57 -0400
Received: by mail-pd0-f170.google.com with SMTP id x11so5200852pdj.1
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jun 2013 23:43:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130613051731.207470@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jon,

Could you please tell us which xfstest's version are you used?  If I
remember correctly, testcases 301-304 have a bug at some certain
version.  Could you please upgrade your xfstests to the latest version?
Or as Ted suggested, you could use xfstests-bld.

Regards,
                                                - Zheng

On Thu, Jun 13, 2013 at 01:17:30AM -0400, jon ernst wrote:
> Hi All,
> about xfstestI installed fio. But still got error when I run ext4 tes=
t 301.
> Could anyone enlight me what;s wrong with my configuration?=20
> I have latest ext4 dev branch code with latest xfstest code.
> fio version is 2.1.1
>=20
> this is whole log:
> Thank you!=20
>=20
> fio: failed parsing ioengine=3Dioe_e4defrag
> fio: job global dropped
> fio =C2=A0 =C2=A0 =C2=A0 =C2=A0 valid values: sync =C2=A0 =C2=A0 =C2=A0=
 Use read/write
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: psync =C2=A0 =C2=A0 =C2=A0Use pread/pwrite
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: vsync =C2=A0 =C2=A0 =C2=A0Use readv/writev
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: libaio =C2=A0 =C2=A0 Linux native asynchronous IO
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: posixaio =C2=A0 POSIX asynchronous IO
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: mmap =C2=A0 =C2=A0 =C2=A0 Memory mapped IO
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: splice =C2=A0 =C2=A0 splice/vmsplice based IO
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: netsplice =C2=A0splice/vmsplice to/from the network
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: sg =C2=A0 =C2=A0 =C2=A0 =C2=A0 SCSI generic v3 IO
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: null =C2=A0 =C2=A0 =C2=A0 Testing engine (no data transfer)
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: net =C2=A0 =C2=A0 =C2=A0 =C2=A0Network IO
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: syslet-rw =C2=A0syslet enabled async pread/pwrite IO
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: cpuio =C2=A0 =C2=A0 =C2=A0CPU cycle burner engine
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: binject =C2=A0 =C2=A0binject direct inject block engine
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: rdma =C2=A0 =C2=A0 =C2=A0 RDMA IO engine
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
: external =C2=A0 Load external engine (append name)
>=20
>=20
> fio --ioengine=3Dioe_e4defrag --iodepth=3D1 --directory=3D/device8 --=
filesize=3D3424725990 --size=3D999G --buffered=3D0 --fadvise_hint=3D0 -=
-name=3Ddefrag-4k --ioengine=3De4defrag --iodepth=3D1 --bs=3D128k --don=
orname=3Dtest1.def --inplace=3D0 --rw=3Dwrite --numjobs=3D4 --runtime=3D=
30*1 --time_based --filename=3Dtest1 --name=3Daio-dio-verifier --ioengi=
ne=3Dlibaio --iodepth=3D128*1 --numjobs=3D1 --verify=3Dcrc32c-intel --v=
erify_fatal=3D1 --verify_dump=3D1 --verify_backlog=3D1024 --verify_asyn=
c=3D1 --verifysort=3D1 --direct=3D1 --bs=3D64k --rw=3Drandwrite --runti=
me=3D30*1 --time_based --filename=3Dtest1=20
> mke2fs 1.42 (29-Nov-2011)
> Filesystem label=3D
> OS type: Linux
> Block size=3D4096 (log=3D2)
> Fragment size=3D4096 (log=3D2)
> Stride=3D0 blocks, Stripe width=3D0 blocks
> 629552 inodes, 2518180 blocks
> 125909 blocks (5.00%) reserved for the super user
> First data block=3D0
> Maximum filesystem blocks=3D2579496960
> 77 block groups
> 32768 blocks per group, 32768 fragments per group
> 8176 inodes per group
> Superblock backups stored on blocks:=20
>  32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
>=20
> Allocating group tables:
>=20
> # Common e4defrag regression tests
> [global]
> ioengine=3Dioe_e4defrag
> iodepth=3D1
> directory=3D/device8
> filesize=3D3424725990
> size=3D999G
> buffered=3D0
> fadvise_hint=3D0
>=20
> #################################
> # Test1
> # Defragment file while other task does direct io
>=20
> # Continious sequential defrag activity
> [defrag-4k]
> ioengine=3De4defrag
> iodepth=3D1
> bs=3D128k
> donorname=3Dtest1.def
> filename=3Dtest1
> inplace=3D0
> rw=3Dwrite
> numjobs=3D4
> runtime=3D30*1
> time_based
>=20
> # Verifier
> [aio-dio-verifier]
> ioengine=3Dlibaio
> iodepth=3D128*1
> numjobs=3D1
> verify=3Dcrc32c-intel
> verify_fatal=3D1
> verify_dump=3D1
> verify_backlog=3D1024
> verify_async=3D1
> verifysort=3D1
> direct=3D1
> bs=3D64k
> rw=3Drandwrite
> filename=3Dtest1
> runtime=3D30*1
> time_based
> # /usr/bin/fio /tmp/5884.fio
> fio: engine libaio not loadable
> fio: failed to load engine libaio
> defrag-4k: (g=3D0): rw=3Dwrite, bs=3D128K-128K/128K-128K/128K-128K, i=
oengine=3De4defrag, iodepth=3D1
> ...
> defrag-4k: (g=3D0): rw=3Dwrite, bs=3D128K-128K/128K-128K/128K-128K, i=
oengine=3De4defrag, iodepth=3D1
> fio: file:ioengines.c:99, func=3Ddlopen, error=3Dlibaio: cannot open =
shared object file: No such file or directory
> failed: '/usr/bin/fio /tmp/5884.fio'
> fio --ioengine=3Dioe_e4defrag --iodepth=3D1 --directory=3D/device8 --=
filesize=3D3424725990 --size=3D999G --buffered=3D0 --fadvise_hint=3D0 -=
-name=3Ddefrag-4k --ioengine=3De4defrag --iodepth=3D1 --bs=3D128k --don=
orname=3Dtest1.def --inplace=3D0 --rw=3Dwrite --numjobs=3D4 --runtime=3D=
30*1 --time_based --filename=3Dtest1 --name=3Daio-dio-verifier --ioengi=
ne=3Dlibaio --iodepth=3D128*1 --numjobs=3D1 --verify=3Dcrc32c-intel --v=
erify_fatal=3D1 --verify_dump=3D1 --verify_backlog=3D1024 --verify_asyn=
c=3D1 --verifysort=3D1 --direct=3D1 --bs=3D64k --rw=3Drandwrite --runti=
me=3D30*1 --time_based --filename=3Dtest1=20
> mke2fs 1.42 (29-Nov-2011)
> Filesystem label=3D
> OS type: Linux
> Block size=3D4096 (log=3D2)
> Fragment size=3D4096 (log=3D2)
> Stride=3D0 blocks, Stripe width=3D0 blocks
> 629552 inodes, 2518180 blocks
> 125909 blocks (5.00%) reserved for the super user
> First data block=3D0
> Maximum filesystem blocks=3D2579496960
> 77 block groups
> 32768 blocks per group, 32768 fragments per group
> 8176 inodes per group
> Superblock backups stored on blocks:=20
>  32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
>=20
> Allocating group tables:=20
>=20
> # Common e4defrag regression tests
> [global]
> ioengine=3Dioe_e4defrag
> iodepth=3D1
> directory=3D/device8
> filesize=3D3424725990
> size=3D999G
> buffered=3D0
> fadvise_hint=3D0
>=20
> #################################
> # Test1
> # Defragment file while other task does direct io
>=20
> # Continious sequential defrag activity
> [defrag-4k]
> ioengine=3De4defrag
> iodepth=3D1
> bs=3D128k
> donorname=3Dtest1.def
> filename=3Dtest1
> inplace=3D0
> rw=3Dwrite
> numjobs=3D4
> runtime=3D30*1
> time_based
>=20
> # Verifier
> [aio-dio-verifier]
> ioengine=3Dlibaio
> iodepth=3D128*1
> numjobs=3D1
> verify=3Dcrc32c-intel
> verify_fatal=3D1
> verify_dump=3D1
> verify_backlog=3D1024
> verify_async=3D1
> verifysort=3D1
> direct=3D1
> bs=3D64k
> rw=3Drandwrite
> filename=3Dtest1
> runtime=3D30*1
> time_based
> # /usr/bin/fio /tmp/3999.fio
> fio: engine libaio not loadable
> fio: failed to load engine libaio
> defrag-4k: (g=3D0): rw=3Dwrite, bs=3D128K-128K/128K-128K/128K-128K, i=
oengine=3De4defrag, iodepth=3D1
> ...
> defrag-4k: (g=3D0): rw=3Dwrite, bs=3D128K-128K/128K-128K/128K-128K, i=
oengine=3De4defrag, iodepth=3D1
> fio: file:ioengines.c:99, func=3Ddlopen, error=3Dlibaio: cannot open =
shared object file: No such file or directory
> failed: '/usr/bin/fio /tmp/3999.fio'
> fio --ioengine=3Dioe_e4defrag --iodepth=3D1 --directory=3D/device8 --=
filesize=3D3424725990 --size=3D999G --buffered=3D0 --fadvise_hint=3D0 -=
-name=3Ddefrag-4k --ioengine=3De4defrag --iodepth=3D1 --bs=3D128k --don=
orname=3Dtest1.def --inplace=3D0 --rw=3Dwrite --numjobs=3D4 --runtime=3D=
30*1 --time_based --filename=3Dtest1 --name=3Daio-dio-verifier --ioengi=
ne=3Dlibaio --iodepth=3D128*1 --numjobs=3D1 --verify=3Dcrc32c-intel --v=
erify_fatal=3D1 --verify_dump=3D1 --verify_backlog=3D1024 --verify_asyn=
c=3D1 --verifysort=3D1 --direct=3D1 --bs=3D64k --rw=3Drandwrite --runti=
me=3D30*1 --time_based --filename=3Dtest1=20
> mke2fs 1.42 (29-Nov-2011)
> Filesystem label=3D
> OS type: Linux
> Block size=3D4096 (log=3D2)
> Fragment size=3D4096 (log=3D2)
> Stride=3D0 blocks, Stripe width=3D0 blocks
> 629552 inodes, 2518180 blocks
> 125909 blocks (5.00%) reserved for the super user
> First data block=3D0
> Maximum filesystem blocks=3D2579496960
> 77 block groups
> 32768 blocks per group, 32768 fragments per group
> 8176 inodes per group
> Superblock backups stored on blocks:=20
>  32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
>=20
> Allocating group tables: =C2=A0
>=20
> # Common e4defrag regression tests
> [global]
> ioengine=3Dioe_e4defrag
> iodepth=3D1
> directory=3D/device8
> filesize=3D3424725990
> size=3D999G
> buffered=3D0
> fadvise_hint=3D0
>=20
> #################################
> # Test1
> # Defragment file while other task does direct io
>=20
> # Continious sequential defrag activity
> [defrag-4k]
> ioengine=3De4defrag
> iodepth=3D1
> bs=3D128k
> donorname=3Dtest1.def
> filename=3Dtest1
> inplace=3D0
> rw=3Dwrite
> numjobs=3D4
> runtime=3D30*1
> time_based
>=20
> # Verifier
> [aio-dio-verifier]
> ioengine=3Dlibaio
> iodepth=3D128*1
> numjobs=3D1
> verify=3Dcrc32c-intel
> verify_fatal=3D1
> verify_dump=3D1
> verify_backlog=3D1024
> verify_async=3D1
> verifysort=3D1
> direct=3D1
> bs=3D64k
> rw=3Drandwrite
> filename=3Dtest1
> runtime=3D30*1
> time_based
> # /usr/bin/fio /tmp/12231.fio
> fio: engine libaio not loadable
> fio: failed to load engine libaio
> defrag-4k: (g=3D0): rw=3Dwrite, bs=3D128K-128K/128K-128K/128K-128K, i=
oengine=3De4defrag, iodepth=3D1
> ...
> defrag-4k: (g=3D0): rw=3Dwrite, bs=3D128K-128K/128K-128K/128K-128K, i=
oengine=3De4defrag, iodepth=3D1
> fio: file:ioengines.c:99, func=3Ddlopen, error=3Dlibaio: cannot open =
shared object file: No such file or directory
> failed: '/usr/bin/fio /tmp/12231.fio'
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
