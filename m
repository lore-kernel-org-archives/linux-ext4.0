From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
Date: Sat, 20 Apr 2013 11:19:45 -0400
Message-ID: <20130420151945.GA8575@thunk.org>
References: <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org>
 <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org>
 <87li90q9mx.fsf@openvz.org>
 <87hajoq6s2.fsf@openvz.org>
 <20130403102204.GA15383@gmail.com>
 <20130403122058.GB7741@thunk.org>
 <20130403143406.GA3006@wallace>
 <20130403144114.GB13668@thunk.org>
 <683906006.1314495.1365476711254.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Christian Kujau <lists@nerdbynature.de>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: CAI Qian <caiqian@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <683906006.1314495.1365476711254.JavaMail.root@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 08, 2013 at 11:05:11PM -0400, CAI Qian wrote:
> I can help run xfstests for ext4 dev tree on x64, Power7, Z10 and
> KVM platforms with back-storage like SAN/multipath, iSCSI and FCoE.
> I plan to run this weekly and setup a wiki page to update the testing
> status by every Friday.

Hi CAI,

Sorry for not getting back to you sooner; I was at Collaboration
Summit and LSF/MM last week.

It would be great if you could help run xfstests on the ext4 dev tree
on various platforms.  We don't have any coverage on Power7 or
s390/Z10 at the moment, so that would be especially welcome.  Coverage
on alternate storage backends can be interesting in finding timing
problems so they would be valuable as well.

If you have any Itanium platforms, that would be great too, since we
don't have that today.

The various ext4 configurations which I test can be found in the
kvm-autorun/conf directory in my xfstests-bld git repository:

	git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

(This repository is a convenient setup to do build xfstests in a
hermetic environment, and convenience scripts to run xfstests under
kvm, and scripts on the host OS kick off the kvm test run and parse
the test output afterwards.)

Thanks for offering to test the dev branch!

					- Ted
