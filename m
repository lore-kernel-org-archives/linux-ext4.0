From: Richard Weinberger <richard@nod.at>
Subject: Re: planning general storage capacity for y fs
Date: Mon, 27 Apr 2015 10:06:22 +0200
Message-ID: <553DEDFE.2000700@nod.at>
References: <006901d08012$3a1f97a0$ae5ec6e0$@codeaurora.org> <CAFLxGvyJDyN2-WJUkJ9wz5cCDvNjrUsbdpHrN4DH7S1gQoF2Yw@mail.gmail.com> <007201d080bf$96a0e4e0$c3e2aea0$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-mtd@lists.infradead.org, linux-ext4@vger.kernel.org,
	'Tanya Brokhman' <tlinder@codeaurora.org>
To: Dolev Raviv <draviv@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbbD0IGZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2015 04:06:25 -0400
In-Reply-To: <007201d080bf$96a0e4e0$c3e2aea0$@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am 27.04.2015 um 09:55 schrieb Dolev Raviv:
> Thanks Richard!
> Let me rephrase the question: In the past I knew there was a rule of thumb, 'leave free 30% of the storage space'. Nowadays I couldn't find any reference to this.

Most likely because this is and was always kind of superstition. ;)
An almost full filesystems has to do more to find free space, but I don't dare to
give rules of thumb.

> I was wondering, is there a known point in UBIFS (or ext4), where leaving less free storage space, that performance is dropping? Maybe a ratio of free-occupied is not the right way to look at it, but to leave a certain size free (e.g. 50MB)?

I don't think so. Maybe Ted can give you more details on ext4.
For UBIFS I'd say, figure yourself. i.e. run benchmarks...

Thanks,
//richard
