From: Angelo Dureghello <angelo70@gmail.com>
Subject: Re: ext4 errors on kernel 3.17.0
Date: Thu, 20 Nov 2014 12:16:16 +0100
Message-ID: <546DCD80.5010006@gmail.com>
References: <54663355.2080903@gmail.com> <546C968C.60908@gmail.com> <20141119135059.GA7131@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41696 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaKTLQT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Nov 2014 06:16:19 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so4974966wiv.2
        for <linux-ext4@vger.kernel.org>; Thu, 20 Nov 2014 03:16:18 -0800 (PST)
In-Reply-To: <20141119135059.GA7131@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

thanks for the hints

well, i have same board with old kernel 3.5.1 perfectly working,
so i can exclude hardware issues.

Same for card issues, same card moved on kernel 3.5.1 board
behave correctly.

Strangely, seems i have "write" issues, if i format the card on PC
and put it back on the soc board, i get no errors on fsck.
If i format on soc board, and fsck from PC i get errors.

I am now moving the discussion to linux-mmc,

Regards,
angelo




On 19/11/2014 14:50, Theodore Ts'o wrote:
> The I/O errors, the "automount: inserted" message, the fact that it
> shows up on ext3 and ext4, makes it smell very much like a hardware
> problem (or possibly a mmc device driver problem).  It could be caused
> by a fake mmc card that (if you bought it from a street vendor or some
> the micro center discount bin at the checkout counter, try getting a
> brand name flash from a reputable source --- you get what you pay
> for).
>
> It could be caused by flaky hardware, or a MMC drive; it could be
> caused by an MMC driver problem.  It doesn't seem like it's a file
> system problem.
>
> Regards,
>
> 						- Ted

