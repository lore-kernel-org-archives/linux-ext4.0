From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: discard_zeroes_data questions
Date: Mon, 09 Nov 2015 19:15:43 -0500
Message-ID: <yq1twouwvyo.fsf@sermon.lab.mkp.net>
References: <56412776.6080604@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36543 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbbKJAPs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Nov 2015 19:15:48 -0500
In-Reply-To: <56412776.6080604@sandeen.net> (Eric Sandeen's message of "Mon, 9
	Nov 2015 17:08:38 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Eric" == Eric Sandeen <sandeen@sandeen.net> writes:

Eric,

Eric> Does discard_zeroes_data == 1 mean that a discard *request* will
Eric> guarantee zeroes on a read, or does it mean that a
Eric> discard-request-which-actually-was-executed-and-not-ignored-as-just-a-hint
Eric> will give us back zeroes on a read?  (because UNMAP is a hint,
Eric> right?  I don't know about SATA trim ...)

For SCSI we only set d_z_d if the device is using WRITE SAME which
provides hard guarantees (i.e. the device will physically write zeroes
to any blocks of a request that can not be successfully unmapped).

The SATA spec is full of fail but RAID controller vendors as well as
Microsoft require a device that reports DRAT/RZAT to do the right
thing. I.e. offer guarantees above and beyond what the spec can
provide.

We don't entirely trust the "Designed for Windows" sticker. So for d_z_d
to be set on a SATA device in Linux it must report DRAT/RZAT *and* be
explicitly whitelisted. I am not aware of any problems with the drives
we currently have enabled.

Eric> But I'm wondering about dm-thin and SATA, too, so trying to figure
Eric> out what discard_zeroes_data really implies.  That after a
Eric> BLKDISCARD, a read *will* return zeros, or that it'll return zeros
Eric> *iff* the hint is taken?

Can't speak for dm-thin. But the intent is that discard_zeroes_data is a
hard guarantee and not a hint. So any stacked driver that sets it must
provide the right guarantees.

-- 
Martin K. Petersen	Oracle Linux Engineering
