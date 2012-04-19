From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not empty
Date: Thu, 19 Apr 2012 23:28:36 +0800
Message-ID: <CANWLp02j-S8rcDHCMXRveY8ypo2vxy6306iC=zP-gVPLFVjtxw@mail.gmail.com>
References: <20120412160658.GA9697@gmail.com>
	<793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi>
	<alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi>
	<4F901E0C.3010008@redhat.com>
	<alpine.LRH.2.00.1204191731340.17249@ruuvi.it.helsinki.fi>
	<4F9024F1.3000806@redhat.com>
	<alpine.LRH.2.00.1204191803360.19837@ruuvi.it.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Jouko Orava <jouko.orava@helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2DSP2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Apr 2012 11:28:37 -0400
Received: by pbcun15 with SMTP id un15so10369065pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2012 08:28:36 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.00.1204191803360.19837@ruuvi.it.helsinki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 19, 2012 at 11:09 PM, Jouko Orava <jouko.orava@helsinki.fi>=
 wrote:
>> No, RHEL kernels have the same limits.
>
> That means at least 2.6.32.x stable series will suffer from the same =
bug.
> I'll see if I can test those mainline kernels too this weekend.

Great!  Please test it in stable kernels because I am afraid that I
couldn't do this work at this weekend. :-)

Regards,
Zheng

>
>> Whoops, I just filed one as well. =A0I'll dup yours to mine since I'=
ve already
>> started the process there.
>
> That's excellent, thank you. Mine was unacceptably terse anyway :)
>
> Thanks,
> =A0Jouko
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
