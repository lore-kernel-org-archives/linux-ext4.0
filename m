From: CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
Date: Mon, 8 Apr 2013 23:05:11 -0400 (EDT)
Message-ID: <683906006.1314495.1365476711254.JavaMail.root@redhat.com>
References: <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org> <87li90q9mx.fsf@openvz.org> <87hajoq6s2.fsf@openvz.org> <20130403102204.GA15383@gmail.com> <20130403122058.GB7741@thunk.org> <20130403143406.GA3006@wallace> <20130403144114.GB13668@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Eric Whitney <enwlinux@gmail.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Christian Kujau <lists@nerdbynature.de>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130403144114.GB13668@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello Ted,

----- Original Message -----
> From: "Theodore Ts'o" <tytso@mit.edu>
> To: "Eric Whitney" <enwlinux@gmail.com>
> Cc: "Dmitry Monakhov" <dmonakhov@openvz.org>, "Christian Kujau" <lists@nerdbynature.de>, "CAI Qian"
> <caiqian@redhat.com>, "LKML" <linux-kernel@vger.kernel.org>, "linux-s390" <linux-s390@vger.kernel.org>, "Steve Best"
> <sbest@redhat.com>, linux-ext4@vger.kernel.org
> Sent: Wednesday, April 3, 2013 10:41:14 PM
> Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
> 
> On Wed, Apr 03, 2013 at 10:34:06AM -0400, Eric Whitney wrote:
> > 
> > The TI OMAP4 processor on my Pandaboard test system is little endian.
> 
> Ah... so basically, we need to find a test platform which allows us to
> boot arbitrary kernels and allows us to have root access (which means
> it's unlikely we'll be able to do this via remote access) and which
> doesn't have exotic power requirements (which as far as I know rules
> out pSeries and zSeries systems....)
> 
> It would also be nice if we could run tests in finite time, which
> probably rules out the Hercules emulator (it runs at one-tenth zSeries
> processor speeds, which doesn't win speed competitions by default, and
> I suspect their storage speeds are even worse).
> 
> Anyone else have any suggestions?  Or anyone willing to help us run
> ext4 regression tests on the ext4 dev tree, so we can find these
> problems before we merge into mainline?
I can help run xfstests for ext4 dev tree on x64, Power7, Z10 and
KVM platforms with back-storage like SAN/multipath, iSCSI and FCoE.
I plan to run this weekly and setup a wiki page to update the testing
status by every Friday.
CAI Qian
> 
> Thanks,
> 
> 						- Ted
> 
