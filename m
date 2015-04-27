From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: RE: planning general storage capacity for y fs
Date: Mon, 27 Apr 2015 10:55:51 +0300
Message-ID: <007201d080bf$96a0e4e0$c3e2aea0$@codeaurora.org>
References: <006901d08012$3a1f97a0$ae5ec6e0$@codeaurora.org> <CAFLxGvyJDyN2-WJUkJ9wz5cCDvNjrUsbdpHrN4DH7S1gQoF2Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: <linux-mtd@lists.infradead.org>, <linux-ext4@vger.kernel.org>,
	"'Tanya Brokhman'" <tlinder@codeaurora.org>
To: "'Richard Weinberger'" <richard.weinberger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42764 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbbD0Hz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Apr 2015 03:55:56 -0400
In-Reply-To: <CAFLxGvyJDyN2-WJUkJ9wz5cCDvNjrUsbdpHrN4DH7S1gQoF2Yw@mail.gmail.com>
Content-Language: en-us
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>On Sun, Apr 26, 2015 at 1:14 PM, Dolev Raviv <draviv@codeaurora.org> wrote:
>> Hi,
>> I'm looking for guidelines for planning storage capacity. I understand 
>> it strongly depended on the usage type.
>> I want to know at what point storage fullness is effecting performance 
>> in a standard read/write partition. Do different File Systems 
>> (UBIFS/EXT4) have different full-free ratio?
>> What about read only fs? Can I plan less free space in such cases?
>>
>> I'll appreciate any input on this, for UBIFS specific and fs in general.
>
>Not sure if I got your question.
>You want to know how filesystems in general behave when they run out of free space?
>The general answer is that they need more effort to find free space.
>
>In case of UBIFS you also have to think of the garbage collector.
>See http://www.linux-mtd.infradead.org/doc/ubifs.html
>At the end of the day you'll have to run benchmarks on your own to find out how a specific filesystem behaves on your workload...
>

Thanks Richard!
Let me rephrase the question: In the past I knew there was a rule of thumb, 'leave free 30% of the storage space'. Nowadays I couldn't find any reference to this.
I was wondering, is there a known point in UBIFS (or ext4), where leaving less free storage space, that performance is dropping? Maybe a ratio of free-occupied is not the right way to look at it, but to leave a certain size free (e.g. 50MB)?

Thanks,
Dolev
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

