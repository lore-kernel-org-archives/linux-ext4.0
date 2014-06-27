From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: data=journal regressions in 3.16-rc1
Date: Fri, 27 Jun 2014 20:14:39 +0900
Message-ID: <006901cf91f8$fc9eb490$f5dc1db0$@samsung.com>
References: <20140623202404.GA16979@wallace>
 <100D68C7BA14664A8938383216E40DE0407A5AB2@FMSMSX114.amr.corp.intel.com>
 <20140623215514.GB16979@wallace>
 <alpine.LFD.2.00.1406261646500.2172@localhost.localdomain>
 <004101cf91cd$8a4562c0$9ed02840$@samsung.com>
 <alpine.LFD.2.00.1406271246110.2349@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "'Wilcox, Matthew R'" <matthew.r.wilcox@intel.com>,
	'Eric Whitney' <enwlinux@gmail.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	'Christoph Hellwig' <hch@infradead.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:9049 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaF0LOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2014 07:14:42 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N7T00I87R8F9H10@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 27 Jun 2014 20:14:39 +0900 (KST)
In-reply-to: <alpine.LFD.2.00.1406271246110.2349@localhost.localdomain>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>=20
> On Fri, 27 Jun 2014, Namjae Jeon wrote:
>=20
> > Date: Fri, 27 Jun 2014 15:03:38 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: 'Luk=E1=B9 Czerner' <lczerner@redhat.com>,
> >     "'Wilcox, Matthew R'" <matthew.r.wilcox@intel.com>
> > Cc: 'Eric Whitney' <enwlinux@gmail.com>, linux-ext4@vger.kernel.org=
,
> >     tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
> >     Ashish Sangwan <a.sangwan@samsung.com>
> > Subject: RE: data=3Djournal regressions in 3.16-rc1
> >
> > > > On Mon, 23 Jun 2014, Eric Whitney wrote:
> > > >
> > > > > Date: Mon, 23 Jun 2014 17:55:14 -0400
> > > > > From: Eric Whitney <enwlinux@gmail.com>
> > > > > To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
> > > > > Cc: Eric Whitney <enwlinux@gmail.com>,
> > > > >     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>=
,
> > > > >     "tytso@mit.edu" <tytso@mit.edu>
> > > > > Subject: Re: data=3Djournal regressions in 3.16-rc1
> > > > >
> > > > > The first invocation of fsx causes generic/075 to fail.  With=
in 075.0.fsxlog,
> > > > > bad reads appear to be the cause:
> > > > >
> > > > > READ BAD DATA: offset =3D 0xb7f0, size =3D 0x8111, fname =3D =
075.0
> > > > > OFFSET	GOOD	BAD	RANGE
> > > > > 0x13000	0x1aee	0x0000	0x    0
> > > > > operation# (mod 256) for the bad data unknown, check HOLE and=
 EXTEND ops
> > > > > 0x13001	0xee1a	0x0000	0x    1
> > > > > operation# (mod 256) for the bad data unknown, check HOLE and=
 EXTEND ops
> > > > > 0x13002	0x1a01	0x0000	0x    2
> > > > >
> > > > > (etc. - goes on until RANGE =3D 0xf)
> > > > >
> > > > > This code is new to me, but it looks like fsx is getting zero=
s where it
> > > > > expects other values.
> > > >
> > > > This seems to be related to collapse range feature. When adding=
 -C
> > > > to the fsx the problem goes away. Also when comparing the fsxgo=
od
> > > > with the real file it seems that there is a big chunk if the fi=
le
> > > > missing in the middle.
> > > >
> > > > We need to investigate further. Namjae any idea what might be
> > > > causing it ?
> > > Hi, Lukas.
> > >
> > > It seems this issue is related with collapse range on test result=
(with fsx -C option)
> > > I will check it.
> >
> > Looks fstart is wrongly calcurated..
> >
> > - fstart =3D start + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
> > + fstart =3D (start - vma->vm_start) + ((loff_t)vma->vm_pgoff << PA=
GE_SHIFT);
>=20
> Good catch, this indeed is a bug. And this change fixes the problem
> we're seeing with data=3Djournal in ext4.
>=20
> Will you send a proper patch ?
Okay, I will send the patch soon.

