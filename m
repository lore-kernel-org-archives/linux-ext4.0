From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Sun, 20 Sep 2009 16:46:00 -0400
Message-ID: <yq1skeh5oqf.fsf@sermon.lab.mkp.net>
References: <4AB2B6B9.7010506@redhat.com> <yq1k4zw93vu.fsf@sermon.lab.mkp.net>
	<4AB397F3.3090206@redhat.com> <yq1ab0s6ny7.fsf@sermon.lab.mkp.net>
	<20090918202814.GC2537@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:65282 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZITUrH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Sep 2009 16:47:07 -0400
In-Reply-To: <20090918202814.GC2537@webber.adilger.int> (Andreas Dilger's
	message of "Fri, 18 Sep 2009 14:28:14 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Andreas" == Andreas Dilger <adilger@sun.com> writes:

Andreas> Yes, there is more chance that writing sector 7 (due to 4k
Andreas> sector r-m-w) will cause collateral damage, but the truth even
Andreas> today is that disks are not going to fail a single 512-byte
Andreas> sector at one time, but more likely 64kB (or whatever the
Andreas> remapping unit size is), so this isn't really introducing a new
Andreas> failure mode.

I keep hearing this disk drive "internal block size" of 32KB or 64KB
being mentioned.  And yet none of the drive firmware engineers I talk to
on a regular basis have ever heard of such a thing...

-- 
Martin K. Petersen	Oracle Linux Engineering
