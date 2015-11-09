From: Eric Sandeen <sandeen@sandeen.net>
Subject: discard_zeroes_data questions
Date: Mon, 9 Nov 2015 17:08:38 -0600
Message-ID: <56412776.6080604@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: "Martin K. Petersen" <mkp@mkp.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37693 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbbKIXRc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2015 18:17:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Martin (and linux-ext4 list...) 

tl;dr:

mke2fs today thinks that if discard_zeroes_data == 1 and a BLKDISCARD ioctl of the whole device succeeds, then we have guarantees that any blocks read back will be full of zero, and we don't need to initialize them to zero.  Is this ok?  (barring crappy hardware, that is).

slightly longer:

Does discard_zeroes_data == 1 mean that a discard *request* will guarantee zeroes on a read, or does it mean that a discard-request-which-actually-was-executed-and-not-ignored-as-just-a-hint will give us back zeroes on a read?  (because UNMAP is a hint, right?  I don't know about SATA trim ...)

I did see 7985090 sd: disable discard_zeroes_data for UNMAP - so I think that for v3.19+, on *scsi*, what e2fsprogs is doing is ok (now).

But I'm wondering about dm-thin and SATA, too, so trying to figure out what discard_zeroes_data really implies.  That after a BLKDISCARD, a read *will* return zeros, or that it'll return zeros *iff* the hint is taken?

I hope that made sense, but I've been communicating badly today.  ;)

Thanks,
-Eric
