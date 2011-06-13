From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Mon, 13 Jun 2011 12:56:54 +0300
Message-ID: <BANLkTikdmT5vjXJHnRTT-=z8zFVAx+Y6_w@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
	<BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
	<alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
	<BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
	<alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com>
	<BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com>
	<BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com>
	<BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
	<alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com>
	<BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com>
	<alpine.LFD.2.00.1106091012030.4138@dhcp-27-109.brq.redhat.com>
	<BANLkTin0RKZbDmB1movombH9o4HDpTnvFw@mail.gmail.com>
	<alpine.LFD.2.00.1106091443370.4138@dhcp-27-109.brq.redhat.com>
	<BANLkTinEJ6235sPNz_f92nfN0ac4qSnHtw@mail.gmail.com>
	<alpine.LFD.2.00.1106101044350.4502@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40559 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab1FMJ44 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jun 2011 05:56:56 -0400
Received: by wwk4 with SMTP id 4so2431122wwk.1
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jun 2011 02:56:55 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106101044350.4502@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 12:00 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>
> --snip--
>
> Hi Amir,
>
> that is why I spoke with several dm people and all of them had the same
> opinion. When you are not using the advantage of being at fs level,
> there is no reason to have shapshoting at this level.
>
> And no, I am not blinded. I am trying to understand why is multisnap a
> huge win everyone is saying, so I already asked ejt to step in and
> give us an overview on how dm-multisnap works and why is it better
> than the old implementation. Also I am trying it myslef, and so far
> it works quite well. I might have some numbers later.
>

(Dropping LKML - had enough of that attention for 1 week...)

Hi Lukas,

So did you get any numbers? Joe said you were not able to get good results.

Did you come to understand the drawbacks of multisnap (physical fragmentation)?

Did it make you change your mind about ext4 snapshots?

I am planning to join the ext4 weekly call today and ask if people think that
we still have open issues with ext4 snapshots, which must be resolved
before the merge.

I have 2 questions that should be answered before the merge:
1. Should 32bit ext4 move to 48bit snapshot file format after the
format is implemented for 64bit ext4?
2. Should exclude bitmap be allocated only on mkfs time or should it
also be possible to allocate it with tune2fs?
Allocating it later will enable snapshots on existing fs, but will
have sub-optimal on-disk layout.

If anyone has opinions on these 2 questions, please make them heard here or on
the call today.

Thanks,
Amir.
