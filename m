From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Wed, 15 Oct 2014 08:09:30 -0400
Message-ID: <yq1a94x7cw5.fsf@sermon.lab.mkp.net>
References: <20141015100257.GB30308@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21551 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaJOMJj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Oct 2014 08:09:39 -0400
In-Reply-To: <20141015100257.GB30308@thunk.org> (Theodore Ts'o's message of
	"Wed, 15 Oct 2014 06:02:57 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ted" == Theodore Ts'o <tytso@mit.edu> writes:

>> It's dubious. I'm working on making sure we only set
>> discard_zeroes_data when the device guarantees it for 3.19.

Ted> I'm curious how you were going to determine that the device
Ted> guarantees that discard_zeroes_data will be honored.  Is there some
Ted> new bit in some mode page that promises that discards won't be
Ted> thrown away any time the device feels like it?

We discussed this a week or two ago over on linux-raid because RAID5
depends on hard guarantees in the discard_zeroes_data department.

SCSI UNMAP suffers from the same lame behavior as ATA TRIM in the sense
that a device can report that it supports zero after UNMAP. But there is
no guarantee that all parts of an UNMAP command will be processed by the
storage device. Only parts that were actually processed will return
zeroes on subsequent reads. And obviously we don't know which parts the
device decided to ignore. *sigh*

It's incredibly frustrating that it is so hard to get the standards
bodies to give any guarantees about anything. It's an absolute miracle
that a READ after a WRITE is required to return the same data.

Anyway. Contrary to UNMAP, WRITE SAME with the UNMAP bit set requires
subsequent reads to deterministically return zeroes. If a block can't be
unmapped for whatever reason it will be explicitly zeroed. So I'm
working on a patch set that will:

 - Set discard_zeroes_data for SCSI devices that support the WRITE SAME
   w/ UNMAP commands.

 - Not set discard_zeroes_data for SCSI devices that only support UNMAP.

 - Set discard_zeroes_data for certain ATA SSDs that are known to behave
   correctly.

It's a royal pain to have to maintain a whitelist. But all the hardware
RAID vendors do the same thing. I'm talking to various folks to leverage
any guarantees we and other vendors may have in existing product
requirement documents.

As you alluded to, there are devices that otherwise appear to be
entirely well-behaved that can get stressed and start dropping
discards. That may be acceptable for the ext4 use case but will cause
corruption for RAID5. So we are compelled to being more conservative
about setting discard_zeroes_data. Until my tweaks are in Neil has opted
to disable discard on RAID5.

Martin (I scream daily)

-- 
Martin K. Petersen	Oracle Linux Engineering
