From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 14:28:14 -0600
Message-ID: <20090918202814.GC2537@webber.adilger.int>
References: <4AB2B6B9.7010506@redhat.com> <yq1k4zw93vu.fsf@sermon.lab.mkp.net>
 <4AB397F3.3090206@redhat.com> <yq1ab0s6ny7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54622 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZIRU2K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 16:28:10 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8IKSEMl014985
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 13:28:14 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ600500OUVO500@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 18 Sep 2009 13:28:14 -0700 (PDT)
In-reply-to: <yq1ab0s6ny7.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 18, 2009  15:40 -0400, Martin K. Petersen wrote:
> >>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:
> >> Also, are you guys affected by the
> >> previously-acked-sectors-are-now-gone problems with 512-byte
> >> logical/4KB physical drives?
> 
> Eric> previously-acked-sectors-are-now-gone?  I guess I haven't been
> Eric> keeping up.  What do you mean by this?
> 
> We already discussed this on irc.  But in case anybody else are
> wondering...
> 
> On a disk with 4KB physical blocks emulating 512-byte logical blocks the
> drive firmware must resort to read-modify-write cycles and that opens up
> a new error scenario:
> 
> 4KB physical block: |                       0                       |
> 512b logical block: |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
>                                                                  ^ ERROR
> 
> In this case we have successfully written LBA 0 - 6.  However, when the
> drive attempts to write LBA 7 it gets an I/O error and the previous 7
> logical blocks (that have previously been acknowledged as written) are
> lost.  IOW, the drive write atomicity is at the physical block level and
> not the logical ditto.

In some sense, this is no worse than "real" sectors 0-6 going bad right
after they were written, or in fact even having the writes silently fail.

Yes, there is more chance that writing sector 7 (due to 4k sector r-m-w)
will cause collateral damage, but the truth even today is that disks
are not going to fail a single 512-byte sector at one time, but more
likely 64kB (or whatever the remapping unit size is), so this isn't
really introducing a new failure mode.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

