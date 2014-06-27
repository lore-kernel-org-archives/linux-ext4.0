From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: data=journal regressions in 3.16-rc1
Date: Fri, 27 Jun 2014 13:20:54 +0900
Message-ID: <004001cf91bf$30289220$9079b660$@samsung.com>
References: <20140623202404.GA16979@wallace>
 <100D68C7BA14664A8938383216E40DE0407A5AB2@FMSMSX114.amr.corp.intel.com>
 <20140623215514.GB16979@wallace>
 <alpine.LFD.2.00.1406261646500.2172@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: "'Wilcox, Matthew R'" <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>,
	'Eric Whitney' <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:52321 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaF0EVG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2014 00:21:06 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N7T00GB582VYB70@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 27 Jun 2014 13:20:55 +0900 (KST)
In-reply-to: <alpine.LFD.2.00.1406261646500.2172@localhost.localdomain>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 
> On Mon, 23 Jun 2014, Eric Whitney wrote:
> 
> > Date: Mon, 23 Jun 2014 17:55:14 -0400
> > From: Eric Whitney <enwlinux@gmail.com>
> > To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
> > Cc: Eric Whitney <enwlinux@gmail.com>,
> >     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
> >     "tytso@mit.edu" <tytso@mit.edu>
> > Subject: Re: data=journal regressions in 3.16-rc1
> >
> > The first invocation of fsx causes generic/075 to fail.  Within 075.0.fsxlog,
> > bad reads appear to be the cause:
> >
> > READ BAD DATA: offset = 0xb7f0, size = 0x8111, fname = 075.0
> > OFFSET	GOOD	BAD	RANGE
> > 0x13000	0x1aee	0x0000	0x    0
> > operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
> > 0x13001	0xee1a	0x0000	0x    1
> > operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
> > 0x13002	0x1a01	0x0000	0x    2
> >
> > (etc. - goes on until RANGE = 0xf)
> >
> > This code is new to me, but it looks like fsx is getting zeros where it
> > expects other values.
> 
> This seems to be related to collapse range feature. When adding -C
> to the fsx the problem goes away. Also when comparing the fsxgood
> with the real file it seems that there is a big chunk if the file
> missing in the middle.
> 
> We need to investigate further. Namjae any idea what might be
> causing it ?
Hi, Lukas.

It seems this issue is related with collapse range on test result(with fsx -C option)
I will check it.

Thanks!
> 
> -Lukas
> 
> >
> > Eric
> >
> >
> > * Wilcox, Matthew R <matthew.r.wilcox@intel.com>:
> > > Which test in 075.0.fsxlog indicates failure?
> > > ________________________________________
> > > From: Eric Whitney [enwlinux@gmail.com]
> > > Sent: June 23, 2014 1:24 PM
> > > To: linux-ext4@vger.kernel.org
> > > Cc: tytso@mit.edu; Wilcox, Matthew R
> > > Subject: data=journal regressions in 3.16-rc1
> > >
> > > My regression test results for 3.16-rc1 on x86_64 show three new xfstests
> > > failures since 3.15 final when running on an ext4 filesystem mounted with the
> > > data=journal and block_validity mount options (xfstests-bld's data_journal
> > > scenario). These are generic/075, /112, and /231.  All three tests fail
> > > consistently.
> > >
> > > These failures bisect to this kernel patch:
> > > 7fc34a62ca  mm/msync.c: sync only the requested range in msync()
> > >
> > > These failures also appear when running on 3.16-rc2, and disappear if the
> > > aforementioned patch is reverted.  I've not seen the failures in any of the
> > > other test scenarios I've run on 3.16-rc1 (4k, ext3, nojournal, etc.).
> > >
> > > No error messages appear in the kernel log, and not a lot useful is reported
> > > when a test fails.  Just for reference, here's the result of a generic/075
> > > failure:
> > >
> > > generic/075 62s ...     [15:33:07] [15:33:09] [failed, exit status 1] - output mismatch (see
> /root/xfstests/results//generic/075.out.bad)
> > >     --- tests/generic/075.out   2014-06-16 13:14:27.233891460 -0400
> > >     +++ /root/xfstests/results//generic/075.out.bad     2014-06-23 15:33:09.654212783 -0400
> > >     @@ -4,15 +4,5 @@
> > >      -----------------------------------------------
> > >      fsx.0 : -d -N numops -S 0
> > >      -----------------------------------------------
> > >     -
> > >     ------------------------------------------------
> > >     -fsx.1 : -d -N numops -S 0 -x
> > >     ------------------------------------------------
> > >     ...
> > >     (Run 'diff -u tests/generic/075.out /root/xfstests/results//generic/075.out.bad'  to see the
> entire diff)
> > > Ran: generic/075
> > > Failures: generic/075
> > > Failed 1 of 1 tests
> > >
> > >
> > > And the contents of xfstests/results/generic/075.out.bad:
> > >
> > >
> > > QA output created by 075
> > > brevity is wit...
> > >
> > > -----------------------------------------------
> > > fsx.0 : -d -N numops -S 0
> > > -----------------------------------------------
> > >     fsx (-d -N 1000 -S 0) failed, 0 - compare
> /root/xfstests/results//generic/075.0.{good,bad,fsxlog}
> > > od: /root/xfstests/results//generic/075.0.fsxgood: No such file or directory
> > >
> > >
> > > Additional test configuration info:
> > >
> > > e2fsprogs master branch:  bb9cca2ca9
> > > xfstests master branch:  45d1fac130
> > >
> > > Perhaps data=journal has an unexpected dependency on the old msync behavior,
> > > given the patch comment?
> > >
> > > Thanks,
> > > Eric
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

