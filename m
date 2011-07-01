From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Thu, 30 Jun 2011 21:18:59 -0400
Message-ID: <yq17h82n6gs.fsf@sermon.lab.mkp.net>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
	<0B56FD8D-DCE5-4FB1-A97D-25EC1CD3CA14@dilger.ca>
	<4E0D1AC4.6020003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:36245 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab1GABTN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jun 2011 21:19:13 -0400
In-Reply-To: <4E0D1AC4.6020003@linux.vnet.ibm.com> (Allison Henderson's
	message of "Thu, 30 Jun 2011 17:54:28 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Allison" == Allison Henderson <achender@linux.vnet.ibm.com> writes:

>> Does sb_issue_zeroout() use the SCSI "write same" feature in the
>> background?  That would avoid busying the CPU/controller/bus with
>> writing out zeroes, which might be expensive for a large file.
>> 
Allison> Hmm, that's a good question, I will dig into it and see if I
Allison> can find out.

This is a bit of an ongoing project.

Unfortunately WRITE SAME is quirk central as many drives only implement
block ranges corresponding to what RAID vendors told them they needed.
Many of the drives I tested have internal caps at 16 or 32MB and will
fail in interesting (i.e. not necessarily graceful) ways if given bigger
ranges.

I've been lobbying for a way for devices to report their WRITE SAME
limit for a while. That feature finally made it into the latest SBC3
draft. The changes required to support it went into the SCSI layer
during the last merge window. What remains is wiring this up to
blkdev_issue_zeroout(). I have some patches sitting in my queue that I
hope to get polished and submitted soon.

Anyway. From a filesystem perspective sb_issue_zeroout() interface is
definitely the way to go. WRITE SAME will eventually be called if the
device supports it.

-- 
Martin K. Petersen	Oracle Linux Engineering
