From: Jouko Orava <jouko.orava@helsinki.fi>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not
 empty
Date: Thu, 19 Apr 2012 17:38:44 +0300 (EEST)
Message-ID: <alpine.LRH.2.00.1204191731340.17249@ruuvi.it.helsinki.fi>
References: <20120412160658.GA9697@gmail.com> <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi> <alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi> <4F901E0C.3010008@redhat.com>
Reply-To: Jouko Orava <jouko.orava@iki.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jouko Orava <jouko.orava@helsinki.fi>, linux-ext4@vger.kernel.org,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-rs1-vallila2.fe.helsinki.fi ([128.214.173.75]:52275 "EHLO
	smtp-rs1-vallila2.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258Ab2DSOiz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 10:38:55 -0400
In-Reply-To: <4F901E0C.3010008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> FWIW, we tried fairly hard to get the limit lifted in the vfs, to no avail.

I understand. The downsides from the limit are very small, after all.

Has anyone tested the older stable kernel releases?
When was the VFS limit added, or is it something RHEL kernels patch out?

> Agreed, I think Dave was a little to quick on the draw on his reply.

It is easy to miss, the EFAULT on the syscall that follows is so obvious.

I've filed a terse report to the Red Hat Bugzilla:
	https://bugzilla.redhat.com/show_bug.cgi?id=814296
Let me know if you wish me to expand on that report.

Best regards,
    Jouko Orava
