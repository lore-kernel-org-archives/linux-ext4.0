From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Thu, 30 Jun 2011 18:41:08 -0700
Message-ID: <4E0D25B4.70901@linux.vnet.ibm.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com> <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com> <0B56FD8D-DCE5-4FB1-A97D-25EC1CD3CA14@dilger.ca> <4E0D1AC4.6020003@linux.vnet.ibm.com> <yq17h82n6gs.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36925 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab1GABlX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2011 21:41:23 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p611T7CV022906
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 21:29:07 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p611fAsY135874
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 21:41:10 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p611f9lY030944
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 21:41:10 -0400
In-Reply-To: <yq17h82n6gs.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/30/2011 06:18 PM, Martin K. Petersen wrote:
>>>>>> "Allison" == Allison Henderson<achender@linux.vnet.ibm.com>  writes:
>
>>> Does sb_issue_zeroout() use the SCSI "write same" feature in the
>>> background?  That would avoid busying the CPU/controller/bus with
>>> writing out zeroes, which might be expensive for a large file.
>>>
> Allison>  Hmm, that's a good question, I will dig into it and see if I
> Allison>  can find out.
>
> This is a bit of an ongoing project.
>
> Unfortunately WRITE SAME is quirk central as many drives only implement
> block ranges corresponding to what RAID vendors told them they needed.
> Many of the drives I tested have internal caps at 16 or 32MB and will
> fail in interesting (i.e. not necessarily graceful) ways if given bigger
> ranges.
>
> I've been lobbying for a way for devices to report their WRITE SAME
> limit for a while. That feature finally made it into the latest SBC3
> draft. The changes required to support it went into the SCSI layer
> during the last merge window. What remains is wiring this up to
> blkdev_issue_zeroout(). I have some patches sitting in my queue that I
> hope to get polished and submitted soon.
>
> Anyway. From a filesystem perspective sb_issue_zeroout() interface is
> definitely the way to go. WRITE SAME will eventually be called if the
> device supports it.
>
Ah, I see, well that answers that question.  Thx for the through 
explanation.  :)
