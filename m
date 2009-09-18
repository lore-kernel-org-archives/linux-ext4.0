From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 15:40:48 -0400
Message-ID: <yq1ab0s6ny7.fsf@sermon.lab.mkp.net>
References: <4AB2B6B9.7010506@redhat.com> <yq1k4zw93vu.fsf@sermon.lab.mkp.net>
	<4AB397F3.3090206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:48927 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbZIRTlJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 15:41:09 -0400
In-Reply-To: <4AB397F3.3090206@redhat.com> (Eric Sandeen's message of "Fri, 18
	Sep 2009 09:23:47 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:

>> Also, are you guys affected by the
>> previously-acked-sectors-are-now-gone problems with 512-byte
>> logical/4KB physical drives?

Eric> previously-acked-sectors-are-now-gone?  I guess I haven't been
Eric> keeping up.  What do you mean by this?

We already discussed this on irc.  But in case anybody else are
wondering...

On a disk with 4KB physical blocks emulating 512-byte logical blocks the
drive firmware must resort to read-modify-write cycles and that opens up
a new error scenario:

4KB physical block: |                       0                       |
512b logical block: |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
                                                                 ^ ERROR

In this case we have successfully written LBA 0 - 6.  However, when the
drive attempts to write LBA 7 it gets an I/O error and the previous 7
logical blocks (that have previously been acknowledged as written) are
lost.  IOW, the drive write atomicity is at the physical block level and
not the logical ditto.

See http://oss.oracle.com/~mkp/docs/ls09-topology.pdf page 19 for
prettier graphics.

-- 
Martin K. Petersen	Oracle Linux Engineering
