From: "Bill Huey (hui)" <bill.huey@gmail.com>
Subject: Re: ext4 corruption
Date: Mon, 28 Feb 2011 15:45:51 -0800
Message-ID: <AANLkTim3Q+Q0AKQ46ANRL2fiuK6-_ESiNnaU+nfAvYoE@mail.gmail.com>
References: <AANLkTin5hN-gnpmgntApSSrWVWJPQqK99tPJtfmFn5++@mail.gmail.com>
	<C5B8C496-E8F1-4BF7-9A51-373C0C63E357@mit.edu>
	<AANLkTimcKiKgKTVft9N+OVHd5-N+-AscSoimdOfkoBt9@mail.gmail.com>
	<AANLkTik22qfqzi4nPhvXRinzEDPDZ+UQFYT98eKK+aau@mail.gmail.com>
	<20110228044307.GQ2924@thunk.org>
	<AANLkTimoODjtQY2mmfgnPMisEA+kUNeEnGryL1CMgAFM@mail.gmail.com>
	<20110228225559.GK28617@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54470 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1B1Xpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Feb 2011 18:45:53 -0500
Received: by bwz15 with SMTP id 15so4162370bwz.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 15:45:52 -0800 (PST)
In-Reply-To: <20110228225559.GK28617@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yeah, it was just a standard mkfs so I doubt that option was
specified. The important thing for me here was to at least let you
folks know about it so that you can determine if this is significant
or not.


Thanks

bill

On Mon, Feb 28, 2011 at 2:55 PM, Ted Ts'o <tytso@mit.edu> wrote:
> There are a few places where we update the superblock bypassing the
> journal layer. =C2=A0(For example, when we set the RO_COMPAT_LARGE_FI=
LE
> feature flag if it wasn't previously set). =C2=A0Those should be clea=
ned
> up, but it's not related to the rest of the scary-looking corruption
> which you saw. =C2=A0The worst that might happen is specific superblo=
ck
> update might get lost (i.e., the RO_COMPAT_LARGE_FILE feature flag) o=
n
> a crash before we commit some other superblock change to the journal.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
