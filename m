From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RFC] block: use discard if possible in blkdev_issue_discard()
Date: Mon, 17 Feb 2014 20:31:50 -0500
Message-ID: <yq11tz1p5o9.fsf@sermon.lab.mkp.net>
References: <20140214043256.GA5145@thunk.org>
	<yq1ioshobul.fsf@sermon.lab.mkp.net>
	<20140215012901.GA28307@thunk.org>
	<yq161odofis.fsf@sermon.lab.mkp.net>
	<20140217191901.GC16660@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28246 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaBRBb5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Feb 2014 20:31:57 -0500
In-Reply-To: <20140217191901.GC16660@thunk.org> (Theodore Ts'o's message of
	"Mon, 17 Feb 2014 14:19:01 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ted" == Theodore Ts'o <tytso@mit.edu> writes:

Ted,

Ted> So currently blkdev_issue_zeroout() will do the WRITE SAME, but it
Ted> doesn't set the UNMAP bit, correct?  

Correct. Because it explicitly tells the device to write zeroes.

Ted> I understand there will be environments where performance is more
Ted> important than cost, where it may not be a good idea to set the
Ted> UNMAP bit.  So it sounds like what we should do is add a flags
Ted> which controls whether or not to use TRIM w/ ZRAT or WRITE SAME
Ted> with the UNMAP bit is set.

The rationale behind blkdev_issue_discard was to provide a facility to
mark a block range as unused by the filesystem. With the expectation
that those blocks would be deallocated/deprovisioned on the device.

The rationale behind blkdev_issue_zeroout was to provide a facility to
provide a cleared block range. With the expectation that those blocks
would be allocated/provisioned on the device.

Your variant seems to land somewhere in-between. You want a
blkdev_issue_clear() that zeroes a block range and it's then up to the
storage device to decide whether to provision or deprovision the space
as long as you are guaranteed to get zeroes back for each block in the
range on a subsequent read. Is that a correct interpretation?

I'm trying to pin down your exact use case because it can get very murky
between the SCSI and ATA variants. And the fact that the same knobs are
used for both over and under-provisioned devices. SCSI also has an
additional state: Blocks can be either mapped, anchored or deallocated.

Ted> On the other hand, if there was a white list kept somewhere, either
Ted> in the kernel, or in some more dynamically updated list (ala what
Ted> smartctl does to get the latest vendor-specific attributes), being
Ted> on the white list might be enough of a commercial advantage that
Ted> drive vendors would be incentivized to provide such a guarantee.
Ted> Especially if, say, a major SSD vendor such as Intel could be
Ted> induced make such a public guarantee and we publicized this fact.

I'm perfectly fine with maintaining a whitelist if we can get vendors to
commit.

-- 
Martin K. Petersen	Oracle Linux Engineering
