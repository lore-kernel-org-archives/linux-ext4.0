From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not empty
Date: Thu, 19 Apr 2012 22:56:24 +0800
Message-ID: <CANWLp00gJ59tYCCsxxJ_C2WHjQw2CP8wv7YzqgKrxO6bwsD6ew@mail.gmail.com>
References: <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi>
	<20120412160658.GA9697@gmail.com>
	<alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jouko Orava <jouko.orava@helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37612 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab2DSO4Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Apr 2012 10:56:25 -0400
Received: by pbcun15 with SMTP id un15so10334814pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2012 07:56:24 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 19, 2012 at 9:10 PM, Jouko Orava <jouko.orava@helsinki.fi> =
wrote:
> Hi Zheng,
>
> I can confirm the bug exists on latest RHEL 6 x86_64 kernels (2.6.32-=
220).
>
> On current mainline kernels all writes are limited to one page under =
2GB,
> which masks the problem. I have not checked if mainline 2.6.32 has th=
is
> limit or not. It does not matter: the limit is just a band-aid to pap=
er
> over filesystem bugs, and should not mean you don't fix filesystem bu=
gs.
>
> I can confirm the one line patch to fs/ext4/file.c does fix the probl=
em.
> I have test kernels based on 2.6.32-220.7.1.el6.x86_64 with only
> the patch applied, at
> =A0 =A0 =A0 =A0http://www.helsinki.fi/~joorava/kernel/
> if anyone else is interested in testing.
>
> I did some (limited) testing on ext4 with the patch. It fixes the pro=
blem:
> large writes work very well too. No problems popped up in testing.
>
> Tested-by: Jouko Orava <jouko.orava@helsinki.fi>
>
>
> I'd also like to point at the real bug here, in Jouni's original stra=
ce:
>
> =A0 =A0 =A0 =A0writev(3, [{"\0\0\0\0\0\0\0\0", 8}, {"", 2147483648}],=
 2) =3D -2147483640
>
> The syscall returns a negative value, which is not the actual number =
of
> bytes written (since it is 32-bit wrapped), and errno has not been
> changed. There is no way for userspace to handle this result correctl=
y!
>
> There is no way anyone sane should just gloss over this saying
> "programmer fault, you're doing it wrong".
> This is a real bug, and deserves fixing sooner rather than later.
>
> Thanks,
> =A0 Jouko Orava

Hi Jouko,

Thanks for testing.  I don't test this bug in redhat kernel.  As Eric s=
aid, he
will fix it if it exists.  I think that it might be in stable kernel.
So I will dig it
in stable kernel.

Regards,
Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
