From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not
 empty
Date: Thu, 19 Apr 2012 09:45:05 -0500
Message-ID: <4F9024F1.3000806@redhat.com>
References: <20120412160658.GA9697@gmail.com> <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi> <alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi> <4F901E0C.3010008@redhat.com> <alpine.LRH.2.00.1204191731340.17249@ruuvi.it.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jouko Orava <jouko.orava@helsinki.fi>, linux-ext4@vger.kernel.org,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Jouko Orava <jouko.orava@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab2DSOpS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 10:45:18 -0400
In-Reply-To: <alpine.LRH.2.00.1204191731340.17249@ruuvi.it.helsinki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/19/12 9:38 AM, Jouko Orava wrote:
>> FWIW, we tried fairly hard to get the limit lifted in the vfs, to no avail.
> 
> I understand. The downsides from the limit are very small, after all.
> 
> Has anyone tested the older stable kernel releases?
> When was the VFS limit added, or is it something RHEL kernels patch out?

No, RHEL kernels have the same limits.

>> Agreed, I think Dave was a little to quick on the draw on his reply.
> 
> It is easy to miss, the EFAULT on the syscall that follows is so obvious.
> 
> I've filed a terse report to the Red Hat Bugzilla:
> 	https://bugzilla.redhat.com/show_bug.cgi?id=814296

Whoops, I just filed one as well.  I'll dup yours to mine since I've already
started the process there.

Thanks,
-Eric

> Let me know if you wish me to expand on that report.
> 
> Best regards,
>     Jouko Orava

