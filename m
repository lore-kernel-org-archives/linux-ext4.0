From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: planning general storage capacity for y fs
Date: Sun, 26 Apr 2015 22:45:33 +0200
Message-ID: <CAFLxGvyJDyN2-WJUkJ9wz5cCDvNjrUsbdpHrN4DH7S1gQoF2Yw@mail.gmail.com>
References: <006901d08012$3a1f97a0$ae5ec6e0$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	linux-ext4@vger.kernel.org, Tanya Brokhman <tlinder@codeaurora.org>
To: Dolev Raviv <draviv@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vn0-f49.google.com ([209.85.216.49]:44268 "EHLO
	mail-vn0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbbDZUpe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Apr 2015 16:45:34 -0400
Received: by vnbg7 with SMTP id g7so9644339vnb.11
        for <linux-ext4@vger.kernel.org>; Sun, 26 Apr 2015 13:45:34 -0700 (PDT)
In-Reply-To: <006901d08012$3a1f97a0$ae5ec6e0$@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 26, 2015 at 1:14 PM, Dolev Raviv <draviv@codeaurora.org> wrote:
> Hi,
> I'm looking for guidelines for planning storage capacity. I understand it
> strongly depended on the usage type.
> I want to know at what point storage fullness is effecting performance in a
> standard read/write partition. Do different File Systems (UBIFS/EXT4) have
> different full-free ratio?
> What about read only fs? Can I plan less free space in such cases?
>
> I'll appreciate any input on this, for UBIFS specific and fs in general.

Not sure if I got your question.
You want to know how filesystems in general behave when they run out
of free space?
The general answer is that they need more effort to find free space.

In case of UBIFS you also have to think of the garbage collector.
See http://www.linux-mtd.infradead.org/doc/ubifs.html
At the end of the day you'll have to run benchmarks on your own to
find out how a specific filesystem behaves on your workload...

-- 
Thanks,
//richard
