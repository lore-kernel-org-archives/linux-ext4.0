From: "Bill Huey (hui)" <bill.huey@gmail.com>
Subject: Re: ext4 corruption
Date: Mon, 28 Feb 2011 12:30:15 -0800
Message-ID: <AANLkTimxe936vPtOu0Lek80NTBXj3BSPRz20ppMioeKG@mail.gmail.com>
References: <AANLkTin5hN-gnpmgntApSSrWVWJPQqK99tPJtfmFn5++@mail.gmail.com>
	<C5B8C496-E8F1-4BF7-9A51-373C0C63E357@mit.edu>
	<AANLkTimcKiKgKTVft9N+OVHd5-N+-AscSoimdOfkoBt9@mail.gmail.com>
	<AANLkTik22qfqzi4nPhvXRinzEDPDZ+UQFYT98eKK+aau@mail.gmail.com>
	<20110228044307.GQ2924@thunk.org>
	<AANLkTimoODjtQY2mmfgnPMisEA+kUNeEnGryL1CMgAFM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34759 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1B1UaQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Feb 2011 15:30:16 -0500
Received: by bwz15 with SMTP id 15so4023348bwz.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 12:30:15 -0800 (PST)
In-Reply-To: <AANLkTimoODjtQY2mmfgnPMisEA+kUNeEnGryL1CMgAFM@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

...unless those two lines are linked somehow via a timeout or something...

On Mon, Feb 28, 2011 at 12:18 PM, Bill Huey (hui) <bill.huey@gmail.com> wrote:
> What ever is in the latest Ubuntu maverick, 2.6.35 for the kernel.
>
> The only thing that makes it not looking like it was a storage problem
> is this line that comes before the SATA error:
>
> -----
> Feb 25 04:41:26 finfin kernel: [206290.181230] JBD: Spotted dirty
> metadata buffer (dev = sdb1, blocknr = 0). There's a risk of
> filesystem corruption in case of system crash.
> -----