Thanks!
>=20
> Thanks!
> -Lukas
>=20
> >
> > Could you confirm this change is correct ? Matthew ?
> >
> > Thanks.
> >
> > >
> > > Thanks!
> > > >
> > > > -Lukas
> > > >
> > > > >
> > > > > Eric
> > > > >
> > > > >
> > > > > * Wilcox, Matthew R <matthew.r.wilcox@intel.com>:
> > > > > > Which test in 075.0.fsxlog indicates failure?
> > > > > > ________________________________________
> > > > > > From: Eric Whitney [enwlinux@gmail.com]
> > > > > > Sent: June 23, 2014 1:24 PM
> > > > > > To: linux-ext4@vger.kernel.org
> > > > > > Cc: tytso@mit.edu; Wilcox, Matthew R
> > > > > > Subject: data=3Djournal regressions in 3.16-rc1
> > > > > >
> > > > > > My regression test results for 3.16-rc1 on x86_64 show thre=
e new xfstests
> > > > > > failures since 3.15 final when running on an ext4 filesyste=
m mounted with the
> > > > > > data=3Djournal and block_validity mount options (xfstests-b=
ld's data_journal
> > > > > > scenario). These are generic/075, /112, and /231.  All thre=
e tests fail
> > > > > > consistently.
> > > > > >
> > > > > > These failures bisect to this kernel patch:
> > > > > > 7fc34a62ca  mm/msync.c: sync only the requested range in ms=
ync()
> > > > > >
> > > > > > These failures also appear when running on 3.16-rc2, and di=
sappear if the
> > > > > > aforementioned patch is reverted.  I've not seen the failur=
es in any of the
> > > > > > other test scenarios I've run on 3.16-rc1 (4k, ext3, nojour=
nal, etc.).
> > > > > >
> > > > > > No error messages appear in the kernel log, and not a lot u=
seful is reported
> > > > > > when a test fails.  Just for reference, here's the result o=
f a generic/075
> > > > > > failure:
> > > > > >
> > > > > > generic/075 62s ...     [15:33:07] [15:33:09] [failed, exit=
 status 1] - output mismatch (see
> > > > /root/xfstests/results//generic/075.out.bad)
> > > > > >     --- tests/generic/075.out   2014-06-16 13:14:27.2338914=
60 -0400
> > > > > >     +++ /root/xfstests/results//generic/075.out.bad     201=
4-06-23 15:33:09.654212783 -0400
> > > > > >     @@ -4,15 +4,5 @@
> > > > > >      -----------------------------------------------
> > > > > >      fsx.0 : -d -N numops -S 0
> > > > > >      -----------------------------------------------
> > > > > >     -
> > > > > >     ------------------------------------------------
> > > > > >     -fsx.1 : -d -N numops -S 0 -x
> > > > > >     ------------------------------------------------
> > > > > >     ...
> > > > > >     (Run 'diff -u tests/generic/075.out /root/xfstests/resu=
lts//generic/075.out.bad'  to see
> the
> > > > entire diff)
> > > > > > Ran: generic/075
> > > > > > Failures: generic/075
> > > > > > Failed 1 of 1 tests
> > > > > >
> > > > > >
> > > > > > And the contents of xfstests/results/generic/075.out.bad:
> > > > > >
> > > > > >
> > > > > > QA output created by 075
> > > > > > brevity is wit...
> > > > > >
> > > > > > -----------------------------------------------
> > > > > > fsx.0 : -d -N numops -S 0
> > > > > > -----------------------------------------------
> > > > > >     fsx (-d -N 1000 -S 0) failed, 0 - compare
> > > > /root/xfstests/results//generic/075.0.{good,bad,fsxlog}
> > > > > > od: /root/xfstests/results//generic/075.0.fsxgood: No such =
file or directory
> > > > > >
> > > > > >
> > > > > > Additional test configuration info:
> > > > > >
> > > > > > e2fsprogs master branch:  bb9cca2ca9
> > > > > > xfstests master branch:  45d1fac130
> > > > > >
> > > > > > Perhaps data=3Djournal has an unexpected dependency on the =
old msync behavior,
> > > > > > given the patch comment?
> > > > > >
> > > > > > Thanks,
> > > > > > Eric
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe lin=
ux-ext4" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info=
=2Ehtml
> > > > >
> >
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
