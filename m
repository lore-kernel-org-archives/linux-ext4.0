From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
Date: Mon, 22 Apr 2013 12:04:22 +0200
Message-ID: <51750B26.4000607@de.ibm.com>
References: <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org> <87li90q9mx.fsf@openvz.org> <87hajoq6s2.fsf@openvz.org> <20130403102204.GA15383@gmail.com> <20130403122058.GB7741@thunk.org> <20130403143406.GA3006@wallace> <20130403144114.GB13668@thunk.org> <683906006.1314495.1365476711254.JavaMail.root@redhat.com> <20130420151945.GA8575@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: CAI Qian <caiqian@redhat.com>, Eric Whitney <enwlinux@gmail.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Christian Kujau <lists@nerdbynature.de>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:53162 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3DVKE7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Apr 2013 06:04:59 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <borntraeger@de.ibm.com>;
	Mon, 22 Apr 2013 11:01:21 +0100
In-Reply-To: <20130420151945.GA8575@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 20/04/13 17:19, Theodore Ts'o wrote:
> On Mon, Apr 08, 2013 at 11:05:11PM -0400, CAI Qian wrote:
>> I can help run xfstests for ext4 dev tree on x64, Power7, Z10 and
>> KVM platforms with back-storage like SAN/multipath, iSCSI and FCoE.
>> I plan to run this weekly and setup a wiki page to update the testing
>> status by every Friday.
> 
> Hi CAI,
> 
> Sorry for not getting back to you sooner; I was at Collaboration
> Summit and LSF/MM last week.
> 
> It would be great if you could help run xfstests on the ext4 dev tree
> on various platforms.  We don't have any coverage on Power7 or
> s390/Z10 at the moment, so that would be especially welcome.  Coverage
> on alternate storage backends can be interesting in finding timing
> problems so they would be valuable as well.

It is probably easier to get access to a Power system (gcc compile farm?).
Having said that, there is a service available to get access to a System z
for open source development:
http://www-03.ibm.com/systems/z/os/linux/support/community.html

When we did the valgrind port we used that a lot to gave access to 
non-IBMers.
Dont know if it is ok to install a private kernel, though. Will double
check.

Christian

