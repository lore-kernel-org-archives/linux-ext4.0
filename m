From: Jouko Orava <jouko.orava@helsinki.fi>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not
 empty
Date: Thu, 19 Apr 2012 18:09:50 +0300 (EEST)
Message-ID: <alpine.LRH.2.00.1204191803360.19837@ruuvi.it.helsinki.fi>
References: <20120412160658.GA9697@gmail.com> <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi> <alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi> <4F901E0C.3010008@redhat.com> <alpine.LRH.2.00.1204191731340.17249@ruuvi.it.helsinki.fi>
 <4F9024F1.3000806@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-rs1-vallila2.fe.helsinki.fi ([128.214.173.75]:34664 "EHLO
	smtp-rs1-vallila2.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605Ab2DSPJ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 11:09:59 -0400
In-Reply-To: <4F9024F1.3000806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> No, RHEL kernels have the same limits.

That means at least 2.6.32.x stable series will suffer from the same bug.
I'll see if I can test those mainline kernels too this weekend.

> Whoops, I just filed one as well.  I'll dup yours to mine since I've already
> started the process there.

That's excellent, thank you. Mine was unacceptably terse anyway :)

Thanks,
  Jouko
